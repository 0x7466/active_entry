require "rails_helper"

describe "Controller methods" do
  let(:dummy_class) { Class.new { include ActiveEntry } }

  # Define restful actions
  before { dummy_class.define_method(:index) {} }
  before { dummy_class.define_method(:new) {} }
  before { dummy_class.define_method(:create) {} }
  before { dummy_class.define_method(:show) {} }
  before { dummy_class.define_method(:edit) {} }
  before { dummy_class.define_method(:update) {} }
  before { dummy_class.define_method(:destroy) {} }

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
    before { dummy_class.define_method(:action_name) { "index" } }

    it "does not raise error" do
      expect{ dummy_class.new.index_action? }.to_not raise_error
    end
    
    it_behaves_like "checker for action name", :index_action?, :index, true
    
    [:new, :create, :show, :edit, :update, :destroy].each do |action_name|
      it_behaves_like "checker for action name", :index_action?, action_name, false
    end
  end
  
  describe "#create_action?" do
    before { dummy_class.define_method(:action_name) { "create" } }

    it "does not raise error" do
      expect{ dummy_class.new.create_action? }.to_not raise_error
    end
    
    [:new, :create].each do |action_name|
      it_behaves_like "checker for action name", :create_action?, action_name, true
    end
    
    [:index, :show, :edit, :update, :destroy].each do |action_name|
      it_behaves_like "checker for action name", :create_action?, action_name, false
    end
  end
  
  describe "#show_action?" do
    before { dummy_class.define_method(:action_name) { "show" } }

    it "does not raise error" do
      expect{ dummy_class.new.show_action? }.to_not raise_error
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

  describe "dynamic helper methods" do
    let(:action_name) { "special_something" }

    before { dummy_class.define_method(:action_name) { "special_something" } }

    context "method to test is defined" do
      before { dummy_class.define_method(action_name.to_sym) {} }

      it "does not raise error for #special_something_action?" do
        expect{ dummy_class.new.special_something_action? }.to_not raise_error
      end

      context "#action_name missing" do
        before { dummy_class.remove_method(:action_name) }

        it "raises NoMethodError" do
          expect{ dummy_class.new.special_something_action? }.to raise_error NoMethodError
        end
      end
    end

    context "method to test is not defined" do
      it "raises error for #special_something_action?" do
        expect{ dummy_class.new.special_something_action? }.to raise_error NoMethodError
      end
    end
  end
end
