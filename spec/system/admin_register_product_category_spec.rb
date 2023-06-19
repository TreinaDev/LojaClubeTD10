require 'rails_helper'

describe 'Administrador registra uma nova categoria' do
  it 'com sucesso' do
    admin = create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit product_categories_path
    click_on 'Nova Categoria'
    fill_in 'Nome', with: 'Categoria teste'
    click_on 'Cadastrar'

    expect(page).to have_content 'Categoria teste'
    expect(page).to have_content 'Categoria criada com sucesso.'
  end

  it 'e falha pois o nome ficou em branco' do
    admin = create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit product_categories_path
    click_on 'Nova Categoria'
    fill_in 'Nome', with: ''
    click_on 'Cadastrar'

    expect(page).to have_content 'Nome não pode ficar em branco'
  end

  it 'e falha pois o nome já existe' do
    category = create(:product_category)
    admin = create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit product_categories_path
    click_on 'Nova Categoria'
    fill_in 'Nome', with: category.name
    click_on 'Cadastrar'

    expect(page).to have_content 'Nome já está em uso'
  end

  it 'e usuário comum não consegue acessar' do
    user = FactoryBot.create(:user)

    login_as(user)
    visit product_categories_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui permissão para realizar esta ação.'
  end

  it 'como visitante e não tem permissão' do
    visit product_categories_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end
end
