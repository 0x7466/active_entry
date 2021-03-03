require 'rails_helper'

describe ScopedDecisionMakerTestController, type: :controller do
  describe "#index" do
    it "does not raise error" do
      expect{ get :index }.to_not raise_error
    end
  end

  describe "#custom" do
    it "does not raise error" do
      expect{ get :custom }.to_not raise_error
    end
  end

  describe "#other" do
    it "does not raise error" do
      expect{ get :other }.to_not raise_error
    end
  end

  describe "#non_authenticated" do
    it "does raise error ActiveEntry::NotAuthenticatedError" do
      expect{ get :non_authenticated }.to raise_error ActiveEntry::NotAuthenticatedError
    end
  end

  describe "#non_authorized" do
    it "does raise error ActiveEntry::NotAuthorizedError" do
      expect{ get :non_authorized }.to raise_error ActiveEntry::NotAuthorizedError
    end
  end
end
