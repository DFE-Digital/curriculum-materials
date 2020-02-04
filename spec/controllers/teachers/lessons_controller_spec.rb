require 'rails_helper'

describe Teachers::LessonsController, type: :request do
  include_context 'logged in teacher'

  context '#show' do
    let(:lesson) { FactoryBot.create(:lesson) }
    subject { get(teachers_lesson_path(lesson)) }

    it { is_expected.to render_template('show') }
  end
end
