class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @id = current_user.email
  end

  def getYears
    sems = Course.where(teacher:@id)
    uniqSems = Set.new
    sems.each do |s|
      uniqSems << s.semester[-4..-1]
    end
    return uniqSems.length()
  end
  helper_method :getYears


  def getAvgTotal
    avg = Quiz.where(teacher:@id).average(:score)
    if avg.nil?
      avg = "No quizzes taken!"
    else 
      avg = avg.round(2)
    end

    strk = Quiz.where(teacher:@id).average(:longest_streak)
    if strk.nil?
      strk = "No quizzes taken!"
    end

    return [avg, strk]
  end
  helper_method :getAvgTotal

  def getAvgRecent
    recentFall = Course.where(teacher:@id).where("semester like ?", "%#{"Fall"}%").order(semester: :desc).first
    fallYear = (recentFall.semester[-4..-1] || "0").to_i
    recentSpring = Course.where(teacher:@id).where("semester like ?", "%#{"Spring"}%").order(semester: :desc).first
    springYear = (recentSpring.semester[-4..-1] || "0").to_i
   
    semester = ""
    if fallYear > springYear
      semester = recentFall.semester
    else
      semester = recentSpring.semester
    end
   
    courses = Course.select(:id).where(teacher:@id).where("semester like ?", "%#{semester}%")
    
    avg = Quiz.where(teacher:@id,id:courses).average(:score)
    if avg.nil?
      avg = "No quizzes taken!"
    else 
      avg = avg.round(2)
    end

    strk = Quiz.where(teacher:@id,id:courses).average(:longest_streak)
    if strk.nil?
      strk = "No quizzes taken!"
    end
    
    return [semester, avg, strk]
  end
  helper_method :getAvgRecent

  def studentBestWorst
    qID = Quiz.where(teacher:@id).pluck(:id)
    best = Qroster.where(quiz_id:qID,correct_resp:true,attempts:1).order(updated_at: :desc).pluck(:student_id).first
    name = Student.where(id:best,teacher: @id).pick(:firstname, :lastname)
    bestName = name[0] + " " + name[1]
    bestScore = 0
    bestAttempts = Qroster.where(quiz_id:qID,student_id:best,correct_resp:true).pluck(:attempts)
    bestAttempts.each do |val|
      bestScore = bestScore + 1.00 / val * 100 
    end
    bestScore = bestScore / bestAttempts.length()
    bestInfo = "#{bestName} (#{bestScore})%"

    worst = Qroster.where(quiz_id:qID).order(attempts: :desc).order(updated_at: :desc).pluck(:student_id).first
    name = Student.where(id:worst,teacher: @id).pick(:firstname, :lastname)
    worstName = name[0] + " " + name[1]
    worstScore = 0
    worstAttempts = Qroster.where(quiz_id:qID,student_id:worst,correct_resp:true).pluck(:attempts)
    worstAttempts.each do |val|
      worstScore = worstScore + 1.00 / val * 100 
    end
    worstScore = worstScore / worstAttempts.length()
    worstInfo = "#{worstName} (#{worstScore})%"
    
    return [best,bestInfo,worst,worstInfo]
  end
  helper_method :studentBestWorst
end
