class TestController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def show
    head :no_content
  end

  def edit
  end
  
  def update
  end

  def destroy
  end

  def non_restful
    head :no_content
  end

  private

  def authenticated?

  end

  def authorized?

  end
end
