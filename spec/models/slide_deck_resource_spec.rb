require 'rails_helper'
require_relative 'resource_shared_examples'

describe SlideDeckResource, type: :model do
  let(:resource) { create :slide_deck_resource }
  let(:max_upload_size) { 50.megabytes }
  let(:allowed_file_content_types) do
    %w(application/vnd.oasis.opendocument.presentation)
  end
  let(:allowed_preview_content_types) do
    %w(application/pdf)
  end

  it_behaves_like 'a Resource'
end
