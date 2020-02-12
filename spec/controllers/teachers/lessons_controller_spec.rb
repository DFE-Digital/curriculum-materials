require 'rails_helper'

describe Teachers::LessonsController, type: :request do
  include_context 'logged in teacher'

  context '#show' do
    let(:lesson) { l = Lesson.new; l.from_file(file_fixture("content/year-8-history/roman-history/1-the-battle-of-hastings/_index.md")); l }
    subject { get(lesson.path) }

    it { is_expected.to render_template('show') }
  end
end
