class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @id = current_user.email
    @dueStudents = Student.getDue(@id)
  end

  def stripYear(var)
    tmp = var.strip
    idx = tmp.rindex(" ")
    if idx.nil?
    else
      idx = idx + 1
      tmp = tmp[idx..-1].strip
    end
    return tmp
  end

  def getYears
    sems = Course.where(teacher:@id)
    uniqSems = Set.new
    sems.each do |s|
      year = stripYear(s.semester)
      uniqSems << year
    end
    return uniqSems.length()
  end
  helper_method :getYears


  def getNumDue()
    return @dueStudents.length
  end
  helper_method :getNumDue

  def getDueStudentQuiz()
    path = ""
    if @dueStudents.length > 0
      student = @dueStudents.sample
      return quiz_students_path(student)
    else
      return "/"
    end
  end
  helper_method :getDueStudentQuiz
end
