shared_examples 'a Resource' do
  context 'Relationships' do
    it { is_expected.to belong_to :activity }
  end

  context 'validations' do
    it { is_expected.to validate_inclusion_of(:type).in_array [resource.model_name.name] }

    context 'attachments' do
      it { is_expected.to validate_size_of(:file).less_than(max_upload_size) }
      it { is_expected.to validate_content_type_of(:file).allowing(allowed_file_content_types) }
      it { is_expected.to validate_size_of(:preview).less_than(max_upload_size) }
      it { is_expected.to validate_content_type_of(:preview).allowing(allowed_preview_content_types) }
    end
  end

  context 'attachments' do
    let :attachment_path do
      File.join(Rails.application.root, 'spec', 'fixtures', 'slide_1_keyword_match_up.pdf')
    end

    let :slide_deck_path do
      File.join(Rails.application.root, 'spec', 'fixtures', 'slide_1_keyword_match_up.odp')
    end

    context '#preview' do
      before do
        resource.preview.attach \
          io: File.open(attachment_path),
          filename: 'slide_1_keyword_match_up.pdf',
          content_type: 'application/pdf'
      end

      subject { resource.preview }

      it { is_expected.to be_persisted }

      it "is attached correctly" do
        expect(subject.filename).to eq 'slide_1_keyword_match_up.pdf'
        expect(subject.content_type).to eq 'application/pdf'
        expect(subject.download).to eq File.binread(attachment_path)
      end
    end

    context '#file' do
      before do
        resource.file.attach \
          io: File.open(slide_deck_path),
          filename: 'slide-deck.odp',
          content_type: 'application/vnd.oasis.opendocument.presentation'
      end

      subject { resource.file }

      it "is attached correctly" do
        expect(subject.filename).to eq 'slide-deck.odp'
        expect(subject.content_type).to eq 'application/vnd.oasis.opendocument.presentation'
        expect(subject.download).to eq File.binread(slide_deck_path)
      end
    end
  end
end
