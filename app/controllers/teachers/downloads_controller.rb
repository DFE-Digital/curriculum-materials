module Teachers
  class DownloadsController < BaseController
    def show
      @download = current_teacher.downloads.find params[:id]
      case @download.current_state
      when 'pending'   then render :pending
      when 'completed' then render :completed
      when 'failed'    then render :failed
      else fail "unknown download state for #{@download.inspect}"
      end
    end

    def create
      lesson = Lesson.find params[:lesson_id]
      download = current_teacher.downloads.create! lesson: lesson
      DownloadJob.perform_later download
      redirect_to teachers_download_path(download)
    end
  end
end
