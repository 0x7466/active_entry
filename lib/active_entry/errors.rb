module ActiveEntry
  class Error < StandardError
  end

  class AuthError < Error
    attr_reader :error, :method, :arguments

    def initialize error, method, arguments
      @error = error
      @method = method 
      @arguments = arguments
      @message = "Not authenticated/authorized for method ##{@method}"

      super @message
    end
  end

  class NotAuthenticatedError < AuthError
  end

  class NotAuthorizedError < AuthError
  end

  class NotPerformedError < Error
    attr_reader :class_name, :method

    def initialize class_name, method
      @class_name = class_name
      @method = method
      @message = "Auth not performed for #{@class_name}##{@method}."
      
      super @message
    end
  end

  class AuthenticationNotPerformedError < NotPerformedError
  end

  class AuthorizationNotPerformedError < NotPerformedError
  end

  class NotDefinedError < Error
    attr_reader :policy_name, :class_name

    def initialize policy_name, class_name
      @policy_name = policy_name
      @class_name = class_name
      @message = "Policy #{policy_name} for class #{@class_name} not defined."

      super @message
    end
  end

  class DecisionMakerMethodNotDefinedError < Error
    attr_reader :policy_name, :decision_maker_method_name

    def initialize policy_name, decision_maker_method_name
      @policy_name = policy_name
      @decision_maker_method_name = decision_maker_method_name
      @message = "Decision maker #{policy_name}##{decision_maker_method_name} is not defined."

      super @message
    end
  end
end
