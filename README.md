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

Active Entry is a simple and secure authentication and authorization system for your Rails application, which lets you to authenticate and authorize directly in your controllers.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'active_entry'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install active_entry
```

## Usage
With Active Entry authentication and authorization is done in your Rails controllers. To enable authentication and authorization in one of your controllers, just add a before action for `authenticate!` and `authorize!` and the user has to authenticate and authorize on every call.

### Verify authentication and authorization
You probably want to control authentication and authorization for every controller action you have in your app. As a safeguard to ensure, that auth is performed in every controller and the call for auth is not forgotten in development, add the `#verify_authentication!` and `#verify_authorization` as after action callbacks to your `ApplicationController`.

```ruby
class ApplicationController < ActionController::Base
  before_action :verify_authentication!, :verify_authorization!
  # ...
end
```
This ensures, that you call `authenticate!` and/or `authorize!` in all your controllers and raises an `ActiveEntry::AuthenticationNotPerformedError` / `ActiveEntry::AuthorizationNotPerformedError` if not.

### Perform authentication and authorization
in order to do the actual authentication and authorization, you have to add `authenticate!` and `authorize!` as before action callback in your controllers.

```ruby
class DashboardController < ApplicationController
  before_action :authenticate!, :authorize!
  # ...
end
```

If you try to open a page, you will get an `ActiveEntry::AuthenticationDecisionMakerMissingError` or `ActiveEntry::AuthorizationDecisionMakerMissingError`. This means that you have to instruct Active Entry when a user is authenticated/authorized and when not.
You can do this by defining the methods `authenticated?` and `authorized?` in your controller.

```ruby
class DashboardController < ApplicationController
  # Actions ...

  private

  def authenticated?
    return true if user_signed_in?
  end

  def authorized?
    return true if current_user.admin?
  end 
end
```

Active Entry expects boolean return values from `authenticated?` and `authorized?`. `true` signals successful authentication/authorization, everything else not.

### Rescuing from errors

If the user is signed in, he is authenticated and authorized if he is an admin, otherwise an `ActiveEntry::NotAuthenticatedError` or `ActiveEntry::NotAuthorizedError` will be raised.
Now you just have to catch this error and react accordingly. Rails has the convenient `rescue_from` for that.

```ruby
class ApplicationController < ActionController::Base
  # ...

  rescue_from ActiveEntry::NotAuthenticatedError, with: :not_authenticated unless Rails.env.test?
  rescue_from ActiveEntry::NotAuthorizedError, with: :not_authorized unless Rails.env.test?

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

### Scoped decision makers

Instead of putting all authentication/authorization logic into `authenticated?` and `authorized?` you can create scoped decision makers:

```ruby
class DashboardController < ApplicationController
  before_action :authenticate!, :authorize!

  def index_authenticated?
    # Do your authentication for the index action only
  end
  def index_authorized?
    # Do your authorization for the index action only
  end
  def index
    # Actual action
  end
end
```

This puts authentication/authorization logic a lot closer to the actual action that is performed and you don't get lost in endlessly long `authenticated?` or `authorized?` decision maker methods.

**Note:** The scoped authentication/authorization decision maker methods take precendence over the general ones. That means if you have an `index_authenticated?` for your index action defined, the general `authenticated?` gets ignored.

### Controller helper methods

Active Entry also has a few helper methods which help you to distinguish between controller actions. You can check if a specific action got called, by adding `_action?` to the action name in your `authenticated?` or `authorized?`.
For an action `show` this would be `show_action?`.

**Note:** A `NoMethodError` gets raised if you try to call `_action?` if the actual action hasn't been implemented. For example `missing_implementation_action?` raises an error as long as `#missing_implementation` hasn't been implemented as action.

The are some more helpers that check for more than one RESTful action:

 * `read_action?` - If the called action just read. Actions: `index`, `show`
 * `write_action?` - If the called action writes something. Actions: `new`, `create`, `edit`, `update`, `destroy`
 * `change_action?` - If something will be updated or destroyed. Actions: `edit`, `update`, `destroy`
 * `create_action?` - If something will be created. Actions: `new`, `create`
 * `update_action?` - If something will be updated. Actions: `edit`, `update`
 * `destroy_action?` - If something will be destroyed. Action: `destroy`
 * `delete_action?` - Alias for `destroy_action?`. Action: `destroy`

So you can for example do:

```ruby
class ApplicationController < ActionController::Base
  # ...

  def show
  end

  def custom
  end

  private

  def authorized?
    return true if read_action?    # Everybody is authorized to call read actions

    if write_action?
      return true if admin_signed_in?		# Just admins are allowed to call write actions
    end

    if custom_action?   # For custom/non-RESTful actions
      return true
    end
  end
end
```

This is pretty much everything you have to do for basic authentication or authorization!

## Pass a custom error hash
You can pass an error hash to the exception and use this in your rescue method:

```ruby
class ApplicationController < ActionController::Base
  before_action :authenticate!, :authorize!
	
  # ...

  rescue_from ActiveEntry::NotAuthenticatedError, with: :not_authenticated
  rescue_from ActiveEntry::NotAuthorizedError, with: :not_authorized

  private

  def not_authenticated(exception)
    flash[:danger] = "You are not authenticated! Code: #{exception.error[:code]}"
    redirect_to root_path
  end

  def not_authorized(exception)
    flash[:danger] = "You are not authorized to call this action! Code: #{exception.error[:code]}"
    redirect_to root_path
  end

  def authenticated?(error)
    error[:code] = "ERROR"

    return true if user_signed_in?
  end
	
  def authorized?(error)
    error[:code] = "ERROR"

    return true if read_action?    # Everybody is authorized to call read actions

    if write_action?
      return true if admin_signed_in?		# Just admins are allowed to call write actions
    end
  end
end
```
## Testing authentication and authorization
If you check for the Rails environment with `unless Rails.env.test?` in your `rescue_from` statement you can easily test your authentication and authorization in your tests.

```ruby
class ApplicationController < ActionController::Base
  # ...
  rescue_from ActiveEntry::NotAuthenticatedError, with: :not_authenticated unless Rails.env.test?
  rescue_from ActiveEntry::NotAuthorizedError, with: :not_authorized unless Rails.env.test?
  # ...
end
```

Now you can catch `ActiveEntry::NotAuthenticatedError` / `ActiveEntry::NotAuthorizedError` in your test site like this:

```ruby
require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "Authentication" do
    context "#index" do
      context "authenticated" do
        it "as signed in user" do
          sign_in_as user
          expect{ get users_path }.to_not raise_error ActiveEntry::NotAuthenticatedError
        end
      end

      context "not authenticated" do
        it "as stranger" do
          expect{ get users_path }.to raise_error ActiveEntry::NotAuthenticatedError
        end
      end
    end
  end

  describe "Authorization" do
    context "#index" do
      context "authorized" do
        it "as admin" do
          sign_in_as admin
          expect{ get users_path }.to_not raise_error ActiveEntry::NotAuthorizedError
        end
      end

      context "not authenticated" do
        it "as non-admin" do
          sign_in_as user
          expect{ get users_path }.to raise_error ActiveEntry::NotAuthorizedError
        end
      end
    end
  end
end
```

## Contributing
Create pull requests on Github and help us to improve this Gem. There are some guidelines to follow:

 * Follow the conventions
 * Test all your implementations
 * Document methods that aren't self-explaining (we are using [YARD](http://yardoc.org/))

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
