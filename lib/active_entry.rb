require "active_entry/version"
require "active_entry/errors"
require "active_entry/controller_methods"
require "active_entry/railtie" if defined? Rails::Railtie

module ActiveEntry
  # Authenticates the user
  def authenticate!
    # Raise an error if the #authenticate? action isn't defined.
    #
    # This ensures that you actually do authentication in your controller.
    raise ActiveEntry::AuthenticationNotPerformedError unless defined?(authenticated?)
    
    error = {}
    is_authenticated = nil

    if method(:authenticated?).arity > 0
      is_authenticated = authenticated?(error)
    else
      is_authenticated = authenticated?
    end
    
    # If the authenticated? method returns not true
    # it raises the ActiveEntry::NotAuthenticatedError.
    #
    # Use the .rescue_from method from ActionController::Base
    # to catch the exception and show the user a proper error message.
    raise ActiveEntry::NotAuthenticatedError.new(error) unless is_authenticated == true
  end
  
  # Authorizes the user.
  def authorize!
    # Raise an error if the #authorize? action isn't defined.
    #
    # This ensures that you actually do authorization in your controller. 
    raise ActiveEntry::AuthorizationNotPerformedError unless defined?(authorized?)
    
    error = {}
    is_authorized = nil

    if method(:authorized?).arity > 0
      is_authorized = authorized?(error)
    else
      is_authorized = authorized?
    end

    # If the authorized? method does not return true
    # it raises the ActiveEntry::NotAuthorizedError
    #
    # Use the .rescue_from method from ActionController::Base
    # to catch the exception and show the user a proper error message.
    raise ActiveEntry::NotAuthorizedError.new(error) unless is_authorized == true
  end
end
