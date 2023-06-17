require 'rails_helper'

describe 'Usuário pesquisa um produto' do
  it 'a partir de um botão na navbar' do
    visit root_path
    find('#searchProduct').click

    within('#searchModal') do
      expect(page).to have_field 'query'
      expect(page).to have_button 'Buscar'
    end
  end
  it 'e encontra o produto, nenhum outro diferente' do
    category = create(:product_category, name: 'Celulares')
    create(:product, name: 'Carro Veloz', code: 'ZXA123789', product_category: category)
    create(:product, name: 'Moto Veloz', code: 'AZX123789', product_category: category)

    visit root_path
    find('#searchProduct').click
    fill_in 'query',	with: 'Carro Veloz'
    click_on 'Buscar'

    expect(page).to have_content '1 resultado encontrado'
    within('.card#ZXA123789') do
      expect(page).to have_link 'Carro Veloz'
      expect(page).to have_content 'Descrição do produto'
    end
    expect(page).not_to have_content 'Moto Veloz'
  end
  it 'e encontra vários produtos' do
    category = create(:product_category, name: 'Celulares')
    create(:product, name: 'Celular 1', code: 'AFG123456', product_category: category)
    create(:product, name: 'Celular 2', code: 'ZXF456123', product_category: category)
    create(:product, name: 'Calculadora', code: 'CAL456123', product_category: category)

    visit root_path
    find('#searchProduct').click
    fill_in 'query',	with: 'Celular'
    click_on 'Buscar'

    expect(page).to have_content '2 resultados encontrados'
    within('.card#AFG123456') do
      expect(page).to have_link 'Celular 1'
      expect(page).to have_content 'Descrição do produto'
    end
    within('.card#ZXF456123') do
      expect(page).to have_link 'Celular 2'
      expect(page).to have_content 'Descrição do produto'
    end
    expect(page).not_to have_css '.card#CAL456123'
    expect(page).not_to have_link 'Calculadora'
  end
  it 'com sucesso, ao informar alguma letra de um produto' do
    category = create(:product_category, name: 'Celulares')
    create(:product, name: 'Celular', code: 'AFG123456', product_category: category)
    create(:product, name: 'Selular', code: 'ZXF456123', product_category: category)
    create(:product, name: 'Celula', code: 'CLL456123', product_category: category)
    create(:product, name: 'Arroz', code: 'ARR456123', product_category: category)

    visit root_path
    find('#searchProduct').click
    fill_in 'query',	with: 'lula'
    click_on 'Buscar'

    expect(page).to have_content '3 resultados encontrados'
    within('.card#AFG123456') do
      expect(page).to have_link 'Celular'
    end
    within('.card#ZXF456123') do
      expect(page).to have_link 'Selular'
    end
    within('.card#CLL456123') do
      expect(page).to have_link 'Celula'
    end
    expect(page).not_to have_css '.card#ARR456123'
    expect(page).not_to have_link 'ARR456123'
  end
  it 'e recebe menssagem que não foi encontrado nenhum produto' do
    visit root_path
    find('#searchProduct').click
    fill_in 'query',	with: 'Calça'
    click_on 'Buscar'

    expect(page).to have_content 'Nenhum produto encontrado!'
  end
end
