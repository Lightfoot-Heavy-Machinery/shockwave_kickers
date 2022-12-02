class StudentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_student, only: %i[ show edit update destroy ]
    # GET /student
    def index
        @students = Student.search(params[:search], current_user.email)
        @tags = Set[]
        @emails = Set[]

        @courses_taken = Hash[]
        @semesters_taken = Hash[]
        for student in @students do
            @tags.add(student.tags)
        end
        @semesters = Set[]
        @sections = Set[]
        @course_names = Set[]
        @course_ids = Array[]
        for record in Course.where(teacher: current_user.email) do
            @semesters.add(record.semester)
            @sections.add(record.section)
            @course_names.add(record.course_name)
            @course_ids.append(record.id)
        end

        if params[:selected_course].nil? == false or params[:selected_semester].nil? == false or params[:selected_tag].nil? == false
            #dropdown menu selections
            @selected_tag = params[:selected_tag]
            @selected_semester = params[:selected_semester]
            @selected_course = params[:selected_course]
            #get all course id's for the selected semester + course combo
            if @selected_semester == '' and @selected_course != ''
                @target_course_id = Course.where(course_name: @selected_course)
            elsif @selected_semester != '' and @selected_course == ''
                @target_course_id = Course.where(semester: @selected_semester)
            elsif @selected_semester != '' and @selected_course != ''
                @target_course_id = Course.where(course_name: @selected_course, semester: @selected_semester)
            else
                @target_course_id = @course_ids
            end

            @student_ids = StudentCourse.where(course_id: @target_course_id).pluck(:student_id)
            #create the filtered list of students to display
            @students = Student.where(id: @student_ids)
            if @selected_tag != ''
                @students = @students.select {|s| s.tags == @selected_tag}
            end
        else
            @target_course_id = @course_ids
        end
        @student_records_hash = Hash[]
        for student in @students do
            @student_courses = StudentCourse.where(student_id: student.id, course_id: @target_course_id)
            for student_course in @student_courses
                course = Course.where(id: student_course.course_id)
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
            end
        end unless @students.nil?
        @students = @student_records_hash.values
    end

    # GET /students/1
    def show
      #get this student's course history
      student_courses = StudentCourse.where(student_id: @student.id)
      @course_history = Set[]
      for student_course in student_courses do
        course = Course.find_by(id: student_course.course_id)
        #Course history format: CSCE 999 (FALL 2019), ECEN 350 ( SPRING 2020), etc
        @course_history.add(course.course_name.to_s + " (" + course.semester.to_s + ")")
      end
      #convert course history into a string
      @course_history = @course_history.to_a.join(", ")
    end

    # GET /students/1/edit
    def edit
        @all_student_course_entries= StudentCourse.where(student_id: @student.id)
        @student_course_records_hash = Hash[]
        Rails.logger.info "Collected all 11 #{@all_student_course_entries.inspect}"
        for student_course_db_entry in @all_student_course_entries do
            student_course_entry = StudentCourseEntry.new
            student_course_entry.student_record = student_course_db_entry
            @student_course_records_hash[student_course_db_entry.course_id] = student_course_entry
        end

        @all_student_course_ids = @all_student_course_entries.pluck(:course_id)
        @courses = Course.where(id: @all_student_course_ids)
        for course_db_entry in @courses do
            # TODO check for nil
            student_course_entry = @student_course_records_hash[course_db_entry.id]
            student_course_entry.course_record = course_db_entry
        end

        @student_course_records = @student_course_records_hash.values
        Rails.logger.info "Collected all student courses #{@student_course_records.inspect}"
    end

    # GET /students/new
    def new
        @student = Student.new
    end

    # POST /students/
    def create
        if !Student.find_by(uin: params[:student][:uin], teacher: current_user.email)
            @student = Student.new(student_basic_params)
            respond_to do |format|
                if @student.save
                    format.html { redirect_to student_url(@student), notice: "Student was successfully created." }
                    format.json { render :show, status: :created, location: @student }
                else
                    format.html { render :new, status: :unprocessable_entity }
                    format.json { render json: @student.errors, status: :unprocessable_entity }
                end
            end
        else
            respond_to do |format|
                format.html { redirect_to students_url(@student), notice: "Student with the UIN was already created." }
            end
        end
    end

    # PATCH/PUT /students/1 or /students/1.json
    def update
      @student = Student.find(params[:id])
      respond_to do |format|
        if @student.update(student_basic_params)
            format.html { redirect_to student_url(@student), notice: "Student information was successfully updated." }
            format.json { render :show, status: :ok, location: @student }
        else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @student.errors, status: :unprocessable_entity }
        end
      end
    end

    #DELETE student/1
    #Removes student and all it's courses. Or remove course of a student.
    def destroy
        @student = Student.find_by(id: params[:id])
        @student_course_records = StudentCourse.where(student_id: @student.id)
        @student_course_records.destroy_all
        @qroster_records = Qroster.where(student_id: @student.id)
        @qroster_records.destroy_all
        @student_course_records.destroy_all
        @student.image.purge
        @student.destroy
        redirect_to action: "index"
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_student
            @student = Student.find_by(teacher: current_user.email, id: params[:id])
            if @student.nil?
                respond_to do |format|
                    format.html { redirect_to students_url, notice: "Given student not found." }
                    format.json { head :no_content }
                end
            end
        end

            # Only allow a list of trusted parameters through.
        def student_basic_params
            params.require(:student).permit(:firstname,:lastname, :uin, :email, :classification, :major, :notes, :tags, :image).with_defaults(teacher: current_user.email)
        end
end
