require "active_entry/version"
require "active_entry/generators"
require "active_entry/errors"
require "active_entry/base"
require "active_entry/policy_finder"

require_relative "../app/controllers/concerns/active_entry/concern" if defined?(ActionController::Base)
require_relative "../app/helpers/active_entry/view_helper" if defined?(ActionView::Base)

require "active_support/inflector"

module ActiveEntry
end
