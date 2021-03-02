require "spec_helper"

describe "Controller methods" do
  let(:dummy_class) { Class.new { include ActiveEntry } }

  shared_examples "checker for action name" do |method_name, action_name, expectation|
    before { dummy_class.define_method(:action_name) { action_name.to_s } }

    it "is #{expectation} if #action_name \"#{action_name}\"" do
      expect(dummy_class.new.public_send(method_name)).to be expectation
    end
  end
  
  describe "#read_action?" do
    it "is defined" do
      expect(dummy_class.new).to respond_to :read_action?
    end
    
    [:index, :show].each do |action_name|
      it_behaves_like "checker for action name", :read_action?, action_name, true
    end
    
    [:new, :create, :edit, :update, :destroy].each do |action_name|
      it_behaves_like "checker for action name", :read_action?, action_name, false
    end
  end
  
  describe "#write_action?" do
    it "is defined" do
      expect(dummy_class.new).to respond_to :write_action?
    end
    
    [:new, :create, :edit, :update, :destroy].each do |action_name|
      it_behaves_like "checker for action name", :write_action?, action_name, true
    end
    
    [:index, :show].each do |action_name|
      it_behaves_like "checker for action name", :write_action?, action_name, false
    end
  end
  
  describe "#change_action?" do
    it "is defined" do
      expect(dummy_class.new).to respond_to :change_action?
    end
    
    [:edit, :update, :destroy].each do |action_name|
      it_behaves_like "checker for action name", :change_action?, action_name, true
    end
    
    [:index, :new, :create, :show].each do |action_name|
      it_behaves_like "checker for action name", :change_action?, action_name, false
    end
  end
  
  describe "#index_action?" do
    it "is defined" do
      expect(dummy_class.new).to respond_to :index_action?
    end
    
    it_behaves_like "checker for action name", :index_action?, :index, true
    
    [:new, :create, :show, :edit, :update, :destroy].each do |action_name|
      it_behaves_like "checker for action name", :index_action?, action_name, false
    end
  end
  
  describe "#show_action?" do
    it "is defined" do
      expect(dummy_class.new).to respond_to :show_action?
    end
    
    it_behaves_like "checker for action name", :show_action?, :show, true
    
    [:index, :new, :create, :edit, :update, :destroy].each do |action_name|
      it_behaves_like "checker for action name", :show_action?, action_name, false
    end
  end
  
  describe "#update_action?" do
    it "is defined" do
      expect(dummy_class.new).to respond_to :update_action?
    end
    
    [:edit, :update].each do |action_name|
      it_behaves_like "checker for action name", :update_action?, action_name, true
    end
    
    [:index, :new, :create, :show, :destroy].each do |action_name|
      it_behaves_like "checker for action name", :update_action?, action_name, false
    end
  end
  
  describe "#destroy_action?" do
    it "is defined" do
      expect(dummy_class.new).to respond_to :destroy_action?
    end
    
    it_behaves_like "checker for action name", :destroy_action?, :destroy, true
    
    [:index, :new, :create, :show, :edit, :update].each do |action_name|
      it_behaves_like "checker for action name", :destroy_action?, action_name, false
    end
  end
end
