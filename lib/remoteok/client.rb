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
      @debug = config[:debug]
      @user_agent = config[:user_agent] || default_user_agent
    end

    def with_fetch(params = {})
      options = { 'User-Agent' => @user_agent }
      options[:query] = params if params && params.any?

      response = self.class.get @base_url, options

      @data = JSON.parse(response.body)
      self
    end

    def legal
      with_fetch unless @data
      @data.first['legal']
    end

    def jobs(*tags)
      options = { tags: stringify(tags) } if tags && tags.any?

      with_fetch options unless @data

      return unless @data.any?
      @data[1..].map { |job_data| RemoteOK::Job.new(job_data) }
    end

    private

    def stringify(tags = [])
      return unless tags.any?
      tags.map { |tag| tag.to_s.gsub('_', ' ') }.join ','
    end

    def default_user_agent
      "remote-ok-ruby/#{RemoteOK::VERSION} +http://github.com/IAmFledge/remote-ok-ruby"
    end
  end
end
