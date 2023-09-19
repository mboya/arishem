# frozen_string_literal: true

module Stk
  class C2b

    class << self
      def simulate(amount, recipient)
        new(amount, recipient).send_request
      end
    end

    attr_reader :amount, :recipient, :token, :key, :secret

    def initialize(amount, recipient)
      @key = ENV['key']
      @secret = ENV['secret']
      @token = Stk::AccessToken.call(key, secret)
      @amount = amount
      @recipient = recipient
    end

    def send_request
      response = HTTParty.post(uri, headers: _headers, body: _body)
      puts token
      puts _body
      JSON.parse(response.body)
    end

    private

    def uri
      "#{ENV['base_url']}#{ENV['c2b_simulate_uri']}"
    end

    def _headers
      {
        'Authorization' => "Bearer #{token}",
        'Content-Type' => 'application/json'
      }
    end

    def _body
      {
        ShortCode: ENV['PartyA'],
        CommandID: 'CustomerBuyGoodsOnline',
        Amount: amount.to_i,
        Msisdn: recipient,
        BillRefNumber: ''
      }.to_json
    end

  end
end
