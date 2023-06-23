require 'rails_helper'

describe 'API de empresas' do
  it 'e a requisição é concluida com sucesso' do
    json_data = Rails.root.join('spec/support/json/companies.json').read
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/companies').and_return(fake_response)

    response = Faraday.get('http://localhost:3000/api/v1/companies')

    expect(response.status).to eq 200
    expect(response.body).to include 'registration_number'
    expect(response.body).to include 'brand_name'
    expect(response.body).to include 'corporate_name'
    expect(response.body).to include 'active'
  end

  it 'e retorna os dados das empresas corretamente' do
    json_data = Rails.root.join('spec/support/json/companies.json').read
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/companies').and_return(fake_response)

    response = Faraday.get('http://localhost:3000/api/v1/companies')

    expect(response.status).to eq 200
    json_response = JSON.parse(response.body)
    expect(json_response.length).to eq 2
    expect(json_response[0]['registration_number']).to eq '57806849000174'
    expect(json_response[0]['brand_name']).to eq 'Rebase'
    expect(json_response[0]['corporate_name']).to eq 'Rebase LTDA.'
    expect(json_response[0]['active']).to eq true
    expect(json_response[1]['registration_number']).to eq '89987772000172'
    expect(json_response[1]['brand_name']).to eq 'Vindi'
    expect(json_response[1]['corporate_name']).to eq 'Vindi LTDA.'
    expect(json_response[1]['active']).to eq false
  end

  it 'e retorna vazio se não tiver empresas cadastradas' do
    fake_response = double('faraday_response', status: 200, body: [])
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/companies').and_return(fake_response)

    response = Faraday.get('http://localhost:3000/api/v1/companies')

    expect(response.status).to eq 200
    expect(response.body).to eq []
  end

  it 'e falha ao retornar os dados da empresa' do
    fake_response = double('faraday_response', status: 500,
                                               body: { errors: 'Erro interno - Empresas não carregadas' })
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/companies').and_return(fake_response)

    response = Faraday.get('http://localhost:3000/api/v1/companies')

    expect(response.status).to eq 500
    expect(response.body[:errors]).to include 'Erro interno - Empresas não carregadas'
  end
end
