require 'digest/md5'
class User < ActiveRecord::Base
  attr_accessor :avatar_data
    
  attr_accessor :password
  validates_format_of       :email, :with => /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/i, :allow_nil => true
  validates_confirmation_of :password, :allow_nil => true
  validates_uniqueness_of :identity_url, :allow_nil => true
  [:email, :login].each do |attr|
    validates_uniqueness_of attr, :if => lambda { |u| !u.send(attr).blank? }
  end
  validate :presence_of_identity_url_or_email
  before_create :set_default_attributes
  before_save   :sanitize_email
  attr_accessible :identity_url, :avatar_data, :email, :login, :password, :password_confirmation
  belongs_to :avatar
  before_save :save_avatar_data

  def self.find_all_by_logins(logins)
    find :all, :conditions => ['login IN (?)', logins]
  end

  def self.authenticate(login, password)
    user = find_by_login(login)
    user && user.password_matches?(password) ? user : nil
  end

  def name
    (login.blank? ? nil : login) || sanitized_email || identity_path
  end

  def sanitized_email
    if !email.blank? && email =~ /^([^@]+)@(.*?)(\.co)?\.\w+$/
      "#{$1} (at #{$2})"
    end
  end

  def email=(value)
    write_attribute :email, value.blank? ? value : value.downcase
  end

  def avatar?
    !avatar_id.nil?
  end

  def reset_token
    write_attribute :token, TokenGenerator.generate_random(TokenGenerator.generate_simple)
  end
  
  def reset_token!
    reset_token
    save
  end
  
  def identity_path
    identity_url.gsub(/^[^\/]+\/+/, '').chomp('/')
  end

  def identity_url=(value)
    write_attribute :identity_url, OpenIdAuthentication.normalize_url(value)
  end

  def self.encrypt_password(user, password = nil)
    password ||= user.password
    case Tentacle.authentication_scheme
      when 'plain' then user.password
      when 'md5'   then Digest::MD5::hexdigest([user.login, Tentacle.authentication_realm, password].join(":"))
      when 'basic' then password.crypt(TokenGenerator.generate_simple(2))
    end
  end
  
  def self.password_matches?(user, password)
    user.crypted_password == 
      case Tentacle.authentication_scheme
        when 'plain' then password
        when 'md5'   then user.encrypt_password(password)
        when 'basic' then password.crypt(user.crypted_password[0,2])
      end
  end
  
  def encrypt_password(password = nil)
    self.class.encrypt_password self, password
  end
  
  def encrypt_password!(password = nil)
    self.crypted_password = self.class.encrypt_password(self, password)
  end
  
  def password_matches?(password)
    self.class.password_matches? self, password
  end

  protected
    def set_default_attributes
      self.token = TokenGenerator.generate_random(TokenGenerator.generate_simple)
      self.admin = true if User.count.zero?
      true
    end

    def sanitize_email
      encrypt_password! unless password.blank?
      email.downcase!   unless email.blank?
    end
    
    def presence_of_identity_url_or_email
      if identity_url.blank? && (email.blank? || login.blank?)
        errors.add_to_base "Requires at least an email and login"
      end
    end

    def save_avatar_data
      return if @avatar_data.nil? || @avatar_data.size.zero?
      build_avatar if avatar.nil?
      avatar.uploaded_data = @avatar_data
      avatar.save!
      self.avatar_id   = avatar.id
      self.avatar_path = avatar.public_filename
    end
end
