Rails.application.routes.draw do
  # Página inicial
  root "poke#index"

  # Rota pra pegar o nome ou número do Pokemon
  post '/poke', to: 'poke#create'
end