Rails.application.routes.draw do
  get "show" => "test#show"
  get "non_restful" => "test#non_restful"

  get "scoped_index" => "scoped_decision_maker_test#index"
  get "scoped_custom" => "scoped_decision_maker_test#custom"
  get "scoped_other" => "scoped_decision_maker_test#other"
  get "scoped_non_authenticated" => "scoped_decision_maker_test#non_authenticated"
  get "scoped_non_authorized" => "scoped_decision_maker_test#non_authorized"
end
