require 'rails_helper'

describe LessonsController, type: :controller do
  context '#show' do
    let(:lesson) { FactoryBot.create(:lesson) }
    subject { get :show, params: { id: lesson.id } }

    it { is_expected.to render_template :show }
  end
end
