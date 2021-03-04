# @author Tobias Feistmantl
module ActiveEntry
  # Generic authorization error.
  # Other, more specific, errors inherit from this one.
  #
  # @raise [AuthorizationError]
  #    if something generic is happening.
  class AuthorizationError < StandardError
  end

  # Error for controllers in which authorization isn't handled.
  #
  # @raise [AuthorizationNotPerformedError]
  #    if authorize! is not called
  #    in the controller class.
  class AuthorizationNotPerformedError < AuthorizationError
  end

  # Error for controllers in which authorization decision maker is missing.
  #
  # @raise [AuthorizationDecisionMakerMissingError]
  #    if the #authorized? method isn't defined
  #    in the controller class.
  class AuthorizationDecisionMakerMissingError < AuthorizationError
  end

  # Error if user unauthorized.
  #
  # @raise [NotAuthorizedError]
  #    if authorized? isn't returning true.
  #
  # @note
  #    Should always be called at the end
  #    of the #authorize! method.
  class NotAuthorizedError < AuthorizationError
    attr_reader :error

    def initialize(error={})
      @error = error
    end
  end


  # Base class for authentication errors.
  #
  # @raise [AuthenticationError]
  #    if something generic happens.
  class AuthenticationError < StandardError
  end

  # Error for controllers in which authentication isn't handled.
  #
  # @raise [AuthenticationNotPerformedError]
  #    if authenticate! is not called
  #    in the controller class.
  class AuthenticationNotPerformedError < AuthenticationError
  end

  # Error for controllers in which authentication decision maker is missing.
  #
  # @raise [AuthenticationDecisionMakerMissingError]
  #    if the #authenticated? method isn't defined
  #    in the controller class.
  class AuthenticationDecisionMakerMissingError < AuthenticationError
  end

  # Error if user not authenticated
  #
  # @raise [NotAuthenticatedError]
  #    if authenticated? isn't returning true.
  #
  # @note
  #    Should always be called at the end
  #    of the #authenticate! method.
  class NotAuthenticatedError < AuthenticationError
    attr_reader :error

    def initialize(error={})
      @error = error
    end
  end
end
