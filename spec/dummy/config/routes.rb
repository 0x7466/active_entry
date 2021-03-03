Rails.application.routes.draw do
  get "show" => "test#show"
  get "non_restful" => "test#non_restful"
end
