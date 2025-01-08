# frozen_string_literal: true

RSpec.describe RemoteOK::Client do
  let(:job_data) { File.read("spec/fixtures/jobs_data.json") }
  let(:http_response) { instance_double(Async::HTTP::Protocol::Response, body: job_data) }
  let(:internet) { instance_double(Async::HTTP::Internet) }
  let(:client) { described_class.new }

  before do
    allow(Async::HTTP::Internet).to receive(:new).and_return(internet)
    allow(internet).to receive(:get).and_return(http_response)
    allow(http_response).to receive(:read).and_return(job_data)
  end

  it "can instantiate" do
    expect(described_class.new).not_to be_nil
  end

  describe "User Agent" do
    before { client.with_fetch }

    let(:user_agent) do
      "remote-ok-ruby/#{RemoteOK::VERSION} " \
      "+http://github.com/RemoteCTO/remote-ok-ruby"
    end

    it "sends a default user agent with each request" do
      expect(internet).to have_received(:get).with(
        instance_of(URI::HTTPS),
        hash_including("User-Agent" => user_agent)
      )
    end

    context "when providing a custom user agent" do
      before { described_class.new(user_agent: "lovely-user-agent").with_fetch }

      it "sends the custom user agent instead of the default" do
        expect(internet).to have_received(:get).with(
          instance_of(URI::HTTPS),
          hash_including("User-Agent" => "lovely-user-agent")
        )
      end
    end
  end

  # rubocop:disable RSpec/MultipleExpectations
  describe "Jobs" do
    let(:data) { File.read("spec/fixtures/jobs_data.json") }

    before { client.jobs(:ruby, :digital_nomad) }

    it "uses https" do
      expect(internet).to have_received(:get) do |uri, headers|
        expect(uri).to be_a(URI::HTTPS)
      end
    end

    it "provides the tags as parameters to the api" do
      expect(internet).to have_received(:get) do |uri, headers|
        expect(uri.query).to include("tags=ruby%2Cdigital+nomad")
      end
    end

    it "returns an array of Job objects" do
      expect(client.jobs.first).to be_a(RemoteOK::Job)
    end

    it "returns the correct number of items" do
      expect(client.jobs.size).to eq(3)
    end
  end
  # rubocop:enable RSpec/MultipleExpectations

  describe "Legal" do
    it "fetches legal information" do
      legal_info = client.legal

      expect(legal_info).to eq(JSON.parse(job_data).first["legal"])
    end

    it "can be chained with fetch to force refresh" do
      legal_info = client.with_fetch.legal

      expect(legal_info).to eq(JSON.parse(job_data).first["legal"])
    end
  end
end
