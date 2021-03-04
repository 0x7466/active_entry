# @author Tobias Feistmantl
#
# Helper methods for your controller
# to identify RESTful actions.
module ActiveEntry
  # @!visibility private
  def method_missing method_name, *args
    method_name_str = method_name.to_s
    
    if methods.include?(:action_name) && method_name_str.include?("_action?")
      method_name_str.slice! "_action?"
      
      if methods.include? method_name_str.to_sym
        return method_name_str == action_name
      end
    end

    super
  end

  # @return [Boolean]
  #    True if the called action
  #    is a only-read action.
  def read_action?
    action_name == 'index' ||
    action_name == 'show'
  end

  # @return [Boolean]
  #    True if the called action
  #    is a write action.
  def write_action?
    action_name == 'new' ||
    action_name == 'create' ||
    action_name == 'edit' ||
    action_name == 'update' ||
    action_name == 'destroy'
  end

  # @return [Boolean]
  #    True if the called action
  #    is a change action.
  def change_action?
    action_name == 'edit' ||
    action_name == 'update' ||
    action_name == 'destroy'
  end

  # @note
  #    Also true for the pseudo
  #    update action `new`.
  #
  # @note
  #    Only true for create methods
  #    such as new and create.
  #
  # @return [Boolean]
  #    True if the called action
  #    is a create action.
  def create_action?
    action_name == 'new' ||
    action_name == 'create'
  end

  # @note
  #    Also true for the pseudo
  #    update action `edit`.
  #
  # @return [Boolean]
  #    True if the called action
  #    is a update action.
  def update_action?
    action_name == 'edit' ||
    action_name == 'update'
  end

  # @return [Boolean]
  #    True if it's a destroy action.
  def destroy_action?
    action_name == 'destroy'
  end
  alias delete_action? destroy_action?
end
