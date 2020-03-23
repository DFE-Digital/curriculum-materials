class DownloadTransition < ApplicationRecord
  belongs_to :download, inverse_of: :download_transitions

  after_destroy :update_most_recent, if: :most_recent?

  scope :completed, -> { where most_recent: true, to_state: 'completed' }

private

  def update_most_recent
    last_transition = download.download_transitions.order(:sort_key).last
    return if last_transition.blank?

    last_transition.update_column(:most_recent, true)
  end
end
