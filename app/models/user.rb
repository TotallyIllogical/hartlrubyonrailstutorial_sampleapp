class User < ApplicationRecord

  # Makes a token available for storage outside the database
  attr_accessor :remember_token, :activation_token


  # Changes the inserted email to downcase before save
  before_save :downcase_email
  # Create a activation digest before creating user model
  before_create :create_activation_digest

  # Validates so that name is set, and that the length isn't over 50 characters long
  validates :name, presence: true, length: { maximum: 50 }

  # Validates so that the email is set, that it isn't over over 255 characters long, matches the pattern from the regex and
  # that it is unique (and the unique check is not case-sensitive)
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  # Built-in function
  has_secure_password

  # Validates thar a password is set and that the length is longer then 6 characters
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  def User.digest(string)
    # Sets to cost to BCrypt::Engine::MIN_COST if ActiveModel::SecurePassword.min_cost is true
    # otherwise BCrypt::Engine.cost
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    # Create Password with BCrypt and modify it with cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    # User.new_token & User.digest(), see above
    self.remember_token = User.new_token
    # update_attribute is a built in function that bypasses the validation
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    # Return false if remember_digest doesn't exist
    return false if digest.nil?
    # Question: ??
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    # update_attribute is a built in function that bypasses the validation
    update_attribute(:remember_digest, nil)
  end

  def activate
    # Rewrote the function from having the two seperate queries bellow to just one
    # update_attribute(:activated, true)
    # update_attribute(:activated_at, Time.zone.now)
    # Set activated to true and set activated_at to "now"
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    # Send an activation mail
    UserMailer.account_activation(self).deliver_now
  end

  private

    # Converts emails to lowercase
    def downcase_email
      email.downcase!
    end

    # Create and assign the activation token and digest
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
