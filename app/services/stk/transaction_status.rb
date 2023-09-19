# frozen_string_literal: true

module Stk
  class TransactionStatus

    class << self
      def status(code)
        new(code).send_request
      end
    end

    attr_reader :code, :key, :secret, :token, :res, :result_url, :queue_url

    def initialize(code)
      @key = ENV['key']
      @secret = ENV['secret']
      @token = Stk::AccessToken.call(key, secret)
      @code = code
      @result_url = ENV['ResultURL']
      @queue_url = ENV['QueueTimeOutURL']
    end

    def send_request
      response = HTTParty.post(uri, headers: _headers, body: _body)
      JSON.parse(response.body)
    end

    private

    def uri
      "#{ENV['base_url']}#{ENV['transaction_status_uri']}"
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
        CommandID: 'TransactionStatusQuery',
        TransactionID: 'OEI2AK4Q16',
        PartyA: ENV['PartyA'],
        IdentifierType: 4,
        ResultURL: result_url,
        QueueTimeOutURL: queue_url,
        Remarks: 'ok',
        Occassion: 'ok'
      }.to_json
    end

    def _security_credentials
      Stk::Helpers::SecurityCredential.check_sec_cred
    end

  end
end
