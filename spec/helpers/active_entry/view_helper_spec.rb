require "rails_helper"

RSpec.describe ActiveEntry::ViewHelper, type: :helper do
  let(:policy_name) { "view_helper_test_policy" }
  let(:controller_name) { "view_helper_test_controller" }
  let(:action_name) { "test" }
  let(:decision_maker_name) { [action_name, "?"].join }

  shared_examples :add_view_helper do
    before do
      module ViewHelperTestPolicy
        class Authorization < ActiveEntry::Base::Authorization
        end
      end
    end
    after { Object.send :remove_const, :ViewHelperTestPolicy }
  end

  describe "#authorized_for?" do
    context "if policy exists" do
      include_examples :add_view_helper

      it "raises ActiveEntry::DecisionMakerMethodNotDefinedError" do
        expect{ helper.authorized_for?(controller_name, action_name) }.to raise_error ActiveEntry::DecisionMakerMethodNotDefinedError
      end

      context "if decision maker is true" do
        before { ViewHelperTestPolicy::Authorization.define_method(decision_maker_name) { true } }

        it "is true" do
          expect(helper.authorized_for?(controller_name, action_name)).to be true
        end

        context "if controller name is without Controller suffix" do
          it "is true" do
            expect(helper.authorized_for?(controller_name.remove("_controller"), action_name)).to be true
          end
        end
      end

      context "if decision maker is false" do
        before { ViewHelperTestPolicy::Authorization.define_method(decision_maker_name) { false } }

        it "is false" do
          expect(helper.authorized_for?(controller_name, action_name)).to be false
        end

        context "if controller name is without Controller suffix" do
          it "is false" do
            expect(helper.authorized_for?(controller_name.remove("_controller"), action_name)).to be false
          end
        end
      end
    end

    context "if policy does not exist" do
      it "raises ActiveEntry::NotDefinedError" do
        expect{ helper.authorized_for?(controller_name, action_name) }.to raise_error ActiveEntry::NotDefinedError
      end
    end
  end

  describe "#link_to_if_authorized" do
    context "if authorized" do
      it "is a link" do
        expect(helper.link_to_if_authorized("demo", "/authenticated_authorized")).to eq "<a href=\"/authenticated_authorized\">demo</a>"
      end

      context "with args" do
        it "is a link" do
          expect(helper.link_to_if_authorized("demo", "/authenticated_authorized_with_arg", arg: :demo)).to eq "<a href=\"/authenticated_authorized_with_arg\">demo</a>"
        end
      end
    end

    context "if not authorized" do
      it "is nil" do
        expect(helper.link_to_if_authorized("demo", "/authenticated_unauthorized")).to be nil
      end
    end
  end
end
