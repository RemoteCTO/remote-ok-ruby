# frozen_string_literal: true

RSpec.describe RemoteOK::Client do
  let(:job_data) { File.open 'spec/fixtures/jobs_data.json' }

  before do
    httpclient = double('HTTParty', body: job_data.read)
    allow(RemoteOK::Client).to receive(:get).and_return(httpclient)
  end

  it 'can instantiate' do
    expect(RemoteOK::Client.new).not_to be nil
  end

  describe 'User Agent' do
    it 'sends a default user agent with each request' do
      httpclient = double('HTTParty', body: '{}')
      exp_params = {
        headers: {
          'User-Agent' =>
            'remote-ok-ruby/0.1.0 +http://github.com/IAmFledge/remote-ok-ruby'
        }
      }

      expect(RemoteOK::Client).to(
        receive(:get)
        .with(anything, exp_params)
        .and_return(httpclient)
      )

      RemoteOK::Client.new.jobs
    end

    context 'when providing a custom user agent' do
      it 'sends the custom user agent instead of the default' do
        httpclient = double('HTTParty', body: '{}')
        exp_params = { headers: { 'User-Agent' => 'lovely-user-agent' } }

        expect(RemoteOK::Client).to(
          receive(:get)
          .with(anything, exp_params)
          .and_return(httpclient)
        )

        RemoteOK::Client.new(user_agent: 'lovely-user-agent').jobs
      end
    end
  end

  context 'Debug flag on' do
    it 'Requests HTTP debug output into the console' do
      httpclient = double('HTTParty', body: '{}')
      exp_params = {
        headers: { 'User-Agent' => '' },
        debug_output: $stdout
      }

      expect(RemoteOK::Client).to(
        receive(:get)
        .with(anything, exp_params)
        .and_return(httpclient)
      )

      RemoteOK::Client.new(user_agent: '', debug: true).jobs
    end
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

    context 'when providing tags' do
      let(:data) { File.open 'spec/fixtures/jobs_data.json' }
      let(:http_client) { double('HTTParty', body: data.read) }

      it 'provides the tags as parameters to the api' do
        httpclient = double('HTTParty', body: data.read)
        exp_params = {
          headers: { 'User-Agent' => '' },
          query: { tags: 'ruby,digital nomad' }
        }

        expect(RemoteOK::Client).to(
          receive(:get)
          .with(anything, exp_params)
          .and_return(httpclient)
        )

        RemoteOK::Client.new(user_agent: '').jobs :ruby, :digital_nomad
      end
    end
  end
end
