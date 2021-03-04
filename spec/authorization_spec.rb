require "rails_helper"

describe "Authorization" do
  let(:dummy_class) { Class.new { include ActiveEntry } }
  
  before { dummy_class.define_method(:index) {} }
  before { dummy_class.define_method(:action_name) { "index" } }

  it 'raises `AuthorizationDecisionMakerMissingError` if #authorized? is not defined' do
    expect{ dummy_class.new.authorize! }.to raise_error ActiveEntry::AuthorizationDecisionMakerMissingError
  end

  it 'raises `NotAuthorizedError` if #authorized? is false' do
    dummy_class.class_eval { def authorized?; false; end }
    expect{ dummy_class.new.authorize! }.to raise_error ActiveEntry::NotAuthorizedError
  end

  it 'raises `NotAuthorizedError` if #authorized? with argument is false' do
    dummy_class.class_eval { def authorized?(error); false; end }
    expect{ dummy_class.new.authorize! }.to raise_error ActiveEntry::NotAuthorizedError
  end

  it 'raises `NotAuthorizedError` if #authorized? with argument and custom error is false' do
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

  it 'does not exception if #authorized? is true' do
    dummy_class.class_eval { def authorized?; true; end }
    expect{ dummy_class.new.authorize! }.to_not raise_error
  end

  it 'does not exception if #authorized? with argument is true' do
    dummy_class.class_eval { def authorized?(error); true; end }
    expect{ dummy_class.new.authorize! }.to_not raise_error
  end

  describe "scoped authorized?" do
    it 'raises `NotAuthorizedError` if #index_authorized? is false' do
      dummy_class.define_method(:index_authorized?) { false }
      expect{ dummy_class.new.authorize! }.to raise_error ActiveEntry::NotAuthorizedError
    end

    it 'raises `NotAuthorizedError` if #index_authorized? is false but #authorized? is true' do
      dummy_class.define_method(:index_authorized?) { false }
      dummy_class.define_method(:authorized?) { true }
      expect{ dummy_class.new.authorize! }.to raise_error ActiveEntry::NotAuthorizedError
    end

    it 'does not raise error if #index_authorized? returns true' do
      dummy_class.define_method(:index_authorized?) { true }
      expect{ dummy_class.new.authorize! }.to_not raise_error
    end

    it 'has precendence over #authorized?' do
      dummy_class.define_method(:index_authorized?) { true }
      dummy_class.define_method(:authorized?) { false }
      expect{ dummy_class.new.authorize! }.to_not raise_error
    end
  end
end
