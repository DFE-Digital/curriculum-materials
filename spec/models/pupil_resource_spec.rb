require 'rails_helper'
require_relative 'resource_shared_examples'

describe PupilResource, type: :model do
  let(:resource) { create :pupil_resource }
  let(:max_upload_size) { 50.megabytes }
  let(:allowed_content_types) do
    %w(
      application/pdf
      application/vnd.oasis.opendocument.text
      image/gif
      image/jpeg
      image/jpg
      image/png
    )
  end

  it_behaves_like 'a Resource'
end
