require "<%= File.exists?('spec/rails_helper.rb') ? 'rails_helper' : 'spec_helper' %>"

RSpec.describe <%= class_name %>Policy, type: :policy do
  pending "add some examples to (or delete) #{__FILE__}"
end
