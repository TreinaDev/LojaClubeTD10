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
    order = create(:order, user:, status: 'approved')

    login_as user
    visit customer_areas_path
    click_on 'Meus Pedidos'

    expect(page).to have_content '20.000'
    expect(page).to have_content 'Aguardando aprovação'
    expect(page).to have_content 'Pagamento aprovado'
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

