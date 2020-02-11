require 'rails_helper'
require_relative '../../lib/content_consumer'

RSpec.describe ContentConsumer do
  describe 'seed' do
    it 'creates content from the content folder' do
      expect {
        described_class.seed(file_fixture('./content'))
      }.to change(CompleteCurriculumProgramme, :count).from(0).to(1)
        .and change(Unit, :count).from(0).to(1)
        .and change(Lesson, :count).from(0).to(2)
        .and change(Activity, :count).from(0).to(1)
        .and change(Resource, :count).from(0).to(1)
    end

    it 'updates' do
    end
  end
end
