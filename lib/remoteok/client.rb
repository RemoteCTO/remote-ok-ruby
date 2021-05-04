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

    def with_fetch(params = {})
      response = self.class.get @base_url, { query: params }
      @data = JSON.parse(response.body)
      self
    end

    def legal
      with_fetch unless @data
      @data.first['legal']
    end

    def jobs(*tags)
      with_fetch tags: stringify(tags) unless @data
      @data[1..].map { |job_data| RemoteOK::Job.new(job_data) }
    end

    private

    def stringify(tags)
      return unless tags && tags.any?
      tags.map { |tag| tag.to_s.gsub('_', ' ') }.join ','
    end
  end
end
