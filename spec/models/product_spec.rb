require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#valid?' do
    it 'inválido quando o código é vazio' do
      product = Product.new(code: '')

      product.valid?
      result = product.errors.include?(:code)

      expect(result).to be true
      expect(product.errors[:code]).to include('não pode ficar em branco')
    end

    it 'inválido quando o código tem menos de 9 caracteres' do
      product = Product.new(code: 'ABC12345')

      product.valid?
      result = product.errors.include?(:code)

      expect(result).to be true
      expect(product.errors[:code]).to include('deve ser composto por 3 letras e 6 números')
    end

    it 'inválido quando o código não é composto por 3 letras e 6 números' do
      product = Product.new(code: '123YYYYYY')

      product.valid?
      result = product.errors.include?(:code)

      expect(result).to be true
      expect(product.errors[:code]).to include('deve ser composto por 3 letras e 6 números')
    end

    it 'inválido quando o código já está em uso' do
      category = ProductCategory.create!(name: 'Eletrônico')
      Product.create!(name: 'TV42', code: 'ABC123456',
                      description: 'Descrição para o produto', brand: 'LG', price: 2500,
                      product_category: category)

      product = Product.new(code: 'ABC123456')

      product.valid?
      result = product.errors.include?(:code)

      expect(result).to be true
      expect(product.errors[:code]).to include('já está em uso')
    end

    it 'inválido quando o nome é vazio' do
      product = Product.new(name: '')

      product.valid?
      result = product.errors.include?(:name)

      expect(result).to be true
      expect(product.errors[:name]).to include('não pode ficar em branco')
    end

    it 'inválido quando a marca é vazia' do
      product = Product.new(brand: '')

      product.valid?
      result = product.errors.include?(:brand)

      expect(result).to be true
      expect(product.errors[:brand]).to include('não pode ficar em branco')
    end

    it 'inválido quando o preço é vazio' do
      product = Product.new(price: '')

      product.valid?
      result = product.errors.include?(:price)

      expect(result).to be true
      expect(product.errors[:price]).to include('não pode ficar em branco')
    end

    it 'inválido quando a descrição é vazia' do
      product = Product.new(description: '')

      product.valid?
      result = product.errors.include?(:description)

      expect(result).to be true
      expect(product.errors[:description]).to include('não pode ficar em branco')
    end

    it 'inválido quando a descrição tem menos que 10 caracteres' do
      product = Product.new(description: 'descrição')

      product.valid?
      result = product.errors.include?(:description)

      expect(result).to be true
      expect(product.errors[:description]).to include('é muito curto (mínimo: 10 caracteres)')
    end

    it 'inválido quando o preço é igual a zero' do
      product = Product.new(price: 0)

      product.valid?
      result = product.errors.include?(:price)

      expect(result).to be true
      expect(product.errors[:price]).to include('deve ser maior que 0')
    end

    it 'válido quando o preço é maior que zero' do
      product = Product.new(price: 1)

      product.valid?
      result = product.errors.include?(:price)

      expect(result).to be false
    end

    it 'inválido quando preço é menor que preço sazonal' do
      product = create(:product, price: 1000)
      create(:seasonal_price, product:, value: 800)

      product.update(price: 500)

      expect(product.errors[:price]).to include 'precisa ser maior que um preço sazonal existente'
    end

    it 'inválido quando o arquivo anexado não for imagem no formato JPEG ou PNG' do
      product = Product.new
      product.product_images.attach(io: Rails.root.join('spec/support/txt/Arquivo.txt').open,
                                    filename: 'Arquivo.txt')

      product.valid?
      result = product.errors.include?(:product_images)

      expect(result).to be true
      expect(product.errors[:product_images]).to include('precisa ser do formato JPEG ou PNG')
    end
  end
end
