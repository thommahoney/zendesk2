require "zendesk2/version"

# dependencies
require 'addressable/uri'
require 'cistern'
require 'faraday'
require 'faraday_middleware'
require 'jwt'

# stdlib
require 'forwardable'
require 'logger'
require 'time'
require 'yaml'
require 'securerandom'

module Zendesk2
  def self.defaults
    @defaults ||= begin
                    config_path = File.expand_path("~/.zendesk2")
                    if File.exists?(config_path)
                      YAML.load_file(config_path)
                    else
                      {}
                    end
                  rescue ArgumentError
                    # some people don't have home directories
                    {}
                  end
  end

  def self.paging_parameters(options={})
    params = if url = options["url"]
               Addressable::URI.parse(url).query_values
             else
               options
             end

    Cistern::Hash.slice(params, "page", "per_page")
  end

  def self.uuid
    SecureRandom.uuid
  end

  def self.stringify_keys(hash)
    hash.inject({}) { |r,(k,v)| r.merge(k.to_s => v) }
  end

  def self.blank?(string)
    string.nil? || string == ""
  end
end

require 'zendesk2/attributes'
require 'zendesk2/error'
require 'zendesk2/searchable'
require 'zendesk2/logger'
require 'zendesk2/model'
require 'zendesk2/collection'
require 'zendesk2/paged_collection'

require 'zendesk2/client'
