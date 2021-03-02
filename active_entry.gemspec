require_relative "lib/active_entry/version"

Gem::Specification.new do |spec|
  spec.name        = "active_entry"
  spec.version     = ActiveEntry::VERSION
  spec.authors     = ["TFM Agency GmbH", "Tobias Feistmantl"]
  spec.email       = ["hello@tfm.agency"]
  spec.homepage    = "https://github.com/TFM-Agency/active_entry"
  spec.summary     = "An easy and flexible access control system for your Rails app."
  spec.description = "An easy and flexible access control system. No need for policies, abilities, etc. Do authentication and authorization directly in your controller."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/TFM-Agency/active_entry"
  spec.metadata["changelog_uri"] = "https://github.com/TFM-Agency/active_entry/commits/main"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 4.0.0"

  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
end
