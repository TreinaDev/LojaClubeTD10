require 'rails_helper'

describe 'Usuário entra no sistema' do
  it 'e compra um produto' do
    user = create(:user)
    product = create(:product, name: 'Camiseta')

    visit root_path
    click_on 'Camiseta'
    click_on 'Adicionar ao carrinho'
    click_on 'Ir para o checkout'
    fill_in 'Número do cartão', with: '0123456789'
    click_on 'Concluir compra'

    expect(page).to have_content 'Parabéns! Sua compra foi concluída com sucesso'

  end
end
