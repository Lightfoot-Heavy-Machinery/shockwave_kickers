class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course, only: %i[ show edit update destroy ]

  # GET /courses or /courses.json
  def index
    @courses_db_result = Course.search(params[:search], current_user.email)
    #@courses_db_result = Course.where(teacher: current_user.email)
    @courses_comb_hash = Hash[]
    @courses_db_result.each do |c|
        if !@courses_comb_hash[c.course_name]
            courseAllSections = CourseEntries.new
            courseAllSections.initializeUsingCourseModel(c)
            @courses_comb_hash[c.course_name] = courseAllSections 
        else
            course = @courses_comb_hash[c.course_name]
            course.sections.add(c.section)
            course.semesters.add(c.semester)
            course.records.add(c)
        end
    end
    @courses = @courses_comb_hash.values
    Rails.logger.info "Received info #{@courses.inspect}"
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
    end unless @student_records.nil?
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
        if @selected_section == '' and @selected_semester == ''
            @target_course_id = Course.where(id: @all_course_ids)
        elsif @selected_section != '' and @selected_semester == ''
            @target_course_id = Course.where(id: @all_course_ids,section: @selected_section)
        elsif @selected_section == '' and @selected_semester != ''
            @target_course_id = Course.where(id: @all_course_ids,semester: @selected_semester)
        else
            @target_course_id = Course.where(id: @all_course_ids,semester: @selected_semester, section: @selected_section)
        end
        #create the filtered list of students to display
        if @selected_tag == ''
            @student_records = Student.where(course_id: @target_course_id, teacher: current_user.email)
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

    @student_records_hash = Hash[]
    for student in @student_records do
        course = Course.where(id: student.course_id)
        if !@student_records_hash[student.uin]
            student_entry = StudentEntries.new
            student_entry.initializeUsingStudentModel(student, course[0])
            @student_records_hash[student.uin] = student_entry
        else
            student_entry = @student_records_hash[student.uin]
            student_entry.records.append(student)
            student_entry.semester_section.add(course[0].semester + " - " + course[0].section.to_s)
            student_entry.course_semester.add(course[0].course_name + " - " + course[0].semester)
        end
    end unless @student_records.nil?
    @student_records = @student_records_hash.values
    Rails.logger.info "Collected info for filter #{@student_records.inspect}"
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
    @quiz_records = Quiz.where(course_id: params[:id])
    @qroster_records = Qroster.where(quiz_id: @quiz_records.pluck(:id))
    @qroster_records.destroy_all
    @quiz_records.destroy_all
    @course.delete

    respond_to do |format|
      format.html { redirect_to courses_url, notice: "Course and its info were successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find_by(teacher: current_user.email, id: params[:id])
        if @course.nil?
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
