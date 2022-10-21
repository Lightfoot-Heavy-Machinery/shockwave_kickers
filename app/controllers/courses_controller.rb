class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course, only: %i[ show edit update destroy ]

  # GET /courses or /courses.json
  def index
    @courses = Course.where(teacher: current_user.email)
  end

  # GET /courses/1 or /courses/1.json
  def show
    @student_records = Student.where(course_id: params[:id])
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to course_url(@course), notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to course_url(@course), notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    @student_records = Student.where(course_id: params[:id])
    @student_records.destroy_all
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find_by(teacher: current_user.email, id: params[:id])
        if !@course.nil?
            Rails.logger.info "Received info #{@student_records.inspect}"
            Rails.logger.info "Received info #{params.inspect}"
            Rails.logger.info "Received info #{current_user.inspect}"
        else
            respond_to do |format|
                format.html { redirect_to courses_url, notice: "Given course not found." }
                format.json { head :no_content }
            end
        end
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:course_name, :section, :semester).with_defaults(teacher: current_user.email)
    end
end
