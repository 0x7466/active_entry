class AuthorizationVerificationTestController < ApplicationController
  after_action :verify_authorization!
  before_action :authorize!, only: :authorization_performed

  def authorization_not_performed
    head :no_content
  end

  def authorization_performed_authorized?
    true
  end
  def authorization_performed
    head :no_content
  end
end
