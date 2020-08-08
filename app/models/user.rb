class User < ApplicationRecord
  before_save { self.email = email.downcase }

  # Association
  has_many :articles, dependent: :destroy
  has_secure_password

  # Validation
  validates :username, presence: true, uniqueness: { case_sensitive: false },
   length: { minimum: 3, maximum: 25 }
  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false },
   length: { maximum: 105 }, format: { with: VALID_EMAIL_REGEX }

  def except_current_user(users)
    users.reject { |user| user.id == self.id }
  end

  def self.matches(field_name, param)
    where("#{field_name} like ?", "%#{param}%")
  end

  def self.email_matches(param)
    matches('email', param)
  end

  def self.username_matches(param)
    matches('username', param)
  end

  def self.first_last_name_matches(param)
    (matches('first_name', param) + matches('last_name', param)).uniq
  end

  def self.search(param)
    param.strip!
    query_result = (username_matches(param) + 
      email_matches(param) + first_last_name_matches(param)).uniq

    return nil unless query_result
    query_result
  end
end