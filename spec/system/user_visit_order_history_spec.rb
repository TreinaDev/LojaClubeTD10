require 'rails_helper'

describe 'Usuário acessa histórico de pedidos' do
  it 'a partir da área do cliente' do
    user = create(:user)
    login_as user

    visit customer_areas_path
    click_on 'Meus Pedidos'

    expect(current_path).to eq order_history_path
  end

  it 'com sucesso' do
    user = create(:user)
    order = create(:order, user:, status: 'pending')
    create(:order, user:, status: 'approved')
    order_json_data = Rails.root.join('spec/support/json/order_with_status_pending.json').read
    fake_response = double('faraday_response', status: 200, body: order_json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/payments/#{order.payment_code}").and_return(fake_response)

    login_as user
    visit customer_areas_path
    click_on 'Meus Pedidos'

    expect(page).to have_content '20.000 Pontos'
    expect(page).to have_content 'Aguardando pagamento'
    expect(page).to have_content 'Pagamento aprovado'
  end

  it 'com sucesso e o status do pedido é atualizado quando necessário' do
    user = create(:user)
    address = create(:address)
    create(:client_address, user:, address:, default: true)
    order = create(:order, user:, address:, status: 'pending', payment_code: 'KRYZSMPPGA')
    order_json_data = Rails.root.join('spec/support/json/order_with_status_approved.json').read
    fake_response = double('faraday_response', status: 201, body: order_json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/payments/#{order.payment_code}").and_return(fake_response)

    login_as user
    visit customer_areas_path
    click_on 'Meus Pedidos'

    expect(page).to have_content 'Pagamento aprovado'
  end

  it 'com sucesso, mas o status do pedido não é atualizado, pois a API de cartões está fora' do
    user = create(:user)
    address = create(:address)
    create(:client_address, user:, address:, default: true)
    order = create(:order, user:, address:, status: 'pending', payment_code: 'KRYZSMPPGA')
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/payments/#{order.payment_code}").and_raise(Faraday::ConnectionFailed)

    login_as user
    visit customer_areas_path
    click_on 'Meus Pedidos'
    msg = 'Falha em consultar o serviço de pagamentos. Os status pendentes podem estar desatualizados.'

    expect(page).to have_content msg
    expect(page).not_to have_content 'Pagamento aprovado'
  end

  it 'e recebe uma mensagem padrão quando não possui nenhum pedido' do
    user = create(:user)

    login_as user
    visit customer_areas_path
    click_on 'Meus Pedidos'

    expect(page).to have_content 'Não foi encontrado nenhum pedido.'
  end

  it 'enquanto admin, mas não consegue e é redirecionado para a página inicial' do
    admin = create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit order_history_path

    expect(page).to have_content 'Administrador não tem acesso a essa página'
    expect(current_path).to eq root_path
  end

  it 'enquanto visitante, mas não consegue e é redirecionado para o login' do
    visit order_history_path

    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
    expect(current_path).to eq new_user_session_path
  end
end
