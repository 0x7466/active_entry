require "rails_helper"

describe ActiveEntry::PolicyFinder do
  let(:class_name) { :Application }

  let(:define_application_policy_class) { ApplicationPolicy = Class.new }
  let(:undefine_application_policy_class) { Object.send :remove_const, :ApplicationPolicy }

  subject { ActiveEntry::PolicyFinder.new class_name }

  describe ".policy_for" do
    context "if application policy class defined" do
      before { define_application_policy_class }
      after { undefine_application_policy_class }

      it "is ApplicationPolicy" do
        expect(ActiveEntry::PolicyFinder.policy_for(class_name)).to eq(ApplicationPolicy)
      end
    end

    context "if application policy class defined" do
      it "raises NotDefinedError" do
        expect{ ActiveEntry::PolicyFinder.policy_for(class_name) }.to raise_error ActiveEntry::NotDefinedError
      end
    end
  end

  describe "#policy" do
    context "if application policy class defined" do
      before { define_application_policy_class }
      after { undefine_application_policy_class }

      it "is ApplicationPolicy" do
        expect(subject.policy).to eq(ApplicationPolicy)
      end
    end

    context "if application policy class defined" do
      it "raises NotDefinedError" do
        expect{ subject.policy }.to raise_error ActiveEntry::NotDefinedError
      end
    end
  end
end
