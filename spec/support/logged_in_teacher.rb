shared_context 'logged in teacher' do
  let!(:teacher) { create(:teacher) }

  before(type: :feature) do
    visit(teachers_create_session_path(teacher.token))
  end

  before(type: :request) do
    get(teachers_create_session_path(teacher.token))
  end
end
