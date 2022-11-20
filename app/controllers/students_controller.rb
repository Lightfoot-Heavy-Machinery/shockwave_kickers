class StudentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_student, only: %i[ show edit update destroy ]
    # GET /student
    def index
        @students = Student.where(teacher: current_user.email)
        @tags = Set[]
        @emails = Set[]

        @courses_taken = Hash[]
        @semesters_taken = Hash[]
        for student in @students do
            @tags.add(student.tags)

            # Figure out each student's course/semester they have taken
            @courses_taken[student.course_id] = Course.find(student.course_id).course_name
            @semesters_taken[student.course_id] = Course.find(student.course_id).semester

        end
        @semesters = Set[]
        @sections = Set[]
        @course_names = Set[]
        @course_ids = Array[]
        for record in Course.all do
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
            #create the filtered list of students to display
            @students = Student.where(course_id: @target_course_id)
            if @selected_tag != ''
                @students = @students.select {|s| s.tags == @selected_tag}
            end
        end
        @student_records_hash = Hash[]
        for student in @students do
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
        end unless @students.nil?
        @students = @student_records_hash.values
    end

    # GET /students/1
    def show
    end

    # GET /students/1/edit
    def edit
        @all_student_course_enrties= Student.where(uin: Student.where(teacher: current_user.email, id: params[:id])[0].uin)
        @student_course_records_hash = Hash[]
        for student_db_entry in @all_student_course_enrties do
            student_course_entry = StudentCourseEntry.new
            student_course_entry.student_record = student_db_entry
            @student_course_records_hash[student_db_entry.course_id] = student_course_entry
        end

        @all_student_course_ids = @all_student_course_enrties.pluck(:course_id)
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
    end

    # PATCH/PUT /students/1 or /students/1.json
    def update
      @student = Student.find(params[:id])
      respond_to do |format|
        if !params[:student][:final_grade].nil?
            if @student.update(final_grade: params[:student][:final_grade])
                format.html { redirect_to student_url(@student), notice: "Student information was successfully updated." }
                format.json { render :show, status: :ok, location: @student }
            else
                format.html { render :edit, status: :unprocessable_entity }
                format.json { render json: @student.errors, status: :unprocessable_entity }
            end
        else
            @student_records = Student.where(uin: Student.where(teacher: current_user.email, id: params[:id])[0].uin)
            for student_course in @student_records
                if !student_course.update(student_basic_params)
                    format.html { render :edit, status: :unprocessable_entity }
                    format.json { render json: @student.errors, status: :unprocessable_entity }
                end
            end
            format.html { redirect_to student_url(@student), notice: "Student information was successfully updated." }
            format.json { render :show, status: :ok, location: @student }
        end
      end
    end

    #DELETE student/1
    #Removes student and all it's courses. Or remove course of a student.
    def destroy
        Rails.logger.info "Received param #{params}"
        if params[:type] == "all"
            @student_records = Student.where(uin: Student.where(teacher: current_user.email, id: params[:id])[0].uin)
            for student in @student_records
                student.image.purge
            end
            @student_records.destroy_all
        else
            @student = Student.find(params[:id])
            @student.image.purge
            @student.destroy
        end
        redirect_to action: "index"
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_student
            @student = Student.find_by(teacher: current_user.email, id: params[:id])
            Rails.logger.info "Received info #{@student.inspect}"
            if !@student.nil?
                Rails.logger.info "Received info #{@student.inspect}"
            else
                respond_to do |format|
                    format.html { redirect_to students_url, notice: "Given student not found." }
                    format.json { head :no_content }
                end
            end
        end

            # Only allow a list of trusted parameters through.
        def student_basic_params
            params.require(:student).permit(:firstname,:lastname, :uin, :email, :classification, :major, :notes, :tags, :image, :course_id).with_defaults(teacher: current_user.email)
        end

end
