require "spec_helper"

describe "Authentication" do
  let(:dummy_class) { Class.new { include ActiveEntry } }

  it 'raises `AuthenticationNotPerformedError` if #authenticated? is not defined' do
    expect{ dummy_class.new.authenticate! }.to raise_error ActiveEntry::AuthenticationNotPerformedError
  end

  it 'raises `NotAuthenticatedError` if #authenticated? returns false' do
    dummy_class.class_eval { def authenticated?; false; end }
    expect{ dummy_class.new.authenticate! }.to raise_error ActiveEntry::NotAuthenticatedError
  end

  it 'raises `NotAuthenticatedError` if #authenticated? with argument returns false' do
    dummy_class.class_eval { def authenticated?(error); false; end }
    expect{ dummy_class.new.authenticate! }.to raise_error ActiveEntry::NotAuthenticatedError
  end

  it 'raises `NotAuthenticatedError` if #authenticated? with argument and custom error returns false' do
    dummy_class.class_eval do
      def authenticated?(error)
        error[:code] = "DEMO_CODE"
        error[:message] = "Demo message"
        false
      end
    end

    begin
      dummy_class.new.authenticate!
      expect(false).to be true  # Don't get to this point!
    rescue ActiveEntry::NotAuthenticatedError => e
      error = e.error

      expect(error[:code]).to eq "DEMO_CODE"
      expect(error[:message]).to eq "Demo message"
    end
  end

  it 'raises no exception if #authenticated? returns true' do
    dummy_class.class_eval { def authenticated?; true; end }
    expect{ dummy_class.new.authenticate! }.to_not raise_error
  end

  it 'raises no exception if #authenticated? with argument returns true' do
    dummy_class.class_eval { def authenticated?(error); true; end }
    expect{ dummy_class.new.authenticate! }.to_not raise_error
  end
end
