require "rails_helper"

describe "ActiveEntry::Base" do
  shared_examples "an ActiveEntry class" do |base_class|
    subject { Class.new base_class }

    it { is_expected.to respond_to :pass? }
  
    context "if index? is false" do
      before { subject.define_method(:index?) { false } }

      it "is false for action index" do
        expect(subject.pass?(:index)).to be false
      end
    end

    context "if index? is true" do
      before { subject.define_method(:index?) { true } }

      it "is false for action index" do
        expect(subject.pass?(:index)).to be true
      end
    end

    context "if index? is not defined" do
      it "raises ActiveEntry::AuthDecisionMakerMissingError" do
        expect{ subject.pass?(:index) }.to raise_error ActiveEntry::AuthDecisionMakerMissingError
      end
    end

    describe "arguments" do
      before { subject.define_method(:index?) { @instance_variable } }

      it "can receive arguments as hash which are set to instance variables" do
        str = "rand0m str1ng"
        expect(subject.pass?(:index, instance_variable: str)).to eq str
      end
    end
  end

  it_behaves_like "an ActiveEntry class", ActiveEntry::Base::Authentication
  it_behaves_like "an ActiveEntry class", ActiveEntry::Base::Authorization
end
