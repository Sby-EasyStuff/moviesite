class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from Google::Apis::ClientError, :with => :client_error_handling
  rescue_from Google::Apis::AuthorizationError, with => :oauth_error_handling
end
