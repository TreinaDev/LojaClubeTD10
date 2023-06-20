require 'rails_helper'

describe 'API de Consulta de cartão' do
  it 'retorna os dados do cartão com sucesso' do
    user = create(:user)
    json_data = File.read(Rails.root.join('spec/support/json/card_data.json'))
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("http://localhost:3333/api/v1/cards/#{user.cpf}").and_return(fake_response)

    response = Faraday.get("http://localhost:3333/api/v1/cards/#{user.cpf}")
    
    expect(response.status).to eq 200
    expect(response.body).to include 'id'
    expect(response.body).to include 'cpf'
    expect(response.body).to include 'points'
    expect(response.body).to include 'name'
    expect(response.body).to include 'status'
    expect(response.body).to include 'conversion_tax'
  end

  it 'falha ao retornar dados do cartão' do
    user = create(:user)
    fake_response = double('faraday_response', status: 404, body: { errors: 'Cartão não encontrado' })
    allow(Faraday).to receive(:get).with("http://localhost:3333/api/v1/cards/#{user.cpf}").and_return(fake_response)

    response = Faraday.get("http://localhost:3333/api/v1/cards/#{user.cpf}")
    
    expect(response.status).to eq 404
    expect(response.body[:errors]).to include "Cartão não encontrado"
  end
end
