require 'rails_helper'

describe 'Usuário entra no sistema' do
  it 'e cria uma conta' do
    visit new_user_registration_path
    fill_in 'Nome', with: 'João'
    fill_in 'E-mail', with: 'joao@ig.com.br'
    fill_in 'CPF', with: '26502001033'
    fill_in 'Número de telefone', with: '19999999999'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme a senha', with: 'password'
    click_on 'Registrar'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Bem vindo!'
    expect(page).not_to have_content 'administrador'
  end

  it 'e cria uma conta com cartão ativo' do
    json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/30383993024").and_return(fake_response)

    visit new_user_registration_path
    fill_in 'Nome', with: 'João'
    fill_in 'E-mail', with: 'joao@ig.com.br'
    fill_in 'CPF', with: '30383993024'
    fill_in 'Número de telefone', with: '19999999999'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme a senha', with: 'password'
    click_on 'Registrar'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Bem vindo! O seu cartão está ativo, vamos às compras.'
    expect(page).not_to have_content 'administrador'
  end
  
  it 'e cria uma conta que não tem cartão ativo' do
    category = create(:product_category)
    create(:product, name: 'Geladeira branca', code: 'GLD678456', description: 'Geladeira bonita',
                     price: 200, product_category: category)
    fake_response = double('faraday_response', status: 404, body: { errros: 'Cartão não encontrado' })
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/26502001033").and_return(fake_response)

    visit new_user_registration_path
    fill_in 'Nome', with: 'João'
    fill_in 'E-mail', with: 'joao@ig.com.br'
    fill_in 'CPF', with: '26502001033'
    fill_in 'Número de telefone', with: '19999999999'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme a senha', with: 'password'
    click_on 'Registrar'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Bem vindo! Você não tem cartão ativo no nosso clube, entre em contato com sua empresa.'
    expect(page).not_to have_content 'administrador'
  end
  it 'e cria uma conta e ocorre errro na api de cartões' do
    category = create(:product_category)
    create(:product, name: 'Geladeira branca', code: 'GLD678456', description: 'Geladeira bonita',
                     price: 200, product_category: category)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/26502001033").and_raise(Faraday::ConnectionFailed)

    visit new_user_registration_path
    fill_in 'Nome', with: 'João'
    fill_in 'E-mail', with: 'joao@ig.com.br'
    fill_in 'CPF', with: '26502001033'
    fill_in 'Número de telefone', with: '19999999999'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme a senha', with: 'password'
    click_on 'Registrar'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Bem vindo! Ocorreu um erro interno! Seus dados podem estar desatualizados'
    expect(page).not_to have_content 'administrador'
  end

  it 'e cria uma conta administradora' do
    visit new_user_registration_path
    fill_in 'Nome', with: 'Aldaberto'
    fill_in 'E-mail', with: 'aldaberto@punti.com'
    fill_in 'CPF', with: '73962060065'
    fill_in 'Número de telefone', with: '79981546487'
    fill_in 'Senha', with: 'f4k3p455w0rd'
    fill_in 'Confirme a senha', with: 'f4k3p455w0rd'
    click_on 'Registrar'

    expect(current_path).to eq root_path
    expect(page).to have_content '(ADMIN)'
  end

  it 'e tenta criar uma conta com infomações incorretas' do
    visit new_user_registration_path
    fill_in 'Nome', with: ''
    fill_in 'E-mail', with: 'aldabertopunti.com'
    fill_in 'CPF', with: '73962060088'
    fill_in 'Número de telefone', with: '7998154648'
    fill_in 'Senha', with: 'f4k3p455w0rd'
    fill_in 'Confirme a senha', with: 'f4k3p455w0rd'
    click_on 'Registrar'

    expect(page).to have_content 'Não foi possível salvar este(a) usuário:'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'E-mail não é válido'
    expect(page).to have_content 'CPF inválido.'
    expect(page).to have_content 'Número de telefone deve conter 11 números.'
  end
end
