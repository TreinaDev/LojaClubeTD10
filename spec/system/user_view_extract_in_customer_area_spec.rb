require 'rails_helper'

describe 'Usuário visualiza extrato de pontos na área do cliente' do
  it 'com sucesso' do
    user = create(:user, cpf: '30383993024')
    card_json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    card_fake_response = double('faraday_response', status: 200, body: card_json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(card_fake_response)
    extract_json_data = Rails.root.join('spec/support/json/extract.json').read
    extract_fake_response = double('faraday_response', status: 200, body: extract_json_data)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/extracts?card_number=44971089486246826370').and_return(extract_fake_response)

    login_as(user)
    visit root_path
    click_on 'Área do Cliente'
    click_on 'Meu Extrato'

    expect(page).to have_content 'Pedido 12345678912'
    within 'table' do
      expect(page).to have_css '.bi-arrow-up-circle.text-success'
      expect(page).to have_content 'Recarga'
      expect(page).to have_content '46'
      expect(page).to have_content '20'
    end
  end

  it 'e recebe uma mensagem padrão quando o cartão não possui nenhuma operação' do
    user = create(:user, cpf: '30383993024')
    card_json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    card_fake_response = double('faraday_response', status: 200, body: card_json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(card_fake_response)
    extract_fake_response = double('faraday_response', status: 200, body: '{}')
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/extracts?card_number=44971089486246826370').and_return(extract_fake_response)

    login_as(user)
    visit root_path
    click_on 'Área do Cliente'
    click_on 'Meu Extrato'

    expect(page).to have_content 'Nenhuma transação registrada neste cartão.'
    expect(page).not_to have_css '.bi-arrow-up-circle.text-success'
    expect(page).not_to have_content 'Recarga'
    expect(page).not_to have_content '46'
  end

  it 'e recebe uma mensagem de erro quando a API de cartões está fora' do
    user = create(:user, cpf: '30383993024')
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_raise(Faraday::ConnectionFailed)

    login_as(user)
    visit root_path
    click_on 'Área do Cliente'
    click_on 'Meu Extrato'

    expect(page).to have_content 'Não foi possível obter informações do extrato deste cartão.'
    expect(page).not_to have_content 'Recarga'
    expect(page).not_to have_content '46'
  end

  it 'enquanto admin, mas não consegue e é redirecionado para a página inicial' do
    admin = create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit extract_tab_path

    expect(page).to have_content 'Administrador não tem acesso a essa página'
    expect(current_path).to eq root_path
  end

  it 'enquanto visitante, mas não consegue e é redirecionado para o login' do
    visit extract_tab_path

    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
    expect(current_path).to eq new_user_session_path
  end
end
