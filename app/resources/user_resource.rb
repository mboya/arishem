# frozen_string_literal: true

class UserResource < JSONAPI::Resource
  caching
  attributes :phone, :country_code, :names, :first_name, :last_name, :status, :email, :password

  def fetchable_fields
    super - %i[first_name last_name status country_code email password]
  end

  def names
    "#{@model.last_name}, #{@model.first_name}"
  end
end
