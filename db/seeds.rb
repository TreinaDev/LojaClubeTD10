User.create!(name: 'Usuário Administrador', email: 'admin@punti.com', password: 'senha1234',
             phone_number: '19998555544', cpf: '56685728701')
User.create!(name: 'Joana', email: 'joana@provedor.com', password: 'senha1234',
             phone_number: '19998555542', cpf: '91345840055')

user = User.create!(name: 'Maria Sousa', email: 'maria@provedor.com', password: 'senha1234',
                    phone_number: '19998555543', cpf: '66610881090')

CardInfo.create!(user:, conversion_tax: '20', name: 'Gold', status: 'active', points: 1000)

category1 = ProductCategory.create!(name: 'TV')
category2 = ProductCategory.create!(name: 'Celular')
ProductCategory.create!(name: 'Eletrodomésticos')
ProductCategory.create!(name: 'Produtos de Higiene')
subcategory = ProductSubcategory.create!(parent_id: category1.id, name: 'Smart')

product1 = Product.new(name: 'TV55', code: 'TVS123456',
                       description: 'Smart TV 65” 4K Neo QLED Samsung VA 120Hz - Wi-Fi Bluetooth Alexa Google 4 HDMI',
                       brand: 'Samsung', price: 2500, product_category: category1)
product1.product_images.attach(io: Rails.root.join('spec/support/imgs/tv_1.jpg').open, filename: 'tv_1.jpg')
product1.product_images.attach(io: Rails.root.join('spec/support/imgs/tv_11.jpg').open, filename: 'tv_11.jpg')
product1.save!

product2 = Product.new(name: 'TV52', code: 'TVS654321',
                       description: 'Smart TV HD LED 32” Samsung T4300 - Wi-Fi HDR 2 HDMI 1 USB',
                       brand: 'Samsung', price: 3500, product_category: subcategory)
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

Company.create!(registration_number: '34997507000183', corporate_name: 'Rebase LTDA.', brand_name: 'Rebase')

promotional_campaign_a = PromotionalCampaign.new(name: 'Campanha 1 Empresa 1', start_date:  1.month.ago,
                                                 end_date: 2.weeks.ago, company: Company.first)
promotional_campaign_a.save(validate: false)

campaign_category_a = CampaignCategory.new(promotional_campaign: promotional_campaign_a, product_category: category1,
                                           discount: 10)
campaign_category_a.save(validate: false)

campaign_category_b = CampaignCategory.new(promotional_campaign: promotional_campaign_a, product_category: category2,
                                           discount: 20)
campaign_category_b.save(validate: false)

promotional_campaign_b = PromotionalCampaign.create!(name: 'Campanha 2 Empresa 1', start_date: 1.week.from_now,
                                                     end_date: 1.month.from_now, company: Company.first)

CampaignCategory.create!(promotional_campaign: promotional_campaign_b, product_category: category1, discount: 20)

Company.create!(registration_number: '86654033000170', corporate_name: 'Punti LTDA.', brand_name: 'Punti')
promotional_campaign_c = PromotionalCampaign.new(name: 'Campanha 1 Empresa 2', start_date: 2.days.from_now,
                                                 end_date: 1.month.from_now, company: Company.last)
promotional_campaign_c.save(validate: false)
