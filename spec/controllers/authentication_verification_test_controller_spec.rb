require 'rails_helper'

describe AuthenticationVerificationTestController, type: :controller do
  describe "#authentication_not_performed" do
    it "does raise error" do
      expect{ get :authentication_not_performed }.to raise_error ActiveEntry::AuthenticationNotPerformedError
    end
  end

  describe "#authentication_performed" do
    it "does not raise error" do
      expect{ get :authentication_performed }.to_not raise_error
    end
  end
end
