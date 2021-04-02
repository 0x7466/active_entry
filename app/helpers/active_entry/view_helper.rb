module ActiveEntry
  module ViewHelper
    def authorized_for? controller_name, action, **args
      controller_name = controller_name.to_s.camelize.remove "Controller"
      policy = ActiveEntry::PolicyFinder.policy_for controller_name
      policy::Authorization.pass? action, **args
    end

    def link_to_if_authorized name = nil, options = nil, html_options = nil, &block
      url = url_for options
      method = options && options[:method] ? options[:method].to_s.upcase : "GET"
      recognized_path = Rails.application.routes.recognize_path(url, method: method)
      authorized = authorized_for? recognized_path[:controller], recognized_path[:action]
      link_to_if authorized, name, options, html_options, &block
    end
  end
end