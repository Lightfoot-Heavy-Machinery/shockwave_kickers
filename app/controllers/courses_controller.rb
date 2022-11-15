class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course, only: %i[ show edit update destroy ]


  # GET /courses or /courses.json
  def index
    @courses = Course.where(teacher: current_user.email)
  end

  # GET /courses/1 or /courses/1.json
  def show
    #get the course id's for every past and present section of this course
    @all_course_ids = Array[]
    Course.where(course_name: Course.where(id: params[:id])[0].course_name).each do |c|
      @all_course_ids.append(c.id)
    end
    #get all students currently and previously enrolled in this course
    @student_records = Student.where(course_id: @all_course_ids, teacher: current_user.email)
    #get all students tags for those currently and previously enrolled in this course
    @tags = Set[]
    for student in @student_records do
        @tags.add(student.tags)
    end
    #get all the current and previous semesters and sections of this course
    @semesters = Set[]
    @sections = Set[]
    for record in Course.all do
        if record.course_name == @course.course_name
            @semesters.add(record.semester)
            @sections.add(record.section)
        end
    end
    #if the user selects any dropdown menu filters
    if params[:selected_semester].nil? == false or params[:selected_section].nil? == false or params[:selected_tag].nil? == false
        #dropdown menu selections
        @selected_tag = params[:selected_tag]
        @selected_semester = params[:selected_semester]
        @selected_section = params[:selected_section]
        #get all course id's for the selected semester+section combo
        if @selected_section == ''
            @target_course_id = Course.where(course_name: Course.where(id: params[:id])[0].course_name,semester: @selected_semester)
        else
            @target_course_id = Course.where(course_name: Course.where(id: params[:id])[0].course_name,semester: @selected_semester, section: @selected_section)
            #nil check in case the selected semester doesn't have the selected section
            if @target_course_id.length > 0
                @target_course_id = @target_course_id[0].id
            end
        end
        #create the filtered list of students to display
        if @selected_semester == '' and @selected_tag == ''
            @student_records = Student.where(course_id: @all_course_ids, teacher: current_user.email)
        elsif @selected_semester != '' and @selected_tag == ''
            @student_records = Student.where(course_id: @target_course_id, teacher: current_user.email)
        elsif @selected_semester == '' and @selected_tag != ''
            @student_records = Student.where(course_id: @all_course_ids, tags: @selected_tag, teacher: current_user.email)
        else
            @student_records = Student.where(course_id: @target_course_id, tags: @selected_tag, teacher: current_user.email)
        end
    #if the user doesnt select any dropdown menu filters, display all students
    else
        #get all the current and previous semesters and sections of this course
        @semesters = Set[]
        @sections = Set[]
        for record in Course.all do
            if record.course_name == @course.course_name
                @semesters.add(record.semester)
                @sections.add(record.section)
            end
        end
    end
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
