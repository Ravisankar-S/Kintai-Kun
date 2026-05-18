class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :work_logs, dependent: :destroy

  validates :name, presence: true
  validates :role, inclusion: { in: %w[employee admin] }
  validates :work_mode, inclusion: { in: %w[fixed flex] }
  validates :preferred_locale, inclusion: { in: %w[en ja] }
end
