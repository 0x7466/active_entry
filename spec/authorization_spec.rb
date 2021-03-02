require "spec_helper"

describe "Authorization" do
  let(:dummy_class) { Class.new { include ActiveEntry } }
  
  it 'raises `AuthorizationNotPerformedError` if #authorized? is not defined' do
    expect{ dummy_class.new.authorize! }.to raise_error ActiveEntry::AuthorizationNotPerformedError
  end

  it 'raises `NotAuthorizedError` if #authorized? returns false' do
    dummy_class.class_eval { def authorized?; false; end }
    expect{ dummy_class.new.authorize! }.to raise_error ActiveEntry::NotAuthorizedError
  end

  it 'raises `NotAuthorizedError` if #authorized? with argument returns false' do
    dummy_class.class_eval { def authorized?(error); false; end }
    expect{ dummy_class.new.authorize! }.to raise_error ActiveEntry::NotAuthorizedError
  end

  it 'raises `NotAuthorizedError` if #authorized? with argument and custom error returns false' do
    dummy_class.class_eval do
      def authorized?(error)
        error[:code] = "DEMO_CODE"
        error[:message] = "Demo message"
        false
      end
    end

    begin
      dummy_class.new.authorize!
      expect(false).to be true  # Don't get to this point!
    rescue ActiveEntry::NotAuthorizedError => e
      error = e.error

      expect(error[:code]).to eq "DEMO_CODE"
      expect(error[:message]).to eq "Demo message"
    end
  end

  it 'raises no exception if #authorized? returns true' do
    dummy_class.class_eval { def authorized?; true; end }
    expect{ dummy_class.new.authorize! }.to_not raise_error
  end

  it 'raises no exception if #authorized? with argument returns true' do
    dummy_class.class_eval { def authorized?(error); true; end }
    expect{ dummy_class.new.authorize! }.to_not raise_error
  end
end
