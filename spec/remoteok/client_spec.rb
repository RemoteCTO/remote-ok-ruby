# frozen_string_literal: true

RSpec.describe RemoteOK::Client do
  before do
    data = File.open 'spec/fixtures/jobs_data.json'
    httpclient = double('HTTParty', body: data.read)
    allow(RemoteOK::Client).to receive(:get).and_return(httpclient)
  end

  it 'can instantiate' do
    expect(RemoteOK::Client.new).not_to be nil
  end

  describe 'legal' do
    it 'outputs the RemoteOK legal text' do
      expect(RemoteOK::Client.new.legal).to start_with 'API Terms of Service'
    end

    it 'can be chained with fetch to force refresh' do
      expect(RemoteOK::Client.new.with_fetch.legal).to start_with 'API Terms of Service'
    end
  end

  describe 'jobs' do
    it 'returns the correct number of items' do
      expect(RemoteOK::Client.new.jobs.size).to eq 3
    end

    it 'returns an array of Job objects' do
      expect(RemoteOK::Client.new.jobs.first).to be_a RemoteOK::Job
    end

    context 'when there are no jobs' do
      before do
        nj_data = File.open 'spec/fixtures/no_jobs.json'
        httpclient = double('HTTParty', body: nj_data.read)
        allow(RemoteOK::Client).to receive(:get).and_return(httpclient)
      end

      it 'returns zero jobs' do
        expect(RemoteOK::Client.new.jobs.size).to eq 0
      end
    end
  end
end
