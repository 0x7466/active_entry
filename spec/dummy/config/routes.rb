Rails.application.routes.draw do
  get "show" => "test#show"
  get "non_restful" => "test#non_restful"

  get "scoped_index" => "scoped_decision_maker_test#index"
  get "scoped_custom" => "scoped_decision_maker_test#custom"
  get "scoped_other" => "scoped_decision_maker_test#other"
  get "scoped_non_authenticated" => "scoped_decision_maker_test#non_authenticated"
  get "scoped_non_authorized" => "scoped_decision_maker_test#non_authorized"

  get "authentication_not_performed" => "authentication_verification_test#authentication_not_performed"
  get "authentication_performed" => "authentication_verification_test#authentication_performed"

  get "authorization_not_performed" => "authorization_verification_test#authorization_not_performed"
  get "authorization_performed" => "authorization_verification_test#authorization_performed"
end
