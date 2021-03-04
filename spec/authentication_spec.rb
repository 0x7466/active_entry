require "rails_helper"

describe "Authentication" do
  let(:dummy_class) { Class.new { include ActiveEntry } }

  before { dummy_class.define_method(:index) {} }
  before { dummy_class.define_method(:action_name) { "index" } }

  it 'raises `AuthenticationDecisionMakerMissingError` if #authenticated? is not defined' do
    expect{ dummy_class.new.authenticate! }.to raise_error ActiveEntry::AuthenticationDecisionMakerMissingError
  end

  it 'raises `NotAuthenticatedError` if #authenticated? is false' do
    dummy_class.class_eval { def authenticated?; false; end }
    expect{ dummy_class.new.authenticate! }.to raise_error ActiveEntry::NotAuthenticatedError
  end

  it 'raises `NotAuthenticatedError` if #authenticated? with argument is false' do
    dummy_class.class_eval { def authenticated?(error); false; end }
    expect{ dummy_class.new.authenticate! }.to raise_error ActiveEntry::NotAuthenticatedError
  end

  it 'raises `NotAuthenticatedError` if #authenticated? with argument and custom error is false' do
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

  it 'does not raise error if #authenticated? is true' do
    dummy_class.define_method(:authenticated?) { true }
    expect{ dummy_class.new.authenticate! }.to_not raise_error
  end

  it 'does not raise error if #authenticated? with argument is true' do
    dummy_class.class_eval { def authenticated?(error); true; end }
    expect{ dummy_class.new.authenticate! }.to_not raise_error
  end

  describe "scoped authenticated?" do
    it 'raises `NotAuthenticatedError` if #index_authenticated? is false' do
      dummy_class.define_method(:index_authenticated?) { false }
      expect{ dummy_class.new.authenticate! }.to raise_error ActiveEntry::NotAuthenticatedError
    end

    it 'raises `NotAuthenticatedError` if #index_authenticated? is false but #authenticated? is true' do
      dummy_class.define_method(:index_authenticated?) { false }
      dummy_class.define_method(:authenticated?) { true }
      expect{ dummy_class.new.authenticate! }.to raise_error ActiveEntry::NotAuthenticatedError
    end

    it 'does not raise error if #index_authenticated? returns true' do
      dummy_class.define_method(:index_authenticated?) { true }
      expect{ dummy_class.new.authenticate! }.to_not raise_error
    end

    it 'has precendence over #authenticated?' do
      dummy_class.define_method(:index_authenticated?) { true }
      dummy_class.define_method(:authenticated?) { false }
      expect{ dummy_class.new.authenticate! }.to_not raise_error
    end
  end
end
