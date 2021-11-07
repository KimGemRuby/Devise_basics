class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  attr_accessor :login

    validates :username, presence: true, uniqueness: {case_sensitive: false}

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :validatable
  devise :omniauthable, omniauth_providers: [:facebook]

         def self.find__first_by_auth_conditions(warden_conditions)
          conditions = warden_conditions.dup
          if login = conditions.delete(:login)
            where(conditions.to_hash).where("lower(username) = :value OR lower(email) = :value", value: login.downcase).first
          else
            where(conditions.to_hash).first
          end
         end

         def self.from_facebook(auth)
          where(facebook_id: auth.uid).first_or_create do |user|
            user.email = auth.info.email
            user.usename = auth.info.name
            user.password = Devise.friendly_token[0, 20]
            user.skip_confirmation!
          end
         end
end
