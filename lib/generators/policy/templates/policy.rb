module <%= class_name %>Policy
  class Authentication < ApplicationPolicy::Authentication
    # It's all about decision makers. In your decision makers you tell
    # Active Entry when and if somebody is authenticated/authorized.
    #
    # You can declare decision makers for any method you want.
    # Just use the same name as your action and add a ? at the end.

    # def index?
    # end

    # def new?
    # end

    # def create?
    # end

    # def show?
    # end

    # def edit?
    # end

    # def update?
    # end

    # def destroy?
    # end
  end

  class Authorization < ApplicationPolicy::Authorization
    # def index?
    # end

    # def new?
    # end

    # def create?
    # end

    # def show?
    # end

    # def edit?
    # end

    # def update?
    # end

    # def destroy?
    # end
  end
end
