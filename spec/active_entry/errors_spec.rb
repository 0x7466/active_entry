require "spec_helper"


describe ActiveEntry::AuthError do
  subject { ActiveEntry::AuthError.new "error", "method", "arguments" }
  it { expect(subject.error).to eq "error" }
  it { expect(subject.method).to eq "method" }
  it { expect(subject.arguments).to eq "arguments" }
  it { expect(subject.message).to eq "Not authenticated/authorized for method #method" }
end

describe ActiveEntry::NotPerformedError do
  subject { ActiveEntry::NotPerformedError.new "class_name", "method" }
  it { expect(subject.class_name).to eq "class_name" }
  it { expect(subject.method).to eq "method" }
  it { expect(subject.message).to eq "Auth not performed for class_name#method." }
end

describe ActiveEntry::NotDefinedError do
  subject { ActiveEntry::NotDefinedError.new "policy_name", "class_name" }
  it { expect(subject.policy_name).to eq "policy_name" }
  it { expect(subject.class_name).to eq "class_name" }
  it { expect(subject.message).to eq "Policy policy_name for class class_name not defined." }
end

describe ActiveEntry::DecisionMakerMethodNotDefinedError do
  subject { ActiveEntry::DecisionMakerMethodNotDefinedError.new "policy_name", "decision_maker_method_name" }
  it { expect(subject.policy_name).to eq "policy_name" }
  it { expect(subject.decision_maker_method_name).to eq "decision_maker_method_name" }
  it { expect(subject.message).to eq "Decision maker policy_name#decision_maker_method_name is not defined." }
end
