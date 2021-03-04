class ScopedDecisionMakerTestController < ApplicationController
  before_action :authenticate!, :authorize!

  def index_authenticated?
    return true
  end
  def index_authorized?
    return true
  end
  def index
    head :no_content
  end

  def custom_authenticated?
    return true
  end
  def custom
    head :no_content
  end

  def other_authorized?
    return true
  end
  def other
    head :no_content
  end

  def non_authenticated_authenticated?
    return false
  end
  def non_authenticated
  end

  def non_authorized_authorized?
    return false
  end
  def non_authorized
  end

  private

  def authenticated?
    return true
  end

  def authorized?
    return true
  end
end
