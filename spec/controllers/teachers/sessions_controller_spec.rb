require "rails_helper"

RSpec.describe Teachers::SessionsController, type: :controller do
  let(:teacher) { create(:teacher) }
  describe '#create' do
    context 'when the token is valid' do
      subject { get(:create, params: { token: teacher.token }) }

      specify 'the teacher should be redirected to the landing page' do
        expect(subject).to redirect_to(root_path)
      end

      specify 'the token should be saved to the session' do
        expect(subject.request.session['token']).to eql(teacher.token)
      end
    end

    context 'when the token is invalid' do
      let(:invalid_token) { 'aaaaaaaa-bbbb-cccc-1111-222222222222' }
      subject { get(:create, params: { token: invalid_token }) }

      specify 'the request should fail' do
        expect(subject.status).to be(400)
      end

      specify 'no token should be saved to the session' do
        expect(subject.request.session['token']).to be_blank
      end
    end
  end

  describe '#destroy' do
    subject { get(:create, params: { token: teacher.token }) }

    specify 'should clear the session completely' do
      expect(subject.request.session).not_to be_blank

      delete(:destroy)

      expect(subject.request.session).to be_blank
    end
  end
end
