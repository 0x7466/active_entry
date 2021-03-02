# Active Entry - Simple and flexible authentication and authorization
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
You probably want to control authentication and authorization for every controller action you have in your app. To enable this, just add the before action to the `ApplicationController`.

```ruby
class ApplicationController < ActionController::Base
  before_action :authenticate!, :authorize!
  # ...
end
```

If you try to open a page, you will get an `ActiveEntry::AuthenticationNotPerformedError` or `ActiveEntry::AuthorizationNotPerformedError`. This means that you have to instruct Active Entry when a user is authenticated/authorized and when not.
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

If the user is signed in, he is authenticated and authorized if he is an admin, otherwise an `ActiveEntry::NotAuthenticatedError` or `ActiveEntry::NotAuthorizedError` will be raised.
Now you just have to catch this error and react accordingly. Rails has the convinient `rescue_from` for that.

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

Active Entry also has a few helper methods which help you to distinguish between RESTful controller actions.

The following methods are available:

 * `read_action?` - If the called action just read. Actions: `index`, `show`
 * `write_action?` - If the called action writes something. Actions: `new`, `create`, `edit`, `update`, `destroy`
 * `change_action?` - If something will be updated or destroyed. Actions: `edit`, `update`, `destroy`
 * `create_action?` - If something will be created. Actions: `new`, `create`
 * `update_action?` - If something will be updated. Actions: `edit`, `update`
 * `destroy_action?` - If something will be destroyed. Action: `destroy`

So you can for example do:

```ruby
def authorized?
  return true if read_action?    # Everybody is authorized to call read actions

  if write_action?
    return true if admin_signed_in?		# Just admins are allowed to call write actions
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

## Known Issues
The authentication/authorization is done in a before action. These Rails controller before callbacks are done in defined order. If you set an instance variable which is needed in the `authenticated?` or `authorized?` method, you have to call the before action after the other method again.

For example if you set `@user` in your controller in the `set_user` before action and you want to use the variable in `authorized?` action, you have to add the `authenticate!` or `authorize!` method after the `set_user` again, otherwise `@user` won't be available in `authenticate!` or `authorized?` yet.

```ruby
class UsersController < ApplicationController
  before_action :set_user
  before_action :authenticate!, :authorize!

  def show
  end

  private

  def authenticated?
    return true if user_signed_in?
  end

  def authorized?
    return true if current_user == @user
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