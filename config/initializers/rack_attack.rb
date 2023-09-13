# frozen_string_literal: true

module Rack
  class Attack
    throttle('0.0.0.0', limit: 5, period: 10.seconds, &:ip)

    throttle('/oauth/token/ip', limit: 5, period: 10.seconds) do |req|
      req.ip if req.path.eql?('/oauth/token') && req.post?
    end
  end
end
