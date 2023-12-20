# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password123' } # You might want to use a more secure password
    encrypted_password { Devise::Encryptor.digest(User, password) }

    # Add other attributes as needed

    trait :confirmed do
      confirmed_at { Time.current }
    end
  end
end

