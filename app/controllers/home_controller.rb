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
    else
      strk = strk.round(2)
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
    else
      strk = strk.round(2)
    end
    
    return [semester, avg, strk]
  end
  helper_method :getAvgRecent

  def studentInfo
    qID = Quiz.where(teacher:@id).pluck(:id)
    atm = Qroster.where(quiz_id:qID,correct_resp:true).count(:attempts)

    best = Qroster.where(quiz_id:qID,correct_resp:true).group(:student_id).select(:student_id, "(SUM(CAST(1 AS Float) / CAST(attempts as Float)*100.00) / #{atm}) AS wscore", "(SUM(CAST(1 AS Float) / CAST(attempts as Float)*100.00)/COUNT(attempts)) AS score").order("wscore DESC").first
    name = Student.where(id:best.student_id,teacher: @id).pick(:firstname, :lastname)
    bestName = name[0] + " " + name[1]
    bestInfo = "#{bestName} (#{best.score.round(2)}%)"


    worst = Qroster.where(quiz_id:qID,correct_resp:true).group(:student_id).select(:student_id, "(SUM(CAST(1 AS Float) / CAST(attempts as Float)*100.00) / #{atm}) AS wscore", "(SUM(CAST(1 AS Float) / CAST(attempts as Float)*100.00)/COUNT(attempts)) AS score").order("wscore ASC").first
    name = Student.where(id:worst.student_id,teacher: @id).pick(:firstname, :lastname)
    worstName = name[0] + " " + name[1]
    worstInfo = "#{worstName} (#{worst.score.round(2)}%)"
    
    ids = Qroster.where(quiz_id:qID,correct_resp:true).select(:student_id).distinct.pluck(:student_id)
    logger.info("IDS: #{ids}")
    maxCnt = 0
    maxID = 0
    minCnt = Float::INFINITY
    minID = 0
    ids.each do |i|
      tmpCnt = 0
      qr = Qroster.where(quiz_id:qID,student_id:i,correct_resp:true).order(updated_at: :desc).pluck(:attempts)
      logger.info("HIGHEST: #{qr}")
      qr.each do |att|
        if att == 1
          tmpCnt = tmpCnt + 1
          if tmpCnt > maxCnt
            maxCnt = tmpCnt
            maxID = i
          end
          if tmpCnt < minCnt
            minCnt = tmpCnt
            minID = i
          end
        else
          break
        end
      end
    end

    name = Student.where(id:maxID,teacher: @id).pick(:firstname, :lastname)
    highestName = name[0] + " " + name[1]
    highestInfo = "#{highestName} (#{maxCnt})"
    logger.info("HIGH: #{highestInfo}")
    name = Student.where(id:minID,teacher: @id).pick(:firstname, :lastname)
    lowestName = name[0] + " " + name[1]
    lowestInfo = "#{lowestName} (#{minCnt})"
    logger.info("LOW: #{lowestInfo}")


    return [best.student_id, bestInfo, worst.student_id, worstInfo, maxID, highestInfo, minID, lowestInfo]
  end
  helper_method :studentInfo
end
