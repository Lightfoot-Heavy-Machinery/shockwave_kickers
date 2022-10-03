class StudentsController < ApplicationController

    # GET /students
    def index
      @students = Student.all
    end

    # GET /students/1
    def show
        @student = Student.find(params[:id])
    end

    # GET /students/1/edit
    def edit
        @student = Student.find(params[:id])
    end

    # GET /students/new
    def new
        @student = Student.new
        @students = Student.all
    end

    # POST /students
    def create
        student = Student.new(params[:student].permit(:firstname,:lastname,:uin, :email, :classification, :major, :notes))
        if student.save
            redirect_to new_student_path
        end
    end

    # PATCH/PUT /students/1 or /studen ts/1.json
    def update
      @student = Student.find(params[:id])
      respond_to do |format|
        if @student.update(params.require(:student).permit(:firstname,:lastname,:uin, :email, :classification, :major, :notes))
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


end
