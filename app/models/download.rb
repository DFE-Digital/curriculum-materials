class Download < ApplicationRecord
  belongs_to :teacher
  belongs_to :lesson
  has_one_attached :lesson_bundle

  validates :teacher, presence: true
  validates :lesson, presence: true
  validates :lesson_bundle, content_type: 'application/zip'
end
