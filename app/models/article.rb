class Article < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :article_categories
  has_many :categories, through: :article_categories

  # Valifations
  validates :title, presence: true, length: { minimum: 5, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10, maximum: 500 }
end

