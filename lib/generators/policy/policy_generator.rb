class PolicyGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def create_application_policy
    template "application_policy.rb", File.join("app/policies/application_policy.rb"), skip: true
  end

  def create_policy
    template "policy.rb", File.join("app/policies", class_path, "#{file_name}_policy.rb")
  end
end
