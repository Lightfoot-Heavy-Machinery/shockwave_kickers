class StudentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_student, only: %i[ show edit update destroy ]
    # GET /students
    def index
      @students = Student.where(teacher: current_user.email)
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

    # POST /students
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
        if @student.update(params.require(:student).permit(:firstname,:lastname,:uin, :email, :classification, :major, :notes, :tags))
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
            params.require(:student).permit(:firstname,:lastname, :uin, :email, :course_id, :classification, :major, :notes, :tags, :photo).with_defaults(teacher: current_user.email)
        end

end
