# frozen_string_literal: true

module RemoteOK
  # Client class to interact with the API itself
  class Client
    require 'json'
    require 'httparty'
    require_relative 'job'

    include HTTParty

    def initialize(config = {})
      @base_url = config[:base_url] || 'https://remoteok.io/api'
    end

    def with_fetch
      response = self.class.get @base_url
      @data = JSON.parse(response.body)
      self
    end

    def legal
      with_fetch unless @data
      @data.first['legal']
    end

    def jobs
      with_fetch unless @data
      jobs = []
      @data[1..].each do |job_data|
        jobs << RemoteOK::Job.new(job_data)
      end
      jobs
    end
  end
end
