class ActivityTeachingMethod < ApplicationRecord
  belongs_to :activity
  belongs_to :teaching_method

  validates :activity_id, presence: true
  validates :teaching_method_id, presence: true
end
