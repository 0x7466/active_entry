require "rails_helper"

describe TestController, type: :controller do
  it "responds to #authenticate!" do
    expect(controller.methods).to include :authenticate!
  end

  it "responds to #authorize!" do
    expect(controller.methods).to include :authorize!
  end

  describe "controller methods" do
    context "#non_restful_action?" do
      it "does not raise an error" do
        expect{ controller.non_restful_action? }.to_not raise_error
      end

      it 'is true if action is #non_restful' do
        get :non_restful
        expect(controller.non_restful_action?).to be true
      end
    end

    context "action missing" do
      it "raises a NoMethodError" do
        expect{ controller.non_existent_action? }.to raise_error NoMethodError
      end
    end
  end
end
