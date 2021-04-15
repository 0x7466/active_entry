Rails.application.routes.draw do
  get "unauthenticated" => "test#unauthenticated"
  get "authenticated_unauthorized" => "test#authenticated_unauthorized"
  get "authenticated_authorized" => "test#authenticated_authorized"
  get "authenticated_authorized_with_arg" => "test#authenticated_authorized_with_arg"
end
