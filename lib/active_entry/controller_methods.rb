# @author Tobias Feistmantl
#
# Helper methods for your controller
# to identify RESTful actions.
module ActiveEntry
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

  # @return [Boolean]
  #    True if the called action
  #    is the index action.
  def index_action?
    action_name == 'index'
  end

  # @return [Boolean]
  #    True if the called action
  #    is the show action.
  def show_action?
    action_name == 'show'
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
