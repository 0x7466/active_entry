require "active_entry/version"
require "active_entry/generators"
require "active_entry/errors"
require "active_entry/base"
require "active_entry/entry_finder"

require_relative "../app/controllers/concerns/active_entry/concern" if defined?(ActionController::Base)

require "active_support/inflector"


module ActiveEntry
end
