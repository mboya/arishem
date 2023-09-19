# frozen_string_literal: true

module Stk
  class B2c

    class << self
      def send_funds(amount, recipient, hash = {})
        new(amount, recipient, hash['key'], hash['secret'], hash['queue'], hash['result']).send_request
      end
    end

    attr_reader :amount, :recipient, :token, :key, :secret, :result_url, :queue_url

    def initialize(amount, recipient, key, secret, queue_url, result_url)
      @key = key.nil? ? ENV['key'] : key
      @secret = secret.nil? ? ENV['secret'] : secret
      @token = Stk::AccessToken.call(key, secret)
      @queue_url = queue_url.nil? ? ENV['QueueTimeOutURL'] : queue_url
      @result_url = result_url.nil? ? ENV['ResultURL'] : result_url
      @amount = amount
      @recipient = recipient
    end

    def send_request
      response = HTTParty.post(uri, headers: _headers, body: _body)
      puts _body
      JSON.parse(response.body)
    end

    private

    def uri
      "#{ENV['base_url']}#{ENV['b2c_uri']}"
    end

    def _headers
      {
        'Authorization' => "Bearer #{token}",
        'Content-Type' => 'application/json'
      }
    end

    def _body
      {
        OriginatorConversationID: SecureRandom.uuid,
        InitiatorName: ENV['InitiatorName'],
        SecurityCredential: _security_credentials,
        CommandID: 'BusinessPayment',
        Amount: amount,
        PartyA: ENV['PartyA'],
        PartyB: recipient,
        Remarks: 'ok',
        QueueTimeOutURL: queue_url,
        ResultURL: result_url,
        occasion: 'ok'
      }.to_json
    end

    def _security_credentials
      Stk::Helpers::SecurityCredential.check_sec_cred
    end

  end
end
