# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JSONAPI::ActsAsResourceController
  # noinspection RailsParamDefResolve
  before_action :doorkeeper_authorize!
end
