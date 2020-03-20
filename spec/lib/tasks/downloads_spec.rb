require 'rails_helper'

describe 'downloads:lesson_bundles:clean_up' do
  let!(:recently_completed) { create :download, :completed }
  let!(:historic_completed) { create :download, :completed, :historic }

  before { Rails.application.load_tasks }
  before { Rake::Task['downloads:lesson_bundles:clean_up'].invoke }

  it 'purges any historic downloads' do
    expect(historic_completed.reload.lesson_bundle).not_to be_attached
  end

  it 'doesnt purge any other downloads' do
    expect(recently_completed.reload.lesson_bundle).to be_attached
  end
end
