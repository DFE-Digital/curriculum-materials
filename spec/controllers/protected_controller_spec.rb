require "rails_helper"

RSpec.describe ProtectedController, type: :controller do
  let!(:teacher) { create(:teacher) }

  describe '#show' do
    context 'when the teacher has a valid token' do
      specify 'should be able to access the resource' do
        expect(get(:show, session: { token: teacher.token }).status).to be(200)
      end
    end

    context 'when the teacher has no valid token' do
      let(:invalid_token) { 'aaaaaaaa-bbbb-cccc-1111-222222222222' }

      specify 'should be denied to the resource' do
        expect(get(:show, session: { token: invalid_token }).status).to be(401)
      end
    end
  end
end
