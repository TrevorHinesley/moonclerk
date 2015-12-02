require "faraday"
require "json"

# Version
require "moonclerk/version"

# API Operations
require "moonclerk/api_operations/list"
require "moonclerk/api_operations/request"

# Resources
require "moonclerk/moonclerk_object"
require "moonclerk/api_resource"
require "moonclerk/list_object"
require "moonclerk/customer"
require "moonclerk/form"
require "moonclerk/payment"
require "moonclerk/util"

# Errors
require "moonclerk/errors/moonclerk_error"
require "moonclerk/errors/api_error"
require "moonclerk/errors/authentication_error"
require "moonclerk/errors/invalid_request_error"

module Moonclerk
  API_BASE = "https://api.moonclerk.com"
  API_VERSION = 1
  DEFAULT_CA_BUNDLE_PATH = File.join(File.dirname(__FILE__), '/data/ca_certificates.crt')

  @verify_ssl_certs = true

  class << self
    attr_accessor :api_key, :verify_ssl_certs, :env
  end

  def self.request(method, url, params = {})
    unless env
      env = Rails.env
    end

    env = env.to_sym unless env.is_a?(Symbol)

    unless api_key
      raise AuthenticationError.new('No API key provided. ' \
        'Set your API key using "Moonclerk.api_key = <API-KEY>". ' \
        'You can generate API keys from the Moonclerk web interface' \
        'by logging in at moonclerk.com.')
    end

    if api_key =~ /\s/
      raise AuthenticationError.new('Your API key is invalid, as it contains ' \
        'whitespace. (HINT: You can double-check your API key from the ' \
        'MoonClerk web interface by logging in at moonclerk.com.)')
    end

    if verify_ssl_certs
      ssl_options = {
        ssl: {
          ca_file: Moonclerk::DEFAULT_CA_BUNDLE_PATH
        }
      }
    else
      ssl_options = { 
        ssl: { 
          verify: false
        }
      }
      unless @verify_ssl_warned
        @verify_ssl_warned = true
        $stderr.puts("WARNING: Running without SSL cert verification. " \
          "You should never do this in production. " \
          "Execute 'Moonclerk.verify_ssl_certs = true' to enable verification.")
      end
    end

    connection = Faraday.new(ssl_options)
    response = connection.send(method, url, params, headers)
    parsed_response = JSON.parse(response.body)
    symbolized_response = Util.symbolize_names(parsed_response)

    if symbolized_response[:error]
      handle_api_error(response)
    else
      symbolized_response[symbolized_response.keys.first]
    end
  end

  def self.headers
    {
      "Authorization" => "Token token=#{api_key}",
      "Accept" => "application/vnd.moonclerk+json;version=#{API_VERSION}"
    }
  end

  def self.default_param_keys
    [:count, :offset]
  end

  def self.general_api_error(status, response_body)
    APIError.new("Invalid response object from API: #{response_body.inspect} " +
                 "(HTTP response code was #{status})", status, response_body)
  end

  def self.handle_api_error(response)
    begin
      error_obj = JSON.parse(response.body)
      error_obj = Util.symbolize_names(error_obj)
      error = error_obj[:error]
      raise MoonclerkError.new unless error && error.is_a?(Hash)

    rescue JSON::ParserError, StripeError
      raise general_api_error(response.status, response.body)
    end

    case response.status
    when 400, 404
      raise invalid_request_error(error, response, error_obj)
    when 401
      raise authentication_error(error, response, error_obj)
    else
      raise api_error(error, response, error_obj)
    end
  end

  def self.invalid_request_error(error, response, error_obj)
    InvalidRequestError.new(error[:message], response.status, response.body, error_obj, 
                            response.headers)
  end

  def self.authentication_error(error, response, error_obj)
    AuthenticationError.new(error[:message], response.status, response.body, error_obj,
                            response.headers)
  end

  def self.api_error(error, response, error_obj)
    APIError.new(error[:message], response.status, response.body, error_obj, response.headers)
  end
end
