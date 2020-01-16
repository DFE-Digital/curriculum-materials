class Teacher < ApplicationRecord
  validates :token,
            presence: true,
            uniqueness: { case_sensitive: false }
end
