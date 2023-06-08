require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#valid?' do
    it 'true (errors.include) quando o código é vazio' do
      product = Product.new(code: '')

      product.valid?
      result = product.errors.include?(:code)

      expect(result).to be true
      expect(product.errors[:code]).to include('não pode ficar em branco')
    end

    it 'true (errors.include) quando o código tem menos de 9 caracteres' do
      product = Product.new(code: 'ABC12345')

      product.valid?
      result = product.errors.include?(:code)

      expect(result).to be true
      expect(product.errors[:code]).to include(' deve ser composto por 3 letras e 6 caracteres.')
    end

    it 'true (errors.include) quando o código não é composto por 3 letras e 6 caracteres' do
      product = Product.new(code: '123YYYYYY')

      product.valid?
      result = product.errors.include?(:code)

      expect(result).to be true
      expect(product.errors[:code]).to include(' deve ser composto por 3 letras e 6 caracteres.')
    end

    it 'true (errors.include) quando o código tem menos de 9 caracteres' do
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

    it 'true (errors.include) quando o código é vazio' do
      product = Product.new(name: '')

      product.valid?
      result = product.errors.include?(:name)

      expect(result).to be true
      expect(product.errors[:name]).to include('não pode ficar em branco')
    end

    it 'true (errors.include) quando o marca é vazio' do
      product = Product.new(brand: '')

      product.valid?
      result = product.errors.include?(:brand)

      expect(result).to be true
      expect(product.errors[:brand]).to include('não pode ficar em branco')
    end

    it 'true (errors.include) quando o preço é vazio' do
      product = Product.new(price: '')

      product.valid?
      result = product.errors.include?(:price)

      expect(result).to be true
      expect(product.errors[:price]).to include('não pode ficar em branco')
    end

    it 'true (errors.include) quando o descrição é vazio' do
      product = Product.new(description: '')

      product.valid?
      result = product.errors.include?(:description)

      expect(result).to be true
      expect(product.errors[:description]).to include('não pode ficar em branco')
    end

    it 'true (errors.include) quando o descrição tem menos que 10 caracteres' do
      product = Product.new(description: 'descrição')

      product.valid?
      result = product.errors.include?(:description)

      expect(result).to be true
      expect(product.errors[:description]).to include('é muito curto (mínimo: 10 caracteres)')
    end

    it 'true (errors.include) quando o preço não pode ser igual a zero' do
      product = Product.new(price: 0)

      product.valid?
      result = product.errors.include?(:price)

      expect(result).to be true
      expect(product.errors[:price]).to include('deve ser maior que 0')
    end
  end
end
