require 'rails_helper'

describe 'teachers/lessons/show' do
  let(:teacher) { create :teacher }
  let(:presenter) { Teachers::LessonContentsPresenter.new lesson, teacher }

  before do
    controller.request.path_parameters[:id] = lesson.id # For path helpers
    assign :lesson, lesson
    assign :presenter, presenter
  end

  subject { render }

  context 'show_download_link' do
    let(:lesson) { create(:activity, :with_pupil_resources).lesson_part.lesson }

    it { is_expected.to have_button 'Download lesson resources' }
    it { is_expected.to have_link 'Print lesson plan' }
  end

  context "don't show_download_link" do
    let(:lesson) { create :lesson }

    it { is_expected.not_to have_button 'Download lesson resources' }
    it { is_expected.to include 'There are no resources to download for this lesson' }
    it { is_expected.to have_link 'Print lesson plan', class: 'govuk-button' }
  end
end
