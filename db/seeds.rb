User.create!(name: 'Usuário Administrador', email: 'admin@punti.com', password: 'senha1234',
             phone_number: '19998555544', cpf: '56685728701')
User.create!(name: 'Maria Sousa', email: 'maria@provedor.com', password: 'senha1234',
             phone_number: '19998555544', cpf: '66610881090')

category1 = ProductCategory.create!(name: 'TV')
category2 = ProductCategory.create!(name: 'Celular')

product1 = Product.new(name: 'TV55', code: 'TVS123456',
                       description: 'Smart TV 65” 4K Neo QLED Samsung VA 120Hz - Wi-Fi Bluetooth Alexa Google 4 HDMI',
                       brand: 'Samsung', price: 2500, product_category: category1)
product1.product_images.attach(io: Rails.root.join('spec/support/imgs/tv_1.jpg').open, filename: 'tv_1.jpg')
product1.product_images.attach(io: Rails.root.join('spec/support/imgs/tv_11.jpg').open, filename: 'tv_11.jpg')
product1.save!

product2 = Product.new(name: 'TV52', code: 'TVS654321',
                       description: 'Smart TV HD LED 32” Samsung T4300 - Wi-Fi HDR 2 HDMI 1 USB',
                       brand: 'Samsung', price: 3500, product_category: category1)
product2.product_images.attach(io: Rails.root.join('spec/support/imgs/tv_2.jpg').open, filename: 'tv_2.jpg')
product2.product_images.attach(io: Rails.root.join('spec/support/imgs/tv_22.jpg').open, filename: 'tv_22.jpg')
product2.save!

product3 = Product.new(name: 'Celular A04e', code: 'CEL123456',
                       description: 'Smartphone Samsung Galaxy A04e 64GB Azul 4G Octa-Core 3GB RAM 6,5” ',
                       brand: 'Samsung', price: 2500, product_category: category2)
product3.product_images.attach(io: Rails.root.join('spec/support/imgs/cel_1.jpg').open, filename: 'cel_1.jpg')
product3.product_images.attach(io: Rails.root.join('spec/support/imgs/cel_11.jpg').open, filename: 'cel_11.jpg')
product3.save!

product4 = Product.new(name: 'Celular A03', code: 'CEL654321',
                       description: 'Smartphone Samsung Galaxy A03',
                       brand: 'Samsung', price: 3500, product_category: category2)
product4.product_images.attach(io: Rails.root.join('spec/support/imgs/cel_2.jpg').open, filename: 'cel_2.jpg')
product4.product_images.attach(io: Rails.root.join('spec/support/imgs/cel_22.jpg').open, filename: 'cel_22.jpg')
product4.save!

Company.create!(registration_number: '86654033000170', corporate_name: 'Punti LTDA.', brand_name: 'Punti')
Company.create!(registration_number: '34997507000183', corporate_name: 'CodeCampus SA.', brand_name: 'CodeCampus')

PromotionalCampaign.create!(name: 'Natal 2023', start_date: 1.week.from_now, end_date: 1.month.from_now,
                            company: Company.first)
PromotionalCampaign.create!(name: 'Verão 2023', start_date: 5.days.from_now, end_date: 2.months.from_now,
                            company: Company.first)
