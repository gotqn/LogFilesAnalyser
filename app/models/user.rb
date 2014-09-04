class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable


  # Relationships
  has_many :log_files

  # Validations
  validates :username, presence: true, length: { in: 4..39 }, uniqueness: {case_sensitive: false}
  validates :username, format: { with: /\A[a-zA-Z0-9]+[a-zA-Z\-0-9]*\z/, message: 'Username may only contain alphanumeric characters or dashes and cannot begin with a dash' }

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  # Overriding the find_for_database_authentication method allows us to edit database authentication
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(['lower(username) = :value OR lower(email) = :value', { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.username = auth.info.nickname
      user.email = auth.info.email
    end
  end

  def self.new_with_session(params, session)
    if session['devise.user_attributes']
      new(session['devise.user_attributes'], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end
end
