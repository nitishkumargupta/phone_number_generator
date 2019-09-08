Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
  	resources :phone_numbers, only: %i[create] do
  		collection do
  			get :check_number_availability
  		end
  	end
	end

end
