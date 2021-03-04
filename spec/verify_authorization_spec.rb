require "rails_helper"

describe "Authorization verification" do
  let(:dummy_class) { Class.new { include ActiveEntry } }
  let(:dummy_obj) { dummy_class.new }

  before { dummy_class.define_method(:action_name) { "index" } }

  it 'raises `AuthorizationNotPerformedError` if #authorize! is not called' do
    expect{ dummy_obj.verify_authorization! }.to raise_error ActiveEntry::AuthorizationNotPerformedError
  end

  it 'does not raise error if @_authorization_done is true' do
    dummy_obj.instance_variable_set :@_authorization_done, true
    expect{ dummy_obj.verify_authorization! }.to_not raise_error
  end

  it 'does not raise error if #authenticate! is called' do
    dummy_class.define_method(:authorized?) { true }

    expect do
      dummy_obj.authorize!
      dummy_obj.verify_authorization!
    end.to_not raise_error
  end
  
  it 'does not raise error if #authorize! was called but failed because not authorized' do
    dummy_class.define_method(:authorized?) { false }

    begin
      dummy_obj.authorize!
    rescue ActiveEntry::NotAuthorizedError
    end

    expect{ dummy_obj.verify_authorization! }.to_not raise_error
  end
  
  describe '#authorize!' do
    it "sets @_authorization_done" do
      dummy_class.define_method(:authorized?) { true }
      dummy_obj.authorize!
      expect(dummy_obj.instance_variable_get(:@_authorization_done)).to be true
    end
  end
end