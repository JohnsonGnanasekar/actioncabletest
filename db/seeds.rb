# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'
require 'benchmark'

Server.create(name: 'server-1', url: 'http://34.36.42.74/api/v1/chat')
Server.create(name: 'server-2', url: 'http://34.36.42.74/api/v1/chat')

categories = ['realistic', 'anime']
genders = ['male', 'female']

# Generate 100,000 profiles
execution_time = Benchmark.measure do
100_000.times do
    Profile.create!(
      gender: genders.sample,
      category: categories.sample,
      name: Faker::Name.name
    )
end
end

puts "Execution Time: #{execution_time.real} seconds"