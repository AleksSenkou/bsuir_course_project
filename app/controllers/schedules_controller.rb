class SchedulesController < ApplicationController
  before_filter :load_schedule, only: [:show]

  def new
    @schedule = Schedule.new
  end

  def create
    @schedule = Schedule.create(schedule_params)
    if @schedule.save
      flash[:notice] = 'Your schedule'
      redirect_to @schedule
    else
      flash.now[:error] = 'Wrong input format. Enter correct group number, please'
      render action: 'new'
    end
  end

  def show

  end

  private

  def load_schedule
    @schedule = Schedule.find(params[:id])
  end

  def schedule_params
    params.require(:schedule).permit(:group_number)
  end
end

