module ActiveEntry
  module RSpec
    module Matchers
    end

    module DSL
    end

    module PolicyExampleGroup
      include ActiveEntry::Rspec::Matchers

      def self.included(base)
        base.metadata[:type] = :policy
        base.extend ActiveEntry::RSpec::DSL
        super
      end
    end
  end
end

RSpec.configure do |config|
  config.include(
    ActiveEntry::RSpec::PolicyExampleGroup,
    type: :policy,
    file_path: %r{spec/entries}
  )
end
