module ActiveEntry
  class PolicyFinder
    attr_reader :class_name

    def initialize class_name
      @class_name = class_name
    end

    class << self
      def policy_for class_name
        new(class_name).policy
      end
    end

    def policy
      policy_class_name.safe_constantize or raise NotDefinedError.new(policy_class_name, @class_name)
    end

    private

    def policy_class_name
      [@class_name, "Policy"].join
    end
  end
end
