require "active_entry/version"

require_relative "../app/controllers/concerns/active_entry/concern" if defined?(ActionController::Base)

require "active_support/inflector"


module ActiveEntry
  module Generators
  end

  class Error < StandardError
  end

  class AuthError < Error
    attr_reader :error, :class_name, :method, :arguments

    def initialize error, class_name, method, arguments
      @error = error
      @class_name = class_name
      @method = method 
      @arguments = arguments
      @message = "Not authenticated for method ##{@method} in class #{@class_name}"

      super @message
    end
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

  class NotAuthenticatedError < AuthError
  end

  class NotAuthorizedError < AuthError
  end

  class NotDefinedError < Error
    attr_reader :entry_name, :class_name

    def initialize entry_name, class_name
      @entry_name = entry_name
      @class_name = class_name
      @message = "Entry #{entry_name} for class #{@class_name} not defined."

      super @message
    end
  end

  class DecisionMakerMethodNotDefinedError < Error
    attr_reader :entry_name, :decision_maker_method_name

    def initialize entry_name, decision_maker_method_name
      @entry_name = entry_name
      @decision_maker_method_name = decision_maker_method_name
      @message = "Decision maker #{entry_name}##{decision_maker_method_name} is not defined."

      super @message
    end
  end

  class ArgumentNilError < Error
    attr_reader :argument_name

    def initialize argument_name
      @argument_name = argument_name
      @message = "Argument #{@argument_name} nil. Arguments cannot be nil. Use optional parameter has to declare optional arguments."
      super @message
    end
  end


  class Base
    AUTH_ERROR = AuthError
    
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
      args.each do |name, value|
        if name.to_sym == :optional
          args.each { |n, v| instance_variable_set ["@", name].join, value }
          next
        end

        raise ArgumentNilError.new(name) if value.nil?
        instance_variable_set ["@", name].join, value
      end
    end

    class << self
      def pass! method_name, **args
        Authentication.pass! method_name, **args
        Authorization.pass! method_name, **args
      end
    end


    def pass!
      raise AUTH_ERROR.new(error) unless pass?
    end

    def pass?
      decision_maker_method.call
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

  class EntryFinder
    attr_reader :class_name

    def initialize class_name
      @class_name = class_name
    end

    class << self
      def entry_for class_name
        new(class_name).entry
      end
    end

    def entry
      entry_class_name.safe_constantize or raise NotDefinedError.new(entry_class_name, @class_name)
    end

    private

    def entry_class_name
      [@class_name, "Entry"].join
    end
  end
end
