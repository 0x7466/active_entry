require_relative '../../app/helpers/active_entry/view_helper'

module ActiveEntry
  class Railtie < Rails::Railtie
    initializer "active_entry.view_helper" do
      ActiveSupport.on_load(:action_view) { include ActiveEntry::ViewHelper }
    end
  end
end
