FactoryBot.define do
  factory :profile do
    gender { Faker::Gender.binary_type }
    category { Faker::Lorem.word }
    name { Faker::Name.name }
  end
end
