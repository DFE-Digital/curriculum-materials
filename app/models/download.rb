class Download < ApplicationRecord
  LESSON_BUNDLE_TTL = 24.hours

  belongs_to :teacher
  belongs_to :lesson
  has_one_attached :lesson_bundle

  validates :teacher, presence: true
  validates :lesson, presence: true
  validates :lesson_bundle, content_type: 'application/zip'

  has_many :download_transitions, autosave: false, dependent: :destroy

  include Statesman::Adapters::ActiveRecordQueries[
    transition_class: DownloadTransition,
    initial_state: :pending
  ]

  delegate :transition_to!, :current_state, :in_state?, to: :state_machine

  scope :historic, -> { where 'downloads.created_at < ?', LESSON_BUNDLE_TTL.ago }

  scope :completed, -> { joins(:download_transitions).merge DownloadTransition.completed }

  scope :to_clean_up, -> { historic.completed }

  def state_machine
    @state_machine ||= DownloadStateMachine.new(self, transition_class: DownloadTransition)
  end

  def lesson_parts
    lesson.lesson_parts_for(teacher)
  end
end
