class Project < ApplicationRecord
  include Searchable

  validates :name, presence: true
  validates :user_id, presence: true

  belongs_to :user
  has_many :tasks, dependent: :destroy

  scope :search, ->(query) { search_by_name(query) }
end
