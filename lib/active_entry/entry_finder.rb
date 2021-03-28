module ActiveEntry
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
