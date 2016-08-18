# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless User.exists?(email: 'test@admin.ru')
  User.create( role: :admin, email: 'test@admin.ru', password: 'longpass', password_confirmation: 'longpass')
end
unless User.exists?(email: 'test@user.ru')
  User.create(role: 'user', email: 'test@user.ru', password: 'longpass', password_confirmation: 'longpass')
end
