require "spec_helper"

[[ActiveEntry::Base::Authentication, ActiveEntry::NotAuthenticatedError], [ActiveEntry::Base::Authorization, ActiveEntry::NotAuthorizedError]].each do |example|
  describe example[0] do
    let(:parent_entry_class) { example[0] }
    let(:auth_error) { example[1] }
    let(:app_entry) { Class.new parent_entry_class }
    let(:method_name) { :my_awesome_method }
    let(:args) { {} }
    subject { app_entry.new method_name, **args }

    shared_examples :define_decision_maker do |value|
      before { app_entry.define_method(:my_awesome_method?) { value } }
    end

    describe ".pass!" do
      it "raises DecisionMakerMethodNotDefinedError" do
        expect{ app_entry.pass! method_name }.to raise_error ActiveEntry::DecisionMakerMethodNotDefinedError
      end

      context "if #my_awesome_method? present in Entry" do
        context "and #my_awesome_method? is true" do
          include_examples :define_decision_maker, true

          it "is true" do
            expect(app_entry.pass!(method_name)).to be true
          end
        end

        shared_examples "NotAuthenticatedError raiser" do |value|
          include_examples :define_decision_maker, value

          it "raises NotAuthenticatedError" do
            expect{ app_entry.pass!(method_name) }.to raise_error auth_error
          end
        end

        it_behaves_like "NotAuthenticatedError raiser", false
        it_behaves_like "NotAuthenticatedError raiser", ""
        it_behaves_like "NotAuthenticatedError raiser", nil
      end
    end

    describe "#pass?" do
      context "if #my_awesome_method? present" do
        context "and #my_awesome_method? is true" do
          include_examples :define_decision_maker, true

          it "is true" do
            expect(subject.pass?).to be true
          end
        end

        shared_examples "falser" do |value|
          include_examples :define_decision_maker, value

          it "is false" do
            expect(subject.pass?).to be false
          end
        end

        it_behaves_like "falser", false
        it_behaves_like "falser", ""
        it_behaves_like "falser", nil

        context "and #my_awesome_method? is not defined" do
          it "it raises DecisionMakerMethodNotDefinedError" do
            expect{ subject.pass? }.to raise_error ActiveEntry::DecisionMakerMethodNotDefinedError
          end
        end
      end
    end

    describe '#success' do
      it "is true" do
        expect(subject.success).to be true
      end
    end
  end
end
