<p align="center">
  <a href="https://github.com/TFM-Agency/active_entry">
    <img src="https://raw.githubusercontent.com/TFM-Agency/active_entry/main/active_entry_logo.svg" alt="Active Entry Logo" width="350px"/>
  </a>
</p>

# Active Entry - Simple and flexible authentication and authorization
[![Gem Version](https://badge.fury.io/rb/active_entry.svg)](https://badge.fury.io/rb/active_entry)
[![Ruby](https://github.com/TFM-Agency/active_entry/actions/workflows/ci-rspec.yml/badge.svg)](https://github.com/TFM-Agency/active_entry/actions/workflows/ci-rspec.yml)
![Coverage](https://raw.githubusercontent.com/TFM-Agency/active_entry/main/coverage/coverage_badge_total.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/3db0f653be6bdfe0fdac/maintainability)](https://codeclimate.com/github/TFM-Agency/active_entry/maintainability)
[![Documentation](https://img.shields.io/badge/docs-rdoc.info-blue.svg)](https://rubydoc.info/github/TFM-Agency/active_entry/main)

Active Entry is a secure way to check for authentication and authorization before an action is performed. It's currently only compatible with Rails. But in later versions will ActiveEntry be Framework independent.

Active Entry works like many other Authorization Systems like [Pundit](https://github.com/varvet/pundit) or [Action Policy](https://github.com/palkan/action_policy) with **Policies**. However in Active Entry it's all about the method calling the auth mechanism. For every method that needs authentication or authorization, a decision maker method counterpart has to be created in the policy of the class.

## Example

Let's say we have an Users controller in our application:

```ruby
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  include ActiveEntry::ControllerConcern   # Glue for the controller and Active Entry

  def index
    pass!   # The auth happens here
    load_users
  end
end
```

We have to create the UsersPolicy in order for Active Entry to know who is authenticated and authorized and who not.

```ruby
# app/policies/users_policy.rb
module UsersPolicy
  class Authentication < ActiveEntry::Base::Authentication
    def index?
      Current.user_signed_in?  # Only signed in users are considered to be authenticated.
    end
  end

  class Authorization < ActiveEntry::Base::Authorization
    def index?
      Current.user.admin?  # Only admins are authorized to perform this action
    end
  end
end
```

Now every time somebody calls the `users#index` endpoint, he or she has to be signed in and an admin. Otherwise `ActiveEntry::NotAuthenticatedError` or `ActiveEntry::NotAuthorizedError` are raised.
You can catch them easily in your controller by using Rails' `rescue_from`.

```ruby
class ApplicationController < ActionController::Base
  rescue_from ActiveEntry::NotAuthenticatedError, with: :not_authenticated
  rescue_from ActiveEntry::NotAuthorizedError, with: :not_authorized

  def not_authenticated
    flash[:danger] = "Not authenticated. Please sign in."
    redirect_to sign_in_path
  end

  def not_authorized
    flash[:danger] = "Not authorized."
    redirect_to root_path
  end
end
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'active_entry'
```

Or install it without bundler:
```bash
$ gem install active_entry
```

Run Bundle:
```shell
$ bundle
```

And then install Active Entry:
```shell
$ rails g active_entry:install
```

This will generate `app/policies/application_policy.rb`.

## Usage
Active Entry works with Policies. You can generate policies the following way:

Let's consider the example from above.
We have an UsersController and we want a policy for that:

```shell
$ rails g policy Users
```

This generates a policy called `UsersPolicy` and is located in `app/policies/users_policy.rb`.

The above generator call would generate something like this, but with a few comments to help you get started:

```ruby
module UsersPolicy
  class Authentication < ActiveEntry::Base::Authentication
  end

  class Authorization < ActiveEntry::Base::Authorization
  end
end
```

### Verify authentication and authorization
You probably want to control authentication and authorization for every controller action you have in your app. As a safeguard to ensure, that auth is performed in every request and the auth call is not forgotten in development, add the `verify_authentication!` and `verify_authorization!` to your `ApplicationController`:

```ruby
class ApplicationController < ActionController::Base
  verify_authentication!
  verify_authorization!
  # ...
end
```
This ensures, that you perform auth in all your controllers and raises errors if not.

### Perform authentication and authorization
in order to do the actual authentication and authorization, you have to use `authenticate!` and `authorize!` or `pass!` as in your actions.

```ruby
class UsersController < ApplicationController
  def authentication_only_action
    authenticate!
  end

  def authorization_only_action
    authorize!
  end

  def both_authentication_and_authorization_action
    pass!
  end
end
```

If you try to open a page, Active Entry will raise `ActiveEntry::DecisionMakerMethodNotDefinedError`. This means we have to define the decision makers in our policy.

```ruby
module UsersPolicy
  class Authentication < ApplicationPolicy::Authentication
    def authentication_only_action?
      success   # == true | Everybody is allowed
    end

    def both_authentication_and_authorization_action?
      success
    end
  end

  class Authorization < ApplicationPolicy::Authorization
    def authorization_only_action?
      success
    end

    def both_authentication_and_authorization_action?
      success
    end
  end
end
```

Every decision maker ends with an `?`. The name has to be the same as the name of the controller action. So `index` is going to be `index?`.

In order for Active Entry to not raise an auth error, the decision makers have to return `true`. In our above example we used `success`, which simply returns `true`.

**Note:** It has to be an explicit `true` and not just a truthy value. A string or object return value would raise an auth error.

### Rescuing from errors
Catch the errors in your controllers to redirect the user or show them a message.

```ruby
class ApplicationController < ActionController::Base
  # ...

  rescue_from ActiveEntry::NotAuthenticatedError, with: :not_authenticated
  rescue_from ActiveEntry::NotAuthorizedError, with: :not_authorized

  private

  def not_authenticated
    flash[:danger] = "You are not authenticated!"
    redirect_to login_path
  end

  def not_authorized
    flash[:danger] = "You are not authorized to call this action!"
    redirect_to root_path
  end
end
```

In this example above, the user will be redirected with a flash message. But you can do whatever you want. For example logging.

### Authenticate/authorize outside the action
You can authenticate and authorize outside the action:

```ruby
class UsersController < ApplicationController
  authenticate_now!
  authorize_now!
  # pass_now!  # Does both, authentication and authorization
end
```

Access control on class level will ensure that every action performs it.

**Note:** Don't use the class methods if the controller is inherited in other controllers. Best, don't use them at all and use the methods in the actions conciously.

## Variables
You can pass variables to the decision maker.

```ruby
class UsersController < ApplicationController
  def show
    @user = User.find params[:id]
    pass! user: @user
  end
end
```

You can now access the user object as instance variable in your decision maker.

```ruby
module Users
  class Authentication < ApplicationPolicy::Authentication
    def show?
      @user  # == <User:Instance>
    end
  end

  class Authorization < ApplicationPolicy::Authorization
    def show?
      @user  # == <User:Instance>
    end
  end
end
```

## Custom error data
If you write something into `@error` in our decision maker, you can access it in your rescue methods in the controller:

```ruby
module UsersPolicy
  class Authentication < ApplicationPolicy::Authentication
    def show?
      @error = { code: 100 }
    end
  end

  class Authorization < ApplicationPolicy::Authorization
    def show?
      @error = { code: 100 }
    end
  end
end

class ApplicationController < ActionController::Base
  # ...

  rescue_from ActiveEntry::NotAuthenticatedError, with: :not_authenticated
  rescue_from ActiveEntry::NotAuthorizedError, with: :not_authorized

  private

  def not_authenticated exception
    flash[:danger] = "You are not authenticated! Code: #{exception.error[:code]}"
    redirect_to root_path
  end

  def not_authorized exception
    flash[:danger] = "You are not authorized to call this action! Code: #{exception.error[:code]}"
    redirect_to root_path
  end
end
```

But you can pass in whatever you want into your error hash.

## Testing
You can easily test your policies in RSpec.

We've created some helpers for your tests. Import them first:
```ruby
# spec/support/active_entry.rb
require "active_entry/rspec"
```

Now let's start with the generator:

```shell
$ rails g rspec:policy Users
```

This will generate a spec for the `UsersPolicy` located in `spec/policies/users_policy_spec.rb`

```ruby
require "rails_helper"

RSpec.describe UsersPolicy, type: :policy do
  pending "add some examples to (or delete) #{__FILE__}"
end
```

Now you can easily test every decision maker with the `be_authenticated_for` and `be_authorized_for` matchers.

```ruby
require "rails_helper"

RSpec.describe UsersPolicy, type: :policy do
  describe UsersPolicy::Authentication do
    subject { UsersPolicy::Authentication }

    context "anonymous" do
      it { is_expected.to_not be_authenticated_for :index }
      it { is_expected.to be_authenticated_for :new }
      it { is_expected.to be_authenticated_for :create }
      it { is_expected.to_not be_authenticated_for :edit }
      it { is_expected.to_not be_authenticated_for :update }
      it { is_expected.to_not be_authenticated_for :destroy }
      it { is_expected.to_not be_authenticated_for :restore }
    end

    context "signed in" do
      before { Current.user = build :user }
      
      it { is_expected.to be_authenticated_for :index }
      it { is_expected.to be_authenticated_for :new }
      it { is_expected.to be_authenticated_for :create }
      it { is_expected.to be_authenticated_for :edit }
      it { is_expected.to be_authenticated_for :update }
      it { is_expected.to be_authenticated_for :destroy }
      it { is_expected.to be_authenticated_for :restore }
    end
  end

  describe UsersPolicy::Authorization do
    subject { UsersPolicy::Authorization }

    let(:user) { build :user }
    
    context "anonymous" do
      it { is_expected.to be_authorized_for :index }
      it { is_expected.to be_authorized_for :new }
      it { is_expected.to be_authorized_for :create }
      it { is_expected.to be_authorized_for :show, user: user }
      it { is_expected.to_not be_authorized_for :edit, user: user }
      it { is_expected.to_not be_authorized_for :update, user: user }
      it { is_expected.to_not be_authorized_for :destroy, user: user }
      it { is_expected.to_not be_authorized_for :restore, user: user }
    end

    context "if @user is Current.user" do
      before { Current.user = user }
      
      it { is_expected.to be_authorized_for :show, user: user }
      it { is_expected.to be_authorized_for :edit, user: user }
      it { is_expected.to be_authorized_for :update, user: user }
      it { is_expected.to be_authorized_for :destroy, user: user }
      it { is_expected.to be_authorized_for :restore, user: user }
    end

    context "if @user is not Current.user" do
      before { Current.user = build :user }

      it { is_expected.to be_authorized_for :show, user: user }
      it { is_expected.to_not be_authorized_for :edit, user: user }
      it { is_expected.to_not be_authorized_for :update, user: user }
      it { is_expected.to_not be_authorized_for :destroy, user: user }
      it { is_expected.to_not be_authorized_for :restore, user: user }
    end
  end
end
```

## Differences to Action Policy
[Action Policy](https://github.com/palkan/action_policy) is an awesome gem which works pretty similar to Active Entry. But there are some differences:

### Action Policy expects a performing subject and a target object
```ruby
class PostPolicy < ApplicationPolicy
  def update?
    # `user` is a performing subject,
    # `record` is a target object (post we want to update)
    user.admin? || (user.id == record.user_id)
  end
end
```

In Active Entry you can pass in anything you want into the decision maker, which is accessible as instance variables. See Variables.

One strategy is not better than the other. It's just our preference.

### Policies in Action Policy are for Resources/Models
If you have a `Post` model, you have a `PostPolicy` in Action Policy. In Active Entry you create policies for controllers. So if you have a `PostsController`, you have a `PostsPolicy`.
We like to build access control logic around controller endpoints.

### Action Policy performs only authorization
Active Entry does technically also not provide authentication mechanisms. It's just that you place your authentication logic in an authentication decision maker.
We like both authentication and authorization logic in the same place but seperated hence `UsersPolicy::Authentication` and `UsersPolicy::Authorization`.

## Contributing
Create pull requests on Github and help us to improve this Gem. There are some guidelines to follow:

 * Follow the conventions
 * Test all your implementations
 * Document methods that aren't self-explaining (we are using [YARD](http://yardoc.org/))

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
