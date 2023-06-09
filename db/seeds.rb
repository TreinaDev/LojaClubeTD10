category1 = ProductCategory.create!(name: 'TV')
category2 = ProductCategory.create!(name: 'Celular')

product1 = Product.new(name: 'TV55', code: 'TVS123456',
                       description: 'Smart TV 65” 4K Neo QLED Samsung VA 120Hz - Wi-Fi Bluetooth Alexa Google 4 HDMI',
                       brand: 'Samsung', price: 2500, product_category: category1)
product1.product_images.attach(io: Rails.root.join('app/assets/images/tv_1.jpg').open, filename: 'tv_1.jpg')
product1.product_images.attach(io: Rails.root.join('app/assets/images/tv_11.jpg').open, filename: 'tv_11.jpg')
product1.save!

product2 = Product.new(name: 'TV52', code: 'TVS654321',
                       description: 'Smart TV HD LED 32” Samsung T4300 - Wi-Fi HDR 2 HDMI 1 USB',
                       brand: 'Samsung', price: 3500, product_category: category1)
product2.product_images.attach(io: Rails.root.join('app/assets/images/tv_2.jpg').open, filename: 'tv_2.jpg')
product2.product_images.attach(io: Rails.root.join('app/assets/images/tv_22.jpg').open, filename: 'tv_22.jpg')
product2.save!

product3 = Product.new(name: 'Celular A04e', code: 'CEL123456',
                       description: 'Smartphone Samsung Galaxy A04e 64GB Azul 4G Octa-Core 3GB RAM 6,5” ',
                       brand: 'Samsung', price: 2500, product_category: category2)
product3.product_images.attach(io: Rails.root.join('app/assets/images/cel_1.jpg').open, filename: 'cel_1.jpg')
product3.product_images.attach(io: Rails.root.join('app/assets/images/cel_11.jpg').open, filename: 'cel_11.jpg')
product3.save!

product4 = Product.new(name: 'Celular A03', code: 'CEL654321',
                       description: 'Smartphone Samsung Galaxy A03',
                       brand: 'Samsung', price: 3500, product_category: category2)
product4.product_images.attach(io: Rails.root.join('app/assets/images/cel_2.jpg').open, filename: 'cel_2.jpg')
product4.product_images.attach(io: Rails.root.join('app/assets/images/cel_22.jpg').open, filename: 'cel_22.jpg')
product4.save!
