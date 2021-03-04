class AuthenticationVerificationTestController < ApplicationController
  after_action :verify_authentication!
  before_action :authenticate!, only: :authentication_performed

  def authentication_not_performed
    head :no_content
  end

  def authentication_performed_authenticated?
    true
  end
  def authentication_performed
    head :no_content
  end
end
