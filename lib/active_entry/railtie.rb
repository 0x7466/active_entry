module ActiveEntry
  class Railtie < ::Rails::Railtie
    initializer 'active_entry.include_in_action_controller' do
      ActiveSupport.on_load :action_controller do
        ::ActionController::Base.include(ActiveEntry)
      end
    end
  end
end