class Article < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :article_categories
  has_many :categories, through: :article_categories

  # Valifations
  validates :title, presence: true, length: { minimum: 5, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10, maximum: 500 }

  def self.matches(field_name, param)
    where("#{field_name} like ?", "%#{param}%")
  end

  def self.article_user_matches(field_name, param)
    joins(:user).where("users.#{field_name} LIKE ?", "%#{param}%")
  end

  def self.match_by_author(param)
    (article_user_matches('username', param) + 
      article_user_matches('email', param)).uniq
  end

  def self.title_matches(param)
    matches('title', param)
  end

  def self.description_matches(param)
    matches('description', param)
  end

  def self.search(param)
    param.strip!
    query_result = (title_matches(param) + description_matches(param) +
      match_by_author(param)).uniq

    return nil unless query_result
    query_result
  end
end

