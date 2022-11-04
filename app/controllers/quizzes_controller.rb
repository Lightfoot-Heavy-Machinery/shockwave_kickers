class QuizzesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_quiz, only: %i[ show edit update destroy ]

  # GET /quizzes or /quizzes.json
  def index
    @quizzes = Quiz.where(teacher: current_user.email)
  end

  # GET /quizzes/1 or /quizzes/1.json
  def show
    resp = params[:answer]
    if @quiz.validate_id.nil? || resp.nil?
      
    elsif resp.to_i == @quiz.validate_id
      roster = Qroster.where(quiz_id:@quiz.id,student_id:resp).first
      roster.correct_resp = true
      roster.save

      @quiz.correct = @quiz.correct + 1
      @quiz.current_streak = @quiz.current_streak + 1
      if @quiz.current_streak > @quiz.longest_streak
        @quiz.longest_streak = @quiz.current_streak
      end
    else
      roster = Qroster.where(quiz_id:@quiz.id,student_id:resp).first
      roster.correct_resp = false
      roster.save
      
      @quiz.incorrect = @quiz.incorrect + 1
      @quiz.current_streak = 0
    end
    
    @quiz.validate_id = nil
    @quiz.save


    logger.info("WE GOT:")
    logger.info(params)
    logger.info(params[:answer].to_i)
    
    disp_quiz()
  end

  # GET /quizzes/new
  def new
    @quiz = Quiz.new
  end

  # GET /quizzes/1/edit
  def edit
  end

  # POST /quizzes or /quizzes.json
  def create
    @quiz = Quiz.new(quiz_params)

    respond_to do |format|
      if @quiz.save
        format.html { redirect_to quiz_url(@quiz), notice: "Quiz was successfully created." }
        format.json { render :show, status: :created, location: @quiz }
        Student.where(teacher: current_user.email, course_id:@quiz.course_id).each do |stud|
          Qroster.create(quiz_id:@quiz.id,student_id:stud.id)
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quizzes/1 or /quizzes/1.json
  def update
    respond_to do |format|
      if @quiz.update(quiz_params)
        format.html { redirect_to quiz_url(@quiz), notice: "Quiz was successfully updated." }
        format.json { render :show, status: :ok, location: @quiz }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quizzes/1 or /quizzes/1.json
  def destroy
    @quiz.destroy

    respond_to do |format|
      format.html { redirect_to quizzes_url, notice: "Quiz was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      @quiz = Quiz.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def quiz_params
      params.require(:quiz).permit(:course_id, :correct, :incorrect, :score, :longest_streak, :completed).with_defaults(teacher: current_user.email)
    end

    def disp_quiz
      if Qroster.where(quiz_id:@quiz.id,correct_resp:nil).count <= 0
        @quiz.completed = true
        @quiz.save
        return
      end

      loop do
        untested = Qroster.where(quiz_id:@quiz.id,correct_resp:nil)
        untested = untested.shuffle
        @random_stud = Qroster.where(id:untested[0]).first
        break if @random_stud.correct_resp.nil?
      end
      
      @quiz.validate_id = @random_stud.student_id
      @quiz.save

      @stud_obj = Student.where(id:@random_stud.student_id,teacher: current_user.email, course_id:@quiz.course_id).first
      @choices = Qroster.where(quiz_id:@quiz.id).where.not(student_id:@random_stud.student_id).limit(3).pluck(:student_id)
      @choices.append(@random_stud.student_id)
      @choices = @choices.shuffle
    end
end
