module ActiveEntry
  class Base
    class Authentication < Base
      AUTH_ERROR = NotAuthenticatedError
      
      def self.pass! method_name, **args
        new(method_name, **args).pass!
      end
    end

    class Authorization < Base
      AUTH_ERROR = NotAuthorizedError
      
      def self.pass! method_name, **args
        new(method_name, **args).pass!
      end
    end

    def initialize method_name, **args
      @_method_name_to_entrify = method_name
      @_args = args
      @_args.each { |name, value| instance_variable_set ["@", name].join, value }
    end

    class << self
      def pass! method_name, **args
        Authentication.pass! method_name, **args
        Authorization.pass! method_name, **args
      end
    end


    def pass!
      pass? or raise self.class::AUTH_ERROR.new(@error, @_method_name_to_entrify, @_args)
    end

    def pass?
      decision_maker_method.call == true
    end

    def success
      true
    end

    private

    def decision_maker_method
      decision_maker_method_name = [@_method_name_to_entrify, "?"].join
      raise DecisionMakerMethodNotDefinedError.new(self.class, decision_maker_method_name) unless respond_to?(decision_maker_method_name)
      method decision_maker_method_name
    end
  end
end