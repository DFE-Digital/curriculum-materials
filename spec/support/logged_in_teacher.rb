shared_context 'logged in teacher' do
  let!(:teacher) { create(:teacher) }

  before(type: :feature) do
    visit(create_teachers_session_path(teacher.token))
  end

  before(type: :request) do
    get(create_teachers_session_path(teacher.token))
  end
end
