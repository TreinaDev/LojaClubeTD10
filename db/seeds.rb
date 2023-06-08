category = ProductCategory.create!(name: 'Eletrônico')
Product.create!(name: 'TV42', code: 'ABC123456', description: 'Descrição para o produto', brand: 'LG',
                price: 2500, product_category: category)
Product.create!(name: 'TV52', code: 'ABC654321', description: 'Descrição para o produto', brand: 'Samsung',
                price: 3500, product_category: category)
