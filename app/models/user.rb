class User < ApplicationRecord
    has_secure_password

    enum :role, { general: 0, admin: 1 }

    validates :name,     presence: true, length: { maximum: 50 }
    validates :email,    presence: true, uniqueness: true, length: { maximum: 254 }
    validates :password, presence: true, length: { minimum: 8 }, allow_nil: true
end






