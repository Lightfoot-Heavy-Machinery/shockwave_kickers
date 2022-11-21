require "test_helper"

class QuizzesControllerTest < ActionDispatch::IntegrationTest
    setup do
        sign_in users(:userOne)
        @course = courses(:courseOne)
        @student = students(:studentOneCourseOne)
        @quiz = quizzes(:quizOneCourseOne)
        @quizTargeted = quizzes(:quizTwoTargetedCourseOne)
        @quizCourseTwo = quizzes(:quizThreeCourseTwo)
        @quizCourseTwoTargeted = quizzes(:quizFourTargetedCourseTwo)
        @quizCompleted = quizzes(:quizOneCourseOneCompleted)
    end

    test "should get index" do
        get quizzes_url
        assert_response :success
    end

    test "should get new" do
        get new_quiz_url
        assert_response :success
    end

    test "should create quiz" do
        before_quiz_count = Quiz.count
        before_qroster_count = Qroster.count
        post quizzes_url, params: { quiz: { course_id: @quiz.course_id, correct: @quiz.correct, incorrect: @quiz.incorrect, score: @quiz.score, longest_streak: @quiz.longest_streak, completed: @quiz.completed, validate_id: @quiz.validate_id, targeted: @quiz.targeted} }
        after_quiz_count = Quiz.count
        after_qroster_count = Qroster.count

        assert_equal before_quiz_count + 1, after_quiz_count
        assert_equal before_qroster_count + 1, after_qroster_count
        assert_redirected_to quiz_url(Quiz.last)
    end

    test "should create quiz targeted use existing qroster" do
        before_quiz_count = Quiz.count
        before_qroster_count = Qroster.count
        post quizzes_url, params: { quiz: { course_id: @quizTargeted.course_id, correct: @quizTargeted.correct, incorrect: @quizTargeted.incorrect, score: @quizTargeted.score, longest_streak: @quizTargeted.longest_streak, completed: @quizTargeted.completed, validate_id: @quizTargeted.validate_id, targeted: @quizTargeted.targeted} }
        after_quiz_count = Quiz.count
        after_qroster_count = Qroster.count

        assert_equal before_quiz_count + 1, after_quiz_count
        assert_equal before_qroster_count + 1, after_qroster_count
        assert_redirected_to quiz_url(Quiz.last)
    end

    test "should create quiz and 2 qroster entries" do
        before_quiz_count = Quiz.count
        before_qroster_count = Qroster.count
        post quizzes_url, params: { quiz: { course_id: @quizCourseTwo.course_id, correct: @quizCourseTwo.correct, incorrect: @quizCourseTwo.incorrect, score: @quizCourseTwo.score, longest_streak: @quizCourseTwo.longest_streak, completed: @quizCourseTwo.completed, validate_id: @quizCourseTwo.validate_id, targeted: @quizCourseTwo.targeted} }
        after_quiz_count = Quiz.count
        after_qroster_count = Qroster.count

        assert_equal before_quiz_count + 1, after_quiz_count
        assert_equal before_qroster_count + 2, after_qroster_count
        assert_redirected_to quiz_url(Quiz.last)
    end

    test "should create quiz targeted no history and 2 qroster entries" do
        before_quiz_count = Quiz.count
        before_qroster_count = Qroster.count
        post quizzes_url, params: { quiz: { course_id: @quizCourseTwoTargeted.course_id, correct: @quizCourseTwoTargeted.correct, incorrect: @quizCourseTwoTargeted.incorrect, score: @quizCourseTwoTargeted.score, longest_streak: @quizCourseTwoTargeted.longest_streak, completed: @quizCourseTwoTargeted.completed, validate_id: @quizCourseTwoTargeted.validate_id, targeted: @quizCourseTwoTargeted.targeted} }
        after_quiz_count = Quiz.count
        after_qroster_count = Qroster.count

        assert_equal before_quiz_count + 1, after_quiz_count
        assert_equal before_qroster_count + 2, after_qroster_count
        assert_redirected_to quiz_url(Quiz.last)
    end

    test "view quiz completed" do
        get quiz_url(@quizCompleted)
        assert_response :success
    end

    test "submit quiz correct answer for ongoing quiz" do
        get quiz_url(@quizCourseTwo), params: {answer: @quizCourseTwo.validate_id}
        assert_response :success
    end

    test "submit quiz incorrect answer for ongoing quiz" do
        #correct id should be 2
        get quiz_url(@quizCourseTwo), params: {answer: 3}
        assert_response :success
    end
end