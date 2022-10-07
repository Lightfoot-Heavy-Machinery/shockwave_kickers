class SemestersController < ApplicationController

  def index
      @semesters = Semester.all
  end

  def show
      @semester = Semester.find(params[:id])
  end

  def new
      @semesters = Semester.all
      @semester = Semester.new
  end

  def edit
      @semester = Semester.find(params[:id])
  end

  def create
      semester = Semester.new(params.require(:student).permit(:name, :courses))
      if semester.save
          redirect_to new_semester_path
      end
  end

  def update
    @semester = Semester.find(params[:id])
    respond_to do |format|
      if @semester.update(params.require(:semester).permit(:name, :courses))
        format.html { redirect_to semester_url(@semester), notice: "Semester information was successfully updated." }
        format.json { render :show, status: :ok, location: @semester }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @semester.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
      @semester = Semester.find(params[:id])
      @semester.destroy
      redirect_to action: "index"
  end
end
