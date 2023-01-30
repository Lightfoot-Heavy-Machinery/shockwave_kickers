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


  def getAvgTotal
    avg = Quiz.where(teacher:@id).average(:score)
    if avg.nil?
      avg = "No quizzes taken!"
    else 
      avg = avg.round(2).to_s + "%"
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

  # TODO - ADD SUMMER/WINTER SEMESTERS
  def getAvgRecent
    recentFall = Course.where(teacher:@id).where("semester like ?", "%#{"Fall"}%").order(semester: :desc).first
    fallYear = 0000
    if recentFall.nil?
    else
      fallYear = stripYear(recentFall.semester)
    end

    recentSpring = Course.where(teacher:@id).where("semester like ?", "%#{"Spring"}%").order(semester: :desc).first
    springYear = 0000
    if recentSpring.nil?
    else
      springYear = stripYear(recentSpring.semester)
    end
   
    if fallYear == 0 && springYear == 0
      return ["Semester", "No quizzes taken!", "No quizzes taken!"]
    end
    
    semester = ""
    if fallYear.to_i > springYear.to_i
      semester = recentFall.semester
    else
      semester = recentSpring.semester
    end
   
    courses = Course.select(:id).where(teacher:@id).where("semester like ?", "%#{semester}%")
    
    avg = Quiz.where(teacher:@id,id:courses).average(:score)
    if avg.nil?
      avg = "No quizzes taken!"
    else 
      avg = avg.round(2).to_s + "%"
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
    if qID.length == 0
      return nil
    end

    atm = Qroster.where(quiz_id:qID,correct_resp:true).count(:attempts)
    if atm == 0
      return nil
    end

    best = Qroster.where(quiz_id:qID,correct_resp:true).group(:student_id).select(:student_id, "(SUM(CAST(1 AS Float) / CAST(attempts as Float)*100.00) / #{atm}) AS wscore", "(SUM(CAST(1 AS Float) / CAST(attempts as Float)*100.00)/COUNT(attempts)) AS score").order("wscore DESC").first
    bStud = ""
    bestInfo = ""
    if best.nil? || best.student_id.nil? || best.score.nil?
      bStud = "/"
      bestInfo = "No data available"
    else
      name = Student.where(id:best.student_id,teacher: @id).pick(:firstname, :lastname)
      if name.nil? || name.length == 0
        bestName = "No data available"
      else
        bestName = name[0] + " " + name[1]
      end
      bStud = Student.where(id:best.student_id).first
      if bStud.nil?
        bStud = "/"
      end
      bestInfo = "#{bestName} (#{best.score.round(2)}%)"
    end
    
    worst = Qroster.where(quiz_id:qID,correct_resp:true).group(:student_id).select(:student_id, "(SUM(CAST(1 AS Float) / CAST(attempts as Float)*100.00) / #{atm}) AS wscore", "(SUM(CAST(1 AS Float) / CAST(attempts as Float)*100.00)/COUNT(attempts)) AS score").order("wscore ASC")
    currS = -1
    worstEntry = nil
    worst.each do |qr|
      if (currS == -1) || (qr.score <= currS)
        currS = qr.score
        worstEntry = qr
      end
    end
    wStud = ""
    worstInfo = ""
    if worstEntry.nil? || worstEntry.student_id.nil? || worstEntry.score.nil?
      wStud = "/"
      worstInfo = "No data available"
    else
      name = Student.where(id:worstEntry.student_id,teacher: @id).pick(:firstname, :lastname)
      if name.nil? || name.length == 0
        worstName = "No data available"
      else
        worstName = name[0] + " " + name[1]
      end
      wStud = Student.where(id:worstEntry.student_id).first
      if wStud.nil?
        wStud = "/"
      end
      worstInfo = "#{worstName} (#{worstEntry.score.round(2)}%)"
    end

    
    ids = Qroster.where(quiz_id:qID,correct_resp:true).select(:student_id).distinct.pluck(:student_id)
    if ids.nil? || ids.length == 0
      hStud = "/"
      lStud = "/"
      highestInfo = "No data available"
      lowestInfo = "No data available"
    else
      maxCnt = 0
      maxID = 0
      minCnt = Float::INFINITY
      minID = 0
      ids.each do |i|
        next if i.nil?
        tmpCnt = 0
        qr = Qroster.where(quiz_id:qID,student_id:i,correct_resp:true).order(updated_at: :desc).pluck(:attempts)
        next if qr.nil?
        qr.each do |att|
          break if att.nil?
          if att == 1
            tmpCnt = tmpCnt + 1
          else
            break
          end
        end
        if tmpCnt > 0
          if tmpCnt > maxCnt
            maxCnt = tmpCnt
            maxID = i
          end
          if tmpCnt < minCnt
            minCnt = tmpCnt
            minID = i
          end
        end
      end
      if maxID == 0 || maxCnt == 0
        highestInfo = "No data available"
        hStud = "/"
      else
        hStud = Student.where(id:maxID).first
        if hStud.nil?
          highestInfo = "No data available"
          hStud = "/"
        else
          name = Student.where(id:maxID,teacher: @id).pick(:firstname, :lastname)
          if name.nil? || name.length == 0
            highestName = "No name available"
          else
            highestName = name[0] + " " + name[1]
          end
          highestInfo = "#{highestName} (#{maxCnt})"
        end
      end

      if minID == 0 || minCnt == 0
        lowestInfo = "No data available"
        lStud = "/"
      else
        lStud = Student.where(id:minID).first
        if lStud.nil?
          lStud = "/"
          lowestInfo = "No data available"
        else
          name = Student.where(id:minID,teacher: @id).pick(:firstname, :lastname)
          if name.length < 2
            lowestName = "No name available"
          else
            lowestName = name[0] + " " + name[1]
          end    
          lowestInfo = "#{lowestName} (#{minCnt})"
        end
      end
    end

    return [bStud, bestInfo, wStud, worstInfo, hStud, highestInfo, lStud, lowestInfo]
  end
  helper_method :studentInfo

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
