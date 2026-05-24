class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable

  has_many :work_logs, dependent: :destroy
    has_one_attached :avatar

  validates :name, presence: true
  validates :role, inclusion: { in: %w[employee admin] }
  validates :work_mode, inclusion: { in: %w[fixed flex] }
  validates :preferred_locale, inclusion: { in: %w[en ja] }

  validate :avatar_content_type, if: -> { avatar.attached? }
  validate :avatar_size, if: -> { avatar.attached? }

  private

  def avatar_content_type
    allowed_types = %w[
      image/jpeg
      image/png
      image/webp
      image/gif
      image/avif
    ]

    return if allowed_types.include?(avatar.blob.content_type)

    errors.add(:avatar, I18n.t("users.avatar_invalid_type"))
  end

  def avatar_size
    return if avatar.blob.byte_size <= 5.megabytes

    errors.add(:avatar, I18n.t("users.avatar_too_large"))
  end
end
