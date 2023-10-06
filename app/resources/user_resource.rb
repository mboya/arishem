# frozen_string_literal: true

# class UserResource
class UserResource < JSONAPI::Resource
  caching
  attributes :phone, :country_code, :names, :first_name, :last_name, :status, :email, :password, :wallet

  def fetchable_fields
    super - %i[first_name last_name status country_code email password]
  end

  def self.updatable_fields(context)
    super - %i[phone country_code]
  end

  def names
    "#{@model.last_name}, #{@model.first_name}"
  end

  def wallet
    @model.purse
  end
end
