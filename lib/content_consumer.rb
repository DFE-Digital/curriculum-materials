require_relative "./front_matter.rb"

class ContentConsumer
  def self.seed(dir = 'content/')
    s = self.new
    Rails.logger.debug "[#{self.class.name}] Reading from #{File.expand_path(dir)}"
    s.programmes(dir)
  end

  def glob_dir(glob)
    Dir.glob(glob) do |filename|
      fm = FrontMatter.read(filename)
      updated_at = File.stat(filename).ctime
      created_at = updated_at.dup
      created_at = Time.parse(fm.front_matter['date']) if fm.front_matter['date']
      slug = ActiveSupport::Inflector.parameterize(File.dirname(filename).split('/').last)

      yield fm, slug, created_at, updated_at
    end
  end

  def programmes(dir)
    glob_dir(File.join(dir, '/*/_index.md')) do |fm, slug, created_at, updated_at|
      ccp = CompleteCurriculumProgramme.create_with(
        slug: slug,
        name: fm.front_matter['title'],
        overview: fm.front_matter['description'],
        created_at: created_at,
        updated_at: updated_at,
        benefits: fm.content
      )
      .find_or_create_by!(
        slug: slug
      )
      units(fm.filename, ccp)
    end
  end

  def units(parent_filename, ccp)
    glob_dir(File.join(File.dirname(parent_filename), '/*/_index.md')) do |fm, slug, created_at, updated_at|
      unit = Unit.create_with(
        complete_curriculum_programme: ccp,
        slug: slug,
        name: fm.front_matter['title'],
        overview: fm.front_matter['description'],
        created_at: created_at,
        updated_at: updated_at,
        benefits: fm.content
      )
      .find_or_create_by!(
        complete_curriculum_programme_id: ccp.id,
        slug: slug
      )
      lessons(fm.filename, unit)
    end
  end

  def lessons(parent_filename, unit)
    glob_dir(File.join(File.dirname(parent_filename), '/*/_index.md')) do |fm, slug, created_at, updated_at|
      lesson = Lesson.create_with(
        unit: unit,
        slug: slug,
        name: fm.front_matter['title'],
        summary: fm.front_matter['description'],
        created_at: created_at,
        updated_at: updated_at
      )
      .find_or_create_by!(
        unit_id: unit.id,
        slug: slug
      )
      activities(fm.filename, lesson)
    end
  end

  def activities(parent_filename, lesson)
    glob_dir(File.join(File.dirname(parent_filename), '/*.md')) do |fm, slug, created_at, updated_at|
      next if fm.filename.end_with? "_index.md"
      activity = Activity.create_with(
        lesson: lesson,
        slug: slug,
        name: fm.front_matter['title'],
        summary: fm.front_matter['description'],
        created_at: created_at,
        updated_at: updated_at
      )
      .find_or_create_by!(
        lesson_id: lesson.id,
        slug: slug
      )
      resources(activity, fm.front_matter.fetch('resources',[]))
    end
  end

  def resources(activity, arr = [])
    arr.each do |resource|
      Resource.create_with(
        activity: activity,
        name: resource['name'],
        taxonomies: resource['taxonomies'],
        uri: resource['uri']
      ).find_or_create_by!(
        activity_id: activity.id,
        sha256: resource['sha256']
      )
    end
  end
end
