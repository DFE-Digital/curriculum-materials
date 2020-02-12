require_relative '../../lib/front_matter'
class ContentBase
  class RecordNotFound < StandardError; end
  attr_accessor :title, :date, :content
  attr_reader :filename

  class <<self
    def all_files
      raise StandardError, "don't know what constitutes all files, define a method `all_files`"
    end

    def from_file(file)
      instance = self.new
      instance.from_file(file)
      instance
    end

    def has_many(key, options = {})
      const_set(:CHILD_PATTERN, options.fetch(:pattern, "*/_index.md"))
      const_set(:CHILD_CLASS, key.to_s.singularize.classify.constantize)
      define_method(key, instance_method(:children))
    end

    def belongs_to(key, options = {})
      const_set(:PARENT_PATTERN, options.fetch(:pattern, "../_index.md"))
      const_set(:PARENT_CLASS, key.to_s.singularize.classify.constantize)
      define_method(key, instance_method(:parent))
    end

    def all
      all_files.collect do |file|
        from_file(file)
      end
    end

    def first
      from_file(all_files.first)
    end
  end

  def parent
    return unless @filename

    file = File.join(@filename.parent, self.class::PARENT_PATTERN)
    self.class::PARENT_CLASS.from_file(file)
  end

  def children
    return unless @filename

    files = Dir.glob(File.join(File.dirname(@filename), self.class::CHILD_PATTERN))
    files.collect do |file|
      self.class::CHILD_CLASS.from_file(file)
    end
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
    @content = parsed.content

    self.attributes = parsed.front_matter
  rescue Errno::ENOENT, Errno::EISDIR
    raise RecordNotFound
  end

  def from_file(file)
    from_file!(file)
  rescue RecordNotFound
  end

  def slug
    file_parts = @filename.to_s.split('/').reject do |part|
      part == "_index.md"
    end

    ActiveSupport::Inflector.parameterize(
      file_parts.last.gsub(".md", "")
    )
  end

  def to_param
    slug
  end

  def eql?(other)
    self.filename == other.filename
  end

  alias == eql?
end
