class User < ActiveRecord::Base
  attr_reader :password
  after_initialize :ensure_session_token
  validates :user_name, :password, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  
  has_many(
    :cats,
    class_name: 'Cat',
    foreign_key: :user_id,
    primary_key: :id
  )
  has_many(
    :cat_rental_requests,
    class_name: 'ClassRentalRequest',
    foreign_key: :user_id,
    primary_key: :id
  )

  def self.find_by_credentials(user_name, password)
    user = find_by_user_name(user_name)
    return if user.nil?
    user if user.is_password?(password)
  end
    
  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64(16)
    self.save!
    self.session_token
  end
  
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
  
  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
  
  private
  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64(16)
  end
end
