class Appointment < ApplicationRecord
  belongs_to :professional

  validates :name, :surname, :phone, presence: true
  validates :date, uniqueness: {scope: :professional_id}
  validate :date_greater_than_today, :date_is_sunday?, :valid_date_for_appointment?
  scope :search_by_date, -> (dateS) {where("DATE(date) = ?", dateS)}
  before_destroy :is_an_old_appointment?, prepend: true
  
  def get_only_hour
    date.strftime("%H:%M")
  end

  protected #para que solo se puedan utilizar aca los metodos

  def is_an_old_appointment?
    if self.date < DateTime.now
      errors.add :base, 'An old appointment cannot be cancelled'
    throw :abort
    end
  end

  def date_greater_than_today
    if self.date < DateTime.now
      errors.add :date, 'The date must be greater than today'
    end
  end

  def date_is_sunday?
    if self.date.sunday?
      errors.add :date, 'The date cannot be sunday'
    end
  end

  def valid_date_for_appointment?
    if !(self.date.min == 0 || self.date.min == 30)
      errors.add :date, 'Shift times are every half hour'
    end
  end
end
