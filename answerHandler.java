package quizeApp;

import java.io.IOException;
import java.util.ArrayList;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/answerHandler")
public class answerHandler extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        ArrayList<QuizServlet.Question> questions = 
                (ArrayList<QuizServlet.Question>) session.getAttribute("questions");
        Integer currentIndex = (Integer) session.getAttribute("currentIndex");
        Integer score = (Integer) session.getAttribute("score");

        if (questions == null || currentIndex == null) {
            response.sendRedirect("level.jsp");
            return;
        }

        int selectedAnswer = Integer.parseInt(request.getParameter("answer"));
        QuizServlet.Question currentQuestion = questions.get(currentIndex);

        String resultMessage;
        if (selectedAnswer == currentQuestion.correct_option) {
            score++;
            session.setAttribute("score", score);
            resultMessage = "Correct!";
        } else {
            resultMessage = "Wrong! Correct answer was option " + currentQuestion.correct_option;
        }

        currentIndex++;
        session.setAttribute("currentIndex", currentIndex);
        request.setAttribute("feedback", resultMessage);

        if (currentIndex >= questions.size()) {
            response.sendRedirect("result.jsp"); // quiz finished
        } else {
            request.getRequestDispatcher("quizequestion.jsp").forward(request, response); // next question
        }
    }
}
