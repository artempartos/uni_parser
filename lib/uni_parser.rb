require 'active_support/core_ext'
require 'mechanize'
require 'multi_json'
require 'round_robin'

require 'uni_parser/version'
require 'uni_parser/config'
require 'uni_parser/agent'
require 'uni_parser/proxy'
require 'uni_parser/proxy_list'

require 'uni_parser/page'

module UniParser
  Encoding.default_external = Encoding::UTF_8

  def self.configure
    @config = UniParser::Config.new
    yield @config
  end

  def self.config
    @config ||= UniParser::Config.new
  end

  def self.config_reset
    @config = UniParser::Config.new
  end

  class BaseError < StandardError
  end

  class TypeError < BaseError
  end

  class DecodeError < BaseError
  end

  class ConnectionError < BaseError
  end

  class InitError < BaseError
  end

end
