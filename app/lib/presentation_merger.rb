require "open3"

class PresentationMerger
  class ProcessExitError < StandardError; end
  attr_reader :files

  def initialize(file_name, stream = false)
    @file_name = file_name
    @output_stream = if stream
                       iostream = @file_name.dup
                       iostream.reopen @file_name
                       iostream.rewind
                       iostream
                     else
                       ::File.new @file_name, "wb"
                     end
    @files = []
    @closed = false
  end

  class << self
    # Public: Performs the merge on the given File
    #
    # Examples
    #
    #   PresentationMerger.open("./merged.odp") do |pres|
    #     pres << File.new("pres1.odp")
    #   end
    #
    #   pres = PresentationMerger.open("./merged.odp")
    #   pres << File.new("pres1.odp")
    #   pres.close
    #
    # Returns PresentationMerger instance
    def open(file_name)
      return new(file_name) unless block_given?

      zos = new(file_name, false)
      yield zos
    ensure
      zos.close if zos
    end

    # Public: Performs the merge on the given IO stream
    #
    # Examples
    #
    #   io = PresentationMerger.write_buffer do |pres|
    #     pres << File.new("pres1.odp")
    #   end
    #
    # Returns StringIO buffer
    def write_buffer(io = ::StringIO.new(""))
      zos = new(io, true)
      yield zos
      zos.close_buffer
    end
  end

  # Public: Appends a file to merge into the resulting document
  #
  # file - The File to merge into the final document
  #
  # Returns nothing.
  def <<(file)
    @files << file
  end

  # Public: Runs methods before closing file
  #
  # Returns File
  def close
    return if @closed

    run_command
    @output_stream.close
    @closed = true
    @file_name
  end

  # Public: Runs the methods before marking as closed
  #
  # Returns StringIO
  def close_buffer
    return @output_stream if @closed

    run_command
    @closed = true
    @output_stream
  end

private

  def run_command
    file_paths = files.map(&:path).join(" ")
    command = "./node_modules/.bin/presentation-merger #{file_paths}"

    stderr_str = ''
    exit_status = Open3.popen3(command) do |_stdin, stdout, stderr, wait_thr|
      while (line = stdout.gets)
        @output_stream.puts line
      end
      stderr_str = stderr.read
      @output_stream.close_write
      wait_thr.value
    end
    unless exit_status.success?
      raise ProcessExitError, "Command: `#{command}`\nMessage: #{stderr_str}"
    end

    @output_stream
  end
end
