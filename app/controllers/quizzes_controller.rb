class QuizzesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_quiz, only: %i[ show ]

  # GET /quizzes or /quizzes.json
  def index
    @quizzes = Quiz.where(teacher: current_user.email)
  end

  # GET /quizzes/1 or /quizzes/1.json
  def show
    resp = params[:answer]
    
    if @quiz.validate_id.nil? || resp.nil? || resp.to_i == 0
      if @quiz.longest_streak.nil?
        @quiz.longest_streak = 0
      end
      if @quiz.completed.nil?
        @quiz.completed = false
      end
      if @quiz.current_streak.nil?
        @quiz.current_streak = 0
      end
      @quiz.save
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
    
    if (@quiz.correct.to_i + @quiz.incorrect.to_i) == 0.to_i
      @quiz.score = 0
    else
      @quiz.score = @quiz.correct.to_f / (@quiz.correct + @quiz.incorrect) * 100
    end
    
    @quiz.validate_id = nil
    @quiz.save
    
    disp_quiz()
  end

  # GET /quizzes/new
  def new
    @quiz = Quiz.new
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      @quiz = Quiz.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def quiz_params
      params.require(:quiz).permit(:course_id, :correct, :incorrect, :score, :longest_streak, :completed, :current_streak, :validate_id, :teacher).with_defaults(teacher: current_user.email)
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
      @choices = Qroster.where(quiz_id:@quiz.id).where.not(student_id:@random_stud.student_id).pluck(:student_id)
      @choices = @choices.shuffle.slice(0,3)
      @choices.append(@random_stud.student_id)
      @choices = @choices.shuffle
    end
end
