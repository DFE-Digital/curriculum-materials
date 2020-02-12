class Teacher < ApplicationRecord
  validates :token,
            presence: true,
            uniqueness: { case_sensitive: false }
  has_many :activity_choices
end
