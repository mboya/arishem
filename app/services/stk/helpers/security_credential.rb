# frozen_string_literal: true

module Stk
  module Helpers
    class SecurityCredential

      class << self
        def check_sec_cred(hash = {})
          new(hash['password']).send(:generate)
        end
      end

      attr_reader :password

      def initialize(password)
        @password = password
      end

      def generate
        _public_key
      end

      private

      def _public_key
        x509_public_key = OpenSSL::X509::Certificate.new(File.read(Rails.root.join('app/services/stk/certificate',
                                                                                   'SandboxCertificate.cer')))
                                                    .public_key.to_s
        key = OpenSSL::PKey::RSA.new(x509_public_key)
        Base64.encode64(key.encrypt(_password)).split("\n").join
      end

      def _password
        return unless password.nil? || password.eql?('')
        if ENV['InitiatorPassword'].nil? || ENV['InitiatorPassword'].eql?('')
          raise StandardError, 'initiator password is not defined'
        end

        ENV['InitiatorPassword']

      end

    end
  end
end
