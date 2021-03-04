require "rails_helper"

describe "Authentication verification" do
  let(:dummy_class) { Class.new { include ActiveEntry } }
  let(:dummy_obj) { dummy_class.new }

  before { dummy_class.define_method(:action_name) { "index" } }

  it 'raises `AuthenticationNotPerformedError` if #authenticate! is not called' do
    expect{ dummy_obj.verify_authentication! }.to raise_error ActiveEntry::AuthenticationNotPerformedError
  end

  it 'does not raise error if @_authentication_done is true' do
    dummy_obj.instance_variable_set :@_authentication_done, true
    expect{ dummy_obj.verify_authentication! }.to_not raise_error
  end

  it 'does not raise error if #authenticate! is called' do
    dummy_class.define_method(:authenticated?) { true }

    expect do
      dummy_obj.authenticate!
      dummy_obj.verify_authentication!
    end.to_not raise_error
  end
  
  describe '#authenticate!' do
    it "sets @_authentication_done" do
      dummy_class.define_method(:authenticated?) { true }
      dummy_obj.authenticate!
      expect(dummy_obj.instance_variable_get(:@_authentication_done)).to be true
    end
  end
end