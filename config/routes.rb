Rails.application.routes.draw do
  get '/', to: redirect('characters')
  resources :characters, only: [:index]
end
