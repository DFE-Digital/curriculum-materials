class PupilResource < Resource
  ALLOWED_CONTENT_TYPES = %w(
    application/pdf
    application/vnd.oasis.opendocument.text
    application/vnd.oasis.opendocument.presentation
    image/gif
    image/jpeg
    image/jpg
    image/png
  ).freeze

  MAX_UPLOAD_SIZE = 50.megabytes

  validates :type, inclusion: %w(PupilResource).freeze

  validates :file,
            content_type: ALLOWED_CONTENT_TYPES,
            size: { less_than: MAX_UPLOAD_SIZE }

  validates :preview,
            content_type: 'image/png',
            size: { less_than: MAX_UPLOAD_SIZE }
end
