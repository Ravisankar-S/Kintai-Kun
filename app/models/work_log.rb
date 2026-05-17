class WorkLog < ApplicationRecord
  belongs_to :user

  validates :clocked_in_at, presence: true

  validates :memo,
            length: { maximum: 140 },
            allow_blank: true

  validates :duration_minutes,
          numericality: {
            greater_than_or_equal_to: 0
          },
          allow_nil: true

  validate :clock_out_after_clock_in

  scope :completed, -> {
    where.not(clocked_out_at: nil)
  }

  scope :active, -> {
    where(clocked_out_at: nil)
  }

  scope :for_date, ->(date) {
  where(
    clocked_in_at:
      date.beginning_of_day..date.end_of_day
  )
}

  scope :for_week, ->(date) {
    where(
      clocked_in_at:
        date.beginning_of_week..date.end_of_week
    )
  }

  scope :for_month, ->(year, month) {
    start_date = Date.new(year, month, 1)

    where(
      clocked_in_at:
        start_date.beginning_of_day..
        start_date.end_of_month.end_of_day
    )
  }

  scope :overtime, -> {
    where(is_overtime: true)
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

  def clocked_out?
    clocked_out_at.present?
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