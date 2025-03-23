class PokeController < ApplicationController
    require 'httparty'
  
    def create
      data = JSON.parse(request.body.read)
      nome_pokemon = data["nome"]
  
      # Verificando se o nome foi informado
      if nome_pokemon.blank?
        render json: { error: "Nome ou ID do Pokémon não informado." }, status: :unprocessable_entity
        return
      end
  
      # Verificando se os dados do Pokémon estão no cache
      cached_data = Rails.cache.read(nome_pokemon.downcase)
      if cached_data
        render json: { pokeApiPoke: cached_data }
        return
      end
  
      # Fazendo a requisição para a API do Pokémon
      begin
        response = HTTParty.get("https://pokeapi.co/api/v2/pokemon/#{nome_pokemon.downcase}")
  
        if response.code == 200
          poke_data = response.parsed_response
  
          # Processando os dados necessários
          result = {
            name: poke_data["name"],
            height: poke_data["height"],
            weight: poke_data["weight"],
            types: poke_data["types"].map { |type| type["type"]["name"] }.join(", "),
            image: poke_data["sprites"]["front_default"]
          }
  
          # Armazenando os dados no cache por 1 hora (ajuste o tempo conforme necessário)
          Rails.cache.write(nome_pokemon.downcase, result, expires_in: 1.hour)
  
          render json: { pokeApiPoke: result }
        else
          render json: { error: "Não foi possível encontrar o Pokémon." }, status: :not_found
        end
      rescue StandardError => e
        render json: { error: "Erro ao buscar dados do Pokémon: #{e.message}" }, status: :internal_server_error
      end
    end
  end
  