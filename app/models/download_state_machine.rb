class DownloadStateMachine
  include Statesman::Machine

  state :pending, initial: true
  state :completed
  #state :failed TODO handle failure case

  transition from: :pending, to: %i(completed)

  guard_transition from: :pending, to: :completed do |download|
    download.lesson_bundle.attached?
  end
end
