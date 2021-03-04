class TestController < ApplicationController
  def non_restful
    head :no_content
  end

  private

  def authenticated?
  end

  def authorized?
  end
end
