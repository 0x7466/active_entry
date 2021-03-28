class TestController < ApplicationController
  include ActiveEntry::ControllerConcern

  def unauthenticated
    pass!
    head :no_content
  end

  def authenticated_unauthorized
    pass!
    head :no_content
  end

  def authenticated_authorized
    pass!
    head :no_content
  end
end
