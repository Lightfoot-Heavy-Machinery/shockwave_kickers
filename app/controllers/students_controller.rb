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
    end

    # GET /students/1
    def show
    end

    # GET /students/1/edit
    def edit
    end

    # GET /students/new
    def new
        @student = Student.new
    end

    # POST /students/
    def create
        @student = Student.new(student_params)
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

    # PATCH/PUT /students/1 or /studen ts/1.json
    def update
      @student = Student.find(params[:id])
      respond_to do |format|
        if @student.update(student_params)
          format.html { redirect_to student_url(@student), notice: "Student information was successfully updated." }
          format.json { render :show, status: :ok, location: @student }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @student.errors, status: :unprocessable_entity }
        end
      end
    end

    #DELETE courses/1
    def destroy
        @student = Student.find(params[:id])
        @student.image.purge_later
        @student.destroy
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
        def student_params
            params.require(:student).permit(:firstname,:lastname, :uin, :email, :course_id, :classification, :major, :notes, :tags, :image).with_defaults(teacher: current_user.email)
        end

end
