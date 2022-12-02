class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course, only: %i[ show edit update destroy ]

  def getStats  
    if @target_course_id.is_a?(ActiveRecord::Base)
      qID = Quiz.where(teacher:current_user.email, course_id: @target_course_id.pluck(:id)).pluck(:id)
    elsif @target_course_id.is_a?(Array)
      qID = Quiz.where(teacher:current_user.email, course_id: @target_course_id).pluck(:id)
    else
      qID = Quiz.where(teacher:current_user.email, course_id: @all_course_ids).pluck(:id)
    end
    atm = Qroster.where(quiz_id:qID,correct_resp:true).count(:attempts)
    
    if qID.length == 0 || atm == 0
      avg = "No quizzes taken!"
      bestInfo = "No quizzes taken!"
      worstInfo = "No quizzes taken!"
    else
      avg = 0
      cnt = 0

      worst = Qroster.where(quiz_id:qID,correct_resp:true).group(:student_id).select(:student_id, "(SUM(CAST(1 AS Float) / CAST(attempts as Float)*100.00) / #{atm}) AS wscore", "(SUM(CAST(1 AS Float) / CAST(attempts as Float)*100.00)/COUNT(attempts)) AS score").order("wscore ASC")
      currS = -1
      worstEntry = nil
      worst.each do |qr|
        avg = avg + qr.score
        cnt = cnt + 1

        if currS == -1
          currS = qr.score
          worstEntry = qr
        elsif qr.score <= currS
          currS = qr.score
          worstEntry = qr
        end
      end
      wStud = ""
      worstInfo = ""

      unquizzed = Set.new
      @student_ids.each do |v|
        if worst.where(student_id: v).first.nil?
          unquizzed.add(v)
        end
      end
      if unquizzed.length > 1
        worstInfo = "#{unquizzed.length} unquizzed students"
      elsif unquizzed.length == 1
        name = Student.where(id:unquizzed.to_a[0],teacher: current_user.email).pick(:firstname, :lastname)
        if name.nil? || name.length == 0
          worstName = "No data available"
        else
          worstName = name[0] + " " + name[1]
        end
        worstInfo = "#{worstName} (unquizzed)"
      else
        if worstEntry.nil? || worstEntry.student_id.nil? || worstEntry.score.nil?
          wStud = "/"
          worstInfo = "No data available"
        else
          name = Student.where(id:worstEntry.student_id,teacher: current_user.email).pick(:firstname, :lastname)
          if name.nil? || name.length == 0
            worstName = "No data available"
          else
            worstName = name[0] + " " + name[1]
          end
          wStud = Student.where(id:worstEntry.student_id).first
          if wStud.nil?
            wStud = "/"
          end
          worstInfo = "#{worstName} (#{worstEntry.score.round(2)}%)"
        end
      end

      avg = ((avg.to_f / cnt.to_f).round(2)).to_s + "%"

      best = worst.order("wscore DESC").first
      bStud = ""
      bestInfo = ""
      if best.nil? || best.student_id.nil? || best.score.nil?
        bStud = "/"
        bestInfo = "No data available"
      else
        name = Student.where(id:best.student_id,teacher: current_user.email).pick(:firstname, :lastname)
        if name.nil? || name.length == 0
          bestName = "No data available"
        else
          bestName = name[0] + " " + name[1]
        end
        bStud = Student.where(id:best.student_id).first
        if bStud.nil?
          bStud = "/"
        end
        bestInfo = "#{bestName} (#{best.score.round(2)}%)"
      end
    end

    return [@student_records.size, avg, bestInfo, worstInfo]
  end
  helper_method :getStats

  # GET /courses or /courses.json
  def index
    @courses_db_result = Course.search(params[:search], current_user.email)
    @courses_comb_hash = Hash[]
    @courses_db_result.each do |c|
        if !@courses_comb_hash[c.course_name.strip]
            courseAllSections = CourseEntries.new
            courseAllSections.initializeUsingCourseModel(c)
            @courses_comb_hash[c.course_name.strip] = courseAllSections
        else
            course = @courses_comb_hash[c.course_name.strip]
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
    Course.where(course_name: Course.where(id: params[:id])[0].course_name, teacher: current_user.email).each do |c|
      @all_course_ids.append(c.id)
    end
    #get all students currently and previously enrolled in this course
    @student_ids = StudentCourse.where(course_id: @all_course_ids).pluck(:student_id)
    @student_records = Student.where(id: @student_ids)
    #get all students tags for those currently and previously enrolled in this course
    @tags = Set[]
    for student in @student_records do
        for tag_assoc in StudentsTag.where(student_id: student.id, teacher: current_user.email)
            tag_id = tag_assoc.tag_id
            if (result = Tag.where(id: tag_id)).length != 0
              @tags.add(result[0].tag_name)
            end
        end
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

        @student_ids = StudentCourse.where(course_id: @target_course_id.pluck(:id)).pluck(:student_id)
        #create the filtered list of students to display
        if @selected_tag != ''
            selected_tag_id = Tag.find_by(tag_name: @selected_tag).id
            all_tag_assocs = StudentsTag.where(tag_id: selected_tag_id, teacher: current_user.email)
            @student_records = @student_records.select {|record| all_tag_assocs.any? { |assoc| record.id == assoc.student_id}}
        else
            @student_records = Student.where(id: @student_ids, teacher: current_user.email) 
        end
    #if the user doesnt select any dropdown menu filters, display all students
    else
        #get all the current and previous semesters and sections of this course
        @target_course_id = @all_course_ids
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
        student_courses = StudentCourse.where(student_id: student.id, course_id: @target_course_id)
        for student_course in student_courses do
            course = Course.find_by(id: student_course.course_id)
            if !@student_records_hash[student.uin]
                student_entry = StudentEntries.new
                student_entry.initializeUsingStudentModel(student, course)
                @student_records_hash[student.uin] = student_entry
            else
                student_entry = @student_records_hash[student.uin]
                student_entry.records.append(student)
                student_entry.semester_section.add(course.semester + " - " + course.section.to_s)
                student_entry.course_semester.add(course.course_name + " - " + course.semester)
            end
        end
    end unless @student_records.nil?
    @student_records = @student_records_hash.values
    # sort the list of students
    if params[:sortOrder] == "Alphabetical"
      @student_records = @student_records.sort_by{ |student| student.records[0].lastname }
    elsif params[:sortOrder] == "Reverse Alphabetical"
      @student_records = @student_records.sort_by{ |student| student.records[0].lastname }.reverse
    end

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
    @student_records = StudentCourse.where(course_id: params[:id])
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
