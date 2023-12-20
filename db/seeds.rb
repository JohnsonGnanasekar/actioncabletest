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


# Set the number of records to create
num_records = 100_000

# Batch size for efficient processing
batch_size = 10000

# Calculate the number of batches
num_batches = (num_records / batch_size.to_f).ceil

puts "Seeding #{num_records} profiles..."

# Helper method to generate an array of profile attributes
def generate_profiles(batch_size)
  categories = %w[realistic anime]
  genders = %w[male female]
  Array.new(batch_size) do
    {
      gender: genders.sample,
      category: categories.sample,
      name: Faker::Name.name,
      created_at: Faker::Time.between(from: 1.year.ago, to: Time.now),
      updated_at: Faker::Time.between(from: 1.year.ago, to: Time.now)
    }
  end
end


# Start seeding
execution_time = Benchmark.measure do
num_batches.times do |batch_number|
  puts "Processing batch #{batch_number + 1}/#{num_batches}"

  # Use the `insert_all` method for efficient bulk inserts
  Profile.insert_all(generate_profiles(batch_size))
end
end

puts 'Seeding completed.'
puts "Execution Time: #{execution_time.real} seconds"
