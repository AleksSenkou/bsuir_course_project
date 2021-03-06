class SchedulesController < ApplicationController
  before_filter :load_schedule, only: [:show]
  before_filter :load_lesson, only: [:show_teacher_and_subject_info]

  def new
    @schedule = Schedule.new
  end

  def find_or_create
    group_number = schedule_param[:group_number]
    @schedule = Schedule.where(group_number: group_number)

    if @schedule.empty?
      create_schedule
    else
      redirect_to schedule_url(@schedule.first.id)
    end
  end

  def show
    @schedule.parse_info
    @lessons = @schedule.lessons
  end

  def show_teacher_and_subject_info
    @comments = Comment.where(lesson_id: @lesson.id)
    @lesson.parse_info_about_teacher if @comments.empty?
    @teacher = @lesson.teacher
  end

  private

  def create_schedule
    @schedule = Schedule.create(schedule_param)

    if @schedule.group_present? && @schedule.save
      redirect_to @schedule
    else
      flash.now[:error] = 'Wrong input format. Enter correct group number, please'
      render action: 'new'
    end
  end

  def load_schedule
    @schedule = Schedule.find(params[:id])
  end

  def load_lesson
    @lesson = Lesson.find(params[:id])
  end

  def schedule_param
    params.require(:schedule).permit(:group_number)
  end
end
