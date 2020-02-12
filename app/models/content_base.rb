require_relative '../../lib/front_matter'
class ContentBase
  class RecordNotFound < StandardError; end
  attr_accessor :title, :date, :content
  attr_reader :slug, :filename

  def self.from_file(file)
    instance = self.new
    instance.from_file(file)
    instance
  end

  def attributes=(hash)
    hash.each do |key, value|
      send("#{key}=", value) if self.respond_to?("#{key}=")
    end
  end

  def attributes
    instance_values
  end

  def from_file!(file)
    parsed = FrontMatter.read(file)
    @filename = parsed.filename

    @slug = ActiveSupport::Inflector.parameterize(
      File.dirname(parsed.filename).split('/').last
    )

    @content = parsed.content

    self.attributes = parsed.front_matter
  rescue Errno::ENOENT
    raise RecordNotFound
  end

  def from_file(file)
    from_file!(file)
  rescue RecordNotFound
  end

  def slug
    @slug ||= ActiveSupport::Inflector.parameterize(
      File.dirname(parsed.filename).split('/').last
    )
  end

  def to_param
    slug
  end

  def eql?(other)
    self.filename == other.filename if other.respond_to?(:slug)
  end

  alias == eql?
end
