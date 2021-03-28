require "spec_helper"

describe ActiveEntry::EntryFinder do
  let(:class_name) { :Application }

  let(:define_application_entry_class) { ApplicationEntry = Class.new }
  let(:undefine_application_entry_class) { Object.send :remove_const, :ApplicationEntry }

  subject { ActiveEntry::EntryFinder.new class_name }

  describe ".entry_for" do
    context "if application entry class defined" do
      before { define_application_entry_class }
      after { undefine_application_entry_class }

      it "is ApplicationEntry" do
        expect(ActiveEntry::EntryFinder.entry_for(class_name)).to eq(ApplicationEntry)
      end
    end

    context "if application entry class defined" do
      it "raises NotDefinedError" do
        expect{ ActiveEntry::EntryFinder.entry_for(class_name) }.to raise_error ActiveEntry::NotDefinedError
      end
    end
  end

  describe "#entry" do
    context "if application entry class defined" do
      before { define_application_entry_class }
      after { undefine_application_entry_class }

      it "is ApplicationEntry" do
        expect(subject.entry).to eq(ApplicationEntry)
      end
    end

    context "if application entry class defined" do
      it "raises NotDefinedError" do
        expect{ subject.entry }.to raise_error ActiveEntry::NotDefinedError
      end
    end
  end
end
