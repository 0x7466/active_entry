module ActiveEntry
  module Rspec
    module Matchers
      extend ::RSpec::Matchers::DSL

      matcher :be_authenticated_for do |action, **args|
        match do |policy|
          policy.pass? action, **args
        end

        description do
          "be authenticated for #{action}"
        end

        failure_message do |policy|
          "expected that #{policy} passes authentication for #{action}"
        end
      end

      matcher :be_authorized_for do |action, **args|
        match do |policy|
          policy.pass? action, **args
        end

        description do
          "be authorized for #{action}"
        end

        failure_message do |policy|
          "expected that #{policy} passes authorization for #{action}"
        end
      end
    end

    module DSL
    end

    module PolicyExampleGroup
      include ActiveEntry::Rspec::Matchers

      def self.included(base)
        base.metadata[:type] = :policy
        base.extend ActiveEntry::Rspec::DSL
        super
      end
    end
  end
end

RSpec.configure do |config|
  config.include(
    ActiveEntry::Rspec::PolicyExampleGroup,
    type: :policy,
    file_path: %r{spec/policies}
  )
end
