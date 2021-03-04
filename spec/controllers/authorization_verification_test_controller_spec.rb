require 'rails_helper'

describe AuthorizationVerificationTestController, type: :controller do
  describe "#authorization_not_performed" do
    it "does raise error" do
      expect{ get :authorization_not_performed }.to raise_error ActiveEntry::AuthorizationNotPerformedError
    end
  end

  describe "#authorization_performed" do
    it "does not raise error" do
      expect{ get :authorization_performed }.to_not raise_error
    end
  end
end
