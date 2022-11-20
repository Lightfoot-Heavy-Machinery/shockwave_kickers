module Courses
    class HistoryController < CoursesController
        before_action :authenticate_user!
        before_action :set_course, only: %i[ show ]

        def show
            @course_records = Course.where(course_name: Course.where(id: params[:id])[0].course_name)
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
    end
end
