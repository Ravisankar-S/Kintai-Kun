class WorkLog < ApplicationRecord
  belongs_to :user

  validates :clocked_in_at, presence: true

  validates :memo,
            length: { maximum: 140 },
            allow_blank: true

  validate :clock_out_after_clock_in

  scope :completed, -> {
    where.not(clocked_out_at: nil)
  }

  scope :active, -> {
    where(clocked_out_at: nil)
  }

  def active?
    clocked_out_at.nil?
  end

  def completed?
    clocked_out_at.present?
  end

  def duration_in_hours
    return nil unless duration_minutes

    duration_minutes / 60.0
  end

  private

  def clock_out_after_clock_in
    return if clocked_out_at.blank?

    if clocked_out_at < clocked_in_at
      errors.add(
        :clocked_out_at,
        "must be after clock in time"
      )
    end
  end
end