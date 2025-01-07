# frozen_string_literal: true

RSpec.describe RemoteOK::Client do
  let(:job_data) { File.read("spec/fixtures/jobs_data.json") }
  let(:http_response) { instance_double(Async::HTTP::Protocol::Response, body: job_data) }
  let(:internet) { instance_double(Async::HTTP::Internet) }
  let(:client) { described_class.new }

  before do
    allow(Async::HTTP::Internet).to receive(:new).and_return(internet)
    allow(internet).to receive(:get).and_return(http_response)
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
  end
  # rubocop:enable RSpec/MultipleExpectations

  describe "Legal" do
    it "fetches legal information" do
      legal_info = client.legal

      expect(legal_info).to eq(JSON.parse(job_data).first["legal"])
    end
  end
  # let(:job_data) { File.open "spec/fixtures/jobs_data.json" }

  # before do
  #   instance_double("HTTParty", body: job_data.read)
  #   allow(described_class).to receive(:get).and_return(httpclient)
  # end

  # it "can instantiate" do
  #   expect(described_class.new).not_to be_nil
  # end

  # describe "User Agent" do
  #   it "sends a default user agent with each request" do
  #     httpclient = double("HTTParty", body: "{}")
  #     exp_params = {
  #       headers: {
  #         "User-Agent" =>
  #           "remote-ok-ruby/0.1.0 +http://github.com/RemoteCTO/remote-ok-ruby"
  #       }
  #     }

  #     expect(described_class).to(
  #       receive(:get)
  #       .with(anything, exp_params)
  #       .and_return(httpclient)
  #     )

  #     described_class.new.jobs
  #   end

  #   context "when providing a custom user agent" do
  #     it "sends the custom user agent instead of the default" do
  #       httpclient = double("HTTParty", body: "{}")
  #       exp_params = {headers: {"User-Agent" => "lovely-user-agent"}}

  #       expect(described_class).to(
  #         receive(:get)
  #         .with(anything, exp_params)
  #         .and_return(httpclient)
  #       )

  #       described_class.new(user_agent: "lovely-user-agent").jobs
  #     end
  #   end
  # end

  # context "Debug flag on" do
  #   it "Requests HTTP debug output into the console" do
  #     httpclient = double("HTTParty", body: "{}")
  #     exp_params = {
  #       headers: {"User-Agent" => ""},
  #       debug_output: $stdout
  #     }

  #     expect(described_class).to(
  #       receive(:get)
  #       .with(anything, exp_params)
  #       .and_return(httpclient)
  #     )

  #     described_class.new(user_agent: "", debug: true).jobs
  #   end
  # end

  # describe "legal" do
  #   it "outputs the RemoteOK legal text" do
  #     expect(described_class.new.legal).to start_with "API Terms of Service"
  #   end

  #   it "can be chained with fetch to force refresh" do
  #     expect(described_class.new.with_fetch.legal).to start_with "API Terms of Service"
  #   end
  # end

  # describe "jobs" do
  #   it "returns the correct number of items" do
  #     expect(described_class.new.jobs.size).to eq 3
  #   end

  #   it "returns an array of Job objects" do
  #     expect(described_class.new.jobs.first).to be_a RemoteOK::Job
  #   end

  #   context "when there are no jobs" do
  #     before do
  #       nj_data = File.open "spec/fixtures/no_jobs.json"
  #       httpclient = double("HTTParty", body: nj_data.read)
  #       allow(described_class).to receive(:get).and_return(httpclient)
  #     end

  #     it "returns zero jobs" do
  #       expect(described_class.new.jobs.size).to eq 0
  #     end
  #   end

  #   context "when providing tags" do
  #     let(:data) { File.open "spec/fixtures/jobs_data.json" }
  #     let(:http_client) { double("HTTParty", body: data.read) }

  #     it "provides the tags as parameters to the api" do
  #       httpclient = double("HTTParty", body: data.read)
  #       exp_params = {
  #         headers: {"User-Agent" => ""},
  #         query: {tags: "ruby,digital nomad"}
  #       }

  #       expect(described_class).to(
  #         receive(:get)
  #         .with(anything, exp_params)
  #         .and_return(httpclient)
  #       )

  #       described_class.new(user_agent: "").jobs :ruby, :digital_nomad
  #     end
  #   end
  # end
end
