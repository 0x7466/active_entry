module ActiveEntry
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def create_application_policy
      template "application_policy.rb", File.join("app/policies/application_policy.rb"), skip: true
    end
  end
end
