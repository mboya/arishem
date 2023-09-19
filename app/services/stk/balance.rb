# frozen_string_literal: true
require 'stk/access_token'
require 'stk/helpers/security_credential'

module Stk
  class Balance

    class << self
      def check_balance(hash = {})
        new(hash['key'], hash['secret'], hash['queue'], hash['result']).send_request
      end
    end

    attr_reader :token, :key, :secret, :queue_url, :result_url

    def initialize(key, secret, queue_url, result_url)
      @token = Stk::AccessToken.call(key, secret)
      @queue_url = queue_url.nil? ? ENV['QueueTimeOutURL'] : queue_url
      @key = key.nil? ? ENV['key'] : key
      @secret = secret.nil? ? ENV['secret'] : secret
      @result_url = result_url.nil? ? ENV['ResultURL'] : result_url
    end

    def send_request
      response = HTTParty.post(uri, headers: _headers, body: _body)
      JSON.parse(response.body)
    end

    private

    def uri
      "#{ENV['base_url']}#{ENV['account_balance_url']}"
    end

    def _headers
      {
        'Authorization' => "Bearer #{token}",
        'Content-Type' => 'application/json'
      }
    end

    def _body
      {
        Initiator: ENV['InitiatorName'],
        SecurityCredential: _security_credentials,
        CommandID: 'AccountBalance',
        PartyA: ENV['PartyA'],
        IdentifierType: '4',
        Remarks: 'ok',
        QueueTimeOutURL: queue_url,
        ResultURL: result_url
      }.to_json
    end

    def _security_credentials
      Stk::Helpers::SecurityCredential.check_sec_cred
    end
  end
end
