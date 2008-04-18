# == Schema Information
# Schema version: 9
#
# Table name: users
#
#  id               :integer(11)     not null, primary key
#  identity_url     :string(255)     
#  admin            :boolean(1)      
#  avatar_id        :integer(11)     
#  avatar_path      :string(255)     
#  token            :string(255)     
#  login            :string(255)     
#  crypted_password :string(255)     
#  public_key       :text            
#

require 'digest/md5'
class User < ActiveRecord::Base
  attr_accessor :avatar_data
  attr_accessor :password
  attr_accessible :identity_url, :avatar_data, :login, :password, :password_confirmation
  
  validates_confirmation_of :password, :allow_nil => true
  validates_uniqueness_of :identity_url, :allow_nil => true
  validates_uniqueness_of :login, :if => lambda { |u| !u.login.blank? }
  validate :presence_of_identity_url_or_email
  
  before_create :set_default_attributes
  before_save :save_avatar_data
  before_save :encrypt_password!

  belongs_to :avatar
  has_one :profile

  def self.find_all_by_logins(logins)
    find :all, :conditions => ['login IN (?)', logins]
  end

  def self.authenticate(login, password)
    user = find_by_login(login)
    user && user.password_matches?(password) ? user : nil
  end

  def name
    (login.blank? ? nil : login) || profile.sanitized_email || identity_path
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
    end if password
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
    self.class.encrypt_password self, password if password
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

    def presence_of_identity_url_or_email
      if identity_url.blank? && (login.blank?)
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
