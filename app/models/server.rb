class Server < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: true }
  validates :url, presence: true
end
