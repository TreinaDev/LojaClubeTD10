require 'rails_helper'

describe 'Administrador registra uma subcategoria' do
  it 'com sucesso' do
    admin = FactoryBot.create(:user, email: 'admin@punti.com')
    FactoryBot.create(:product_category, name: 'Categoria Teste')

    login_as(admin)
    visit new_product_subcategory_path
    fill_in 'Nome', with: 'Subcategoria Teste'
    select 'Categoria Teste', from: 'Categoria de produtos'
    click_on 'Criar subcategoria'

    expect(page).to have_content 'Subcategoria criada com sucesso.'
    expect(page).to have_content 'Categoria Teste'
    expect(page).to have_content 'Subcategoria Teste'
    expect(current_path).to eq product_subcategories_path
  end

  context 'sem sucesso' do
    it 'por ter nome igual categoria existente' do
      admin = FactoryBot.create(:user, email: 'admin@punti.com')
      FactoryBot.create(:product_category, name: 'Categoria Teste')
      FactoryBot.create(:product_category, name: 'Outra Categoria Teste ')

      login_as(admin)
      visit new_product_subcategory_path
      fill_in 'Nome', with: 'Categoria Teste'
      select 'Outra Categoria Teste', from: 'Categoria de produtos'
      click_on 'Criar subcategoria'

      expect(page).to have_content 'Não foi possível criar a subcategoria, revise os campos abaixo:'
      expect(page).to have_content 'Nome já está em uso'
    end

    it 'por ter nome igual subcategoria existente' do
      admin = FactoryBot.create(:user, email: 'admin@punti.com')
      FactoryBot.create(:product_category, name: 'Categoria Teste')
      FactoryBot.create(:product_subcategory, name: 'Subcategoria Teste')

      login_as(admin)
      visit new_product_subcategory_path
      fill_in 'Nome', with: 'Subcategoria Teste'
      select 'Categoria Teste', from: 'Categoria de produtos'
      click_on 'Criar subcategoria'

      expect(page).to have_content 'Não foi possível criar a subcategoria, revise os campos abaixo:'
      expect(page).to have_content 'Nome já está em uso'
    end

    it 'por fornecer informações incompletas' do
      admin = FactoryBot.create(:user, email: 'admin@punti.com')

      login_as(admin)
      visit new_product_subcategory_path
      fill_in 'Nome', with: ''
      click_on 'Criar subcategoria'

      expect(page).to have_content 'Não foi possível criar a subcategoria, revise os campos abaixo:'
      expect(page).to have_content 'Nome não pode ficar em branco'
      expect(page).to have_content 'Categoria de produtos é obrigatório(a)'
    end

    it 'como usuário comum tenta acessar, mas não tem acesso' do
      user = FactoryBot.create(:user, email: 'admin@mail.com')

      login_as(user)
      visit new_product_subcategory_path

      expect(current_path).to eq root_path
      expect(page).to have_content 'Você não possui acesso a este módulo'
    end

    it 'como usuário visitante tenta acessar, mas não tem acesso' do
      visit new_product_subcategory_path

      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
    end
  end
end
