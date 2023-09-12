JSONAPI.configure do |config|
  config.resource_cache = Rails.cache
  config.resource_key_type = :uuid
  config.raise_if_parameters_not_allowed = true
  config.warn_on_route_setup_issues = true
  config.warn_on_missing_routes = true
  config.warn_on_performance_issues = true
  config.allow_transactions = true
end
