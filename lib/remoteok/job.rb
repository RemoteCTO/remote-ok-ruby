# frozen_string_literal: true

module RemoteOK
  # Class representing a single job from RemoteOK with data accessors.
  class Job
    require 'date'

    attr_reader :raw

    HTML_CHARS_REGEX = /<("[^"]*"|'[^']*'|[^'">])*>/.freeze

    def initialize(job_data)
      @raw = job_data
    end

    def slug
      raw['slug']
    end

    def id
      return unless raw['id']

      Integer raw['id']
    end

    def epoch
      return unless raw['epoch']

      Integer raw['epoch']
    end

    def date
      return unless raw['date']

      DateTime.parse raw['date']
    end

    def company
      raw['company']
    end

    def company_logo
      raw['company_logo']
    end

    def position
      raw['position']
    end

    def tags
      return unless raw['tags']

      raw['tags'].map do |tag|
        tag.gsub(' ', '_').to_sym
      end
    end

    def logo
      raw['logo']
    end

    def description
      raw['description']
    end

    def description_text
      return unless raw['description']

      raw['description'].gsub(HTML_CHARS_REGEX, ' ').strip.gsub(/\s+/, ' ')
    end

    def location
      raw['location']
    end

    def original
      raw['original']
    end

    def url
      raw['url']
    end

    def apply_url
      raw['apply_url']
    end
  end
end
