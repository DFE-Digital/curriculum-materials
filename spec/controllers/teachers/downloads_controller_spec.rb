require 'rails_helper'

describe Teachers::DownloadsController, type: :request do
  include_context 'logged in teacher'

  let :lesson do
    create :lesson
  end

  context '#create' do
    before do
      allow(DownloadJob).to receive(:perform_later)
    end

    context 'success' do
      before do
        post teachers_lesson_downloads_path(lesson)
      end

      it 'creates a new download' do
        expect(teacher.reload.downloads.count).to eq 1
      end

      it 'enqueues the download job' do
        expect(DownloadJob).to \
          have_received(:perform_later).with(teacher.reload.downloads.last)
      end

      it 'redirects to the download' do
        expect(response).to redirect_to \
          teachers_download_path(teacher.reload.downloads.last)
      end
    end
  end

  context '#show' do
    subject { get teachers_download_path(download) }

    context 'when download is pending' do
      let(:download) { create :download, teacher: teacher }
      it { is_expected.to render_template :pending }

      it "include the polling tag" do
        subject
        expect(response.body).to \
          include '<meta content="5" http-equiv="refresh" />'
      end
    end

    context 'when download has completed' do
      let(:download) { create :download, :completed, teacher: teacher }
      it { is_expected.to render_template :completed }
    end

    context 'when download has failed' do
      let(:download) { create :download, :failed, teacher: teacher }
      it { is_expected.to render_template :failed }
    end
  end
end
