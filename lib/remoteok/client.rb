# frozen_string_literal: true

module RemoteOK
  # Client class to interact with the API itself
  class Client
    require "json"
    require "async/http/internet/instance"
    require_relative "job"

    def initialize(**config)
      @base_url = config[:base_url] || "https://remoteok.com/api"
      @user_agent = config[:user_agent] || default_user_agent
    end

    def with_fetch(params = {})
      uri = URI(@base_url)
      uri.query = URI.encode_www_form(params) if params&.any?

      headers = {"User-Agent" => @user_agent}

      @data = Sync do
        internet = Async::HTTP::Internet.new
        response = internet.get(uri, headers)
        JSON.parse(response.read)
      end

      self
    end

    def legal
      with_fetch unless @data
      @data.first["legal"]
    end

    def jobs(*tags)
      options = {tags: stringify(tags)} if tags&.any?

      with_fetch options unless @data

      return unless @data.any?

      @data[1..].map { |job_data| RemoteOK::Job.new(job_data) }
    end

    private

    def stringify(tags = [])
      return unless tags.any?

      tags.map { |tag| tag.to_s.tr("_", " ") }.join ","
    end

    def default_user_agent
      "remote-ok-ruby/#{RemoteOK::VERSION} +http://github.com/RemoteCTO/remote-ok-ruby"
    end
  end
end
