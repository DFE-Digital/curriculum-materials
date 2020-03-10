require 'rails_helper'

describe Teachers::LessonsController, type: :request do
  include_context 'logged in teacher'

  context '#show' do
    let(:lesson) { FactoryBot.create(:lesson) }
    subject { get(teachers_lesson_path(lesson)) }

    it { is_expected.to render_template('show') }
  end
end


describe Teachers::LessonsController, type: :controller do
  let(:teacher) { FactoryBot.create(:teacher) }

  context "GET #print" do
    let(:lesson) { FactoryBot.create(:lesson) }
    subject { get :print, params: { id: lesson.id } }

    before :each do
      controller.session[:token] = teacher.token
    end

    it "renders with 'print' layout" do
      expect(subject).to render_template("layouts/print")
    end
  end
end
