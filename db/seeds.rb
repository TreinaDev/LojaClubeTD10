# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
category1 = ProductCategory.create!(name: 'TV')
category2 = ProductCategory.create!(name: 'Celular')
ProductCategory.create!(name: 'Informática')

Product.create!(name: 'TV55', code: 'TVS123456',
                description: 'Smart TV 65” 4K Neo QLED Samsung VA 120Hz - Wi-Fi Bluetooth Alexa Google 4 HDMI',
                brand: 'Samsung', price: 2500, product_category: category1)

Product.create!(name: 'TV52', code: 'TVS654321',
                description: 'Smart TV HD LED 32” Samsung T4300 - Wi-Fi HDR 2 HDMI 1 USB',
                brand: 'Samsung', price: 3500, product_category: category1)

Product.create!(name: 'Celular A04e', code: 'CEL123456',
                description: 'Smartphone Samsung Galaxy A04e 64GB Azul 4G Octa-Core 3GB RAM 6,5” ',
                brand: 'Samsung', price: 2500, product_category: category2)

Product.create!(name: 'Celular A03', code: 'CEL654321',
                description: 'Smartphone Samsung Galaxy A03',
                brand: 'Samsung', price: 3500, product_category: category2)
Product.create!(name: 'Celular A07', code: 'CEL657688',
                description: 'Smartphone Samsung Galaxy A07',
                brand: 'Samsung', price: 3500, product_category: category2)
Product.create!(name: 'Celular A08', code: 'CEL651234',
                description: 'Smartphone Samsung Galaxy A08',
                brand: 'Samsung', price: 3500, product_category: category2)
