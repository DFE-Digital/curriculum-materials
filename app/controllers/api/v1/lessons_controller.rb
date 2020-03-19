class Api::V1::LessonsController < Api::BaseController
  def index
    lessons = Lesson
      .eager_load(:unit)
      .where(unit_id: params[:unit_id])
      .all

    render(json: serialize(lessons))
  end

  def show
    lesson = Lesson
      .eager_load(:unit)
      .where(unit_id: params[:unit_id])
      .find(params[:id])

    render(json: serialize(lesson))
  end

  def create
    unit = Unit.find_by!(complete_curriculum_programme_id: params[:ccp_id], id: params[:unit_id])
    lesson = unit.lessons.new(lesson_params)

    if lesson.save
      render(json: serialize(lesson), status: :created)
    else
      render(json: { errors: lesson.errors.full_messages }, status: :bad_request)
    end
  end

  def update
    lesson = Lesson.find_by!(unit_id: params[:unit_id], id: params[:id])

    if lesson.update(lesson_params)
      render(json: serialize(lesson), status: :ok)
    else
      render(json: { errors: lesson.errors.full_messages }, status: :bad_request)
    end
  end

private

  def lesson_params
    params.require(:lesson).permit(
      :name,
      :learning_objective,
      :position,
      :core_knowledge_for_pupils,
      :core_knowledge_for_teachers,
      :previous_knowledge,
      :vocabulary,
      :misconceptions
    )
  end

  def serialize(data)
    LessonSerializer.render(data)
  end
end
