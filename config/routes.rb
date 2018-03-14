Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "/stats", to: "satellite_record#stats"

  get "/health", to: "satellite_record#health"


end
