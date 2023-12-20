class Profile < ApplicationRecord
  validates :gender, presence: true
  validates :category, presence: true
  validates :name, presence: true
  scope :filter_by_gender, ->(gender) { where(gender: gender) }
  scope :filter_by_category, ->(category) { where(category: category) }
end
