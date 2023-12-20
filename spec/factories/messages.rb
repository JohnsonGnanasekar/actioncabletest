# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    body { Faker::Lorem.sentence }
    user
  end
end
