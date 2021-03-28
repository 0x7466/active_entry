require "rails_helper"

RSpec.describe TestController, type: :controller do
  describe "#unauthenticated" do
    it "raises NotAuthenticatedError" do
      expect{ get :unauthenticated }.to raise_error ActiveEntry::NotAuthenticatedError
    end
  end

  describe "#authenticated_unauthorized" do
    it "raises NotAuthorizedError" do
      expect{ get :authenticated_unauthorized }.to raise_error ActiveEntry::NotAuthorizedError
    end
  end

  describe "#authenticated_authorized" do
    it "raises no error" do
      expect{ get :authenticated_authorized }.to_not raise_error
    end
  end
end
