class DownloadStateMachine
  include Statesman::Machine

  state :pending, initial: true
  state :completed
  state :failed
  state :cleaned_up

  transition from: :pending, to: %i(completed failed)
  transition from: :completed, to: :cleaned_up

  guard_transition from: :pending, to: :completed do |download|
    download.lesson_bundle.attached?
  end

  guard_transition from: :completed, to: :cleaned_up do |download|
    !download.lesson_bundle.attached?
  end
end
