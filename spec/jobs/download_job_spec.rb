require 'rails_helper'

RSpec.describe DownloadJob, type: :job do
  let(:download) { create(:download) }

  describe '#perform_later' do
    before { ActiveJob::Base.queue_adapter = :test }

    it "enqueues jobs" do
      expect { DownloadJob.perform_later(download) }.to have_enqueued_job
    end
  end

  describe '#perform' do
    subject! { DownloadJob.perform_now(download) }

    before { allow(download.lesson_bundle).to receive(:attach).and_return(1) }

    # awaiting factories with attachments before testing the
    # actual attachment process
    xit "attaches the lesson bundle" do
      expect(download.lesson_bundle).to have_received(:attach).with(:something)
    end

    it "progresses the state to :completed" do
      expect(download.reload.state_machine).to be_in_state(:completed)
    end
  end
end
