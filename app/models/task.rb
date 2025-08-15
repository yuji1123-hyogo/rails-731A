class Task < ApplicationRecord
  include Searchable

  belongs_to :project
  has_one :user, through: :project

  enum :status, {
    pending: 0,
    in_progress: 1,
    completed: 2
  }

  validates :name, presence: true, length: { maximum: 255 }
  validates :status, presence: true
  validates :due_date, presence: true
  validate :due_date_cannot_be_in_the_past

  scope :active, -> { where.not(status: :completed) }
  scope :overdue, -> { where('due_date < ?', Date.current) }
  scope :due_today, -> { where(due_date: Date.current) }

  private

  def due_date_cannot_be_in_the_past
    return unless due_date.present? && due_date < Date.current

    errors.add(:due_date, '期限は今日以降の日付を設定してください')
  end
end
