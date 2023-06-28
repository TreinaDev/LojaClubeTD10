require 'rails_helper'

describe 'Usuário atualiza o saldo de pontos' do
  it 'enquanto visitante não consegue' do
    post update_points_path

    expect(flash[:alert]).to eq 'Você precisa fazer login ou se registrar antes de continuar'
    expect(response).to redirect_to new_user_session_path
    expect(response).to have_http_status :found
  end
  it 'enquanto admin não consegue' do
    admin = create(:user, email: 'admin@punti.com')

    login_as(admin)
    post update_points_path

    expect(flash[:alert]).to eq 'Administrador não tem acesso a essa página'
    expect(response).to redirect_to root_path
    expect(response).to have_http_status :found
  end
  it 'enquanto usuário com cartão ativo com sucesso' do
    user = create(:user, email: 'user@email.com', cpf: '30383993024')
    create(:card_info, user:, points: 5000)
    card_json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    card_fake_response = double('faraday_response', status: 200, body: card_json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(card_fake_response)

    login_as(user)
    post update_points_path

    expect(flash[:notice]).to eq 'Saldo de pontos atualizado!'
    expect(user.card_info['points']).to eq 1000
    expect(response).to redirect_to customer_areas_path
    expect(response).to have_http_status :found
  end
  it 'enquanto usuário sem cartão ativo não consegue' do
    user = create(:user)
    card_fake_response = double('faraday_response', status: 404, body: { errors: 'Cartão não encontrado' })
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(card_fake_response)

    login_as(user)
    post update_points_path

    expect(flash[:alert]).to eq 'Cartão não encontrado. Impossível atualizar saldo!'
    expect(response).to redirect_to customer_areas_path
    expect(response).to have_http_status :found
  end
end
