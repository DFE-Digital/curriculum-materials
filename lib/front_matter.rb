require 'yaml'
require 'hashdiff'

# FrontMatter parser
#
# @example
#
#   fm = FrontMatter.read('./content/_index.md')
#   fm.data
#   # => { title: "Greetings" }
#   fm.content
#   # => "Hello world"
#
#   fm.data.title = "Greeting!"
#   fm.write
#
class FrontMatter
  YAML_FRONT_MATTER_REGEXP = /\A(---\s*\n.*?\n?)^((?:---|\.\.\.)\s*$\n?)/m.freeze
  attr_accessor :filename, :front_matter, :content, :front_matter_original, :content_original

  # @param filename [String] file path to read
  def initialize(filename)
    @filename = Pathname.new(filename)
  end

  def self.read(filename)
    fm = self.new(filename)
    fm.read
    fm
  end

  # Reads the front matter content using marshal to load the content.
  #
  # @return [String] the markdown content
  def read
    content = File.read(filename)
    if content =~ YAML_FRONT_MATTER_REGEXP
      data = YAML.safe_load($1)
      content = (Regexp.last_match.post_match || '')
    else
      data = {}
      content = ''
    end
    @front_matter = data
    # begin
    @front_matter_original = Marshal.load(Marshal.dump(data))
    # rescue
      # puts data
    # end
    @content_original = content.dup
    @content = content
    content
  end

  # Writes the front matter content to the file in a recognizable format.
  # only writes the file if theres a change in content or data.
  def write
    diff = Hashdiff.diff(@front_matter_original, @front_matter)
    if !diff.size.zero? || (@content_original || @content)
      data = YAML.dump(@front_matter.to_h)
      data.gsub!(%r{\.\d{9} \+\d{2}:\d{2}}, ' +0000')
      data = "#{data}\n---\n#{@content}"
      File.write(@filename, data)
    end
  end
end
