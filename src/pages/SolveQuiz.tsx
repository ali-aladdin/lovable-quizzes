import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { Label } from "@/components/ui/label";
import { getCurrentUser, getQuizById, saveQuizResult } from "@/lib/storage";
import { QuizAnswer } from "@/types/quiz";
import { ArrowLeft, CheckCircle2, XCircle, Trophy } from "lucide-react";
import { toast } from "sonner";

const SolveQuiz = () => {
  const { quizId } = useParams();
  const navigate = useNavigate();
  const currentUser = getCurrentUser();

  const [quiz, setQuiz] = useState(getQuizById(quizId || ""));
  const [answers, setAnswers] = useState<QuizAnswer[]>([]);
  const [submitted, setSubmitted] = useState(false);
  const [score, setScore] = useState(0);

  useEffect(() => {
    if (!currentUser) {
      navigate("/");
      return;
    }

    if (!quiz) {
      toast.error("Quiz not found");
      navigate("/home");
      return;
    }

    setAnswers(
      quiz.questions.map((q) => ({
        questionId: q.id,
        selectedChoiceIndex: null,
      }))
    );
  }, [quiz, currentUser, navigate]);

  if (!quiz || !currentUser) return null;

  const handleAnswerChange = (questionId: string, choiceIndex: number) => {
    setAnswers(
      answers.map((a) =>
        a.questionId === questionId ? { ...a, selectedChoiceIndex: choiceIndex } : a
      )
    );
  };

  const handleSubmit = () => {
    const unanswered = answers.filter((a) => a.selectedChoiceIndex === null);
    if (unanswered.length > 0) {
      toast.error(`Please answer all questions (${unanswered.length} remaining)`);
      return;
    }

    let correctCount = 0;
    quiz.questions.forEach((question, index) => {
      if (answers[index].selectedChoiceIndex === question.correctAnswerIndex) {
        correctCount++;
      }
    });

    setScore(correctCount);
    setSubmitted(true);

    const result = {
      quizId: quiz.id,
      answers,
      score: correctCount,
      totalQuestions: quiz.questions.length,
      completedAt: new Date().toISOString(),
    };

    saveQuizResult(result);
    toast.success("Quiz submitted successfully!");
  };

  if (submitted) {
    const percentage = Math.round((score / quiz.questions.length) * 100);

    return (
      <div className="min-h-screen bg-gradient-bg py-8">
        <div className="container mx-auto px-4 max-w-4xl">
          <Card className="shadow-card-hover text-center py-12">
            <CardContent>
              <div className="flex justify-center mb-6">
                <div className="h-24 w-24 rounded-full bg-gradient-primary flex items-center justify-center">
                  <Trophy className="h-12 w-12 text-primary-foreground" />
                </div>
              </div>
              <h2 className="text-3xl font-bold mb-4">Quiz Completed!</h2>
              <p className="text-5xl font-bold text-primary mb-2">
                {score} / {quiz.questions.length}
              </p>
              <p className="text-xl text-muted-foreground mb-8">
                You scored {percentage}%
              </p>

              <div className="space-y-4 mb-8 text-left">
                {quiz.questions.map((question, index) => {
                  const userAnswer = answers[index].selectedChoiceIndex;
                  const isCorrect = userAnswer === question.correctAnswerIndex;

                  return (
                    <Card key={question.id} className={isCorrect ? "border-success" : "border-destructive"}>
                      <CardHeader>
                        <CardTitle className="text-base flex items-center gap-2">
                          {isCorrect ? (
                            <CheckCircle2 className="h-5 w-5 text-success" />
                          ) : (
                            <XCircle className="h-5 w-5 text-destructive" />
                          )}
                          Question {index + 1}: {question.text}
                        </CardTitle>
                      </CardHeader>
                      <CardContent>
                        <div className="space-y-2">
                          <p className="text-sm">
                            <span className="font-medium">Your answer: </span>
                            <span className={isCorrect ? "text-success" : "text-destructive"}>
                              {userAnswer !== null ? question.choices[userAnswer].text : "No answer"}
                            </span>
                          </p>
                          {!isCorrect && (
                            <p className="text-sm">
                              <span className="font-medium">Correct answer: </span>
                              <span className="text-success">
                                {question.choices[question.correctAnswerIndex].text}
                              </span>
                            </p>
                          )}
                        </div>
                      </CardContent>
                    </Card>
                  );
                })}
              </div>

              <Button
                onClick={() => navigate("/home")}
                className="bg-gradient-primary hover:opacity-90 transition-opacity"
              >
                Back to Home
              </Button>
            </CardContent>
          </Card>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-bg py-8">
      <div className="container mx-auto px-4 max-w-4xl">
        <div className="mb-6">
          <Button variant="outline" onClick={() => navigate("/home")}>
            <ArrowLeft className="h-4 w-4 mr-2" />
            Back
          </Button>
        </div>

        <Card className="mb-6 shadow-card">
          <CardHeader>
            <CardTitle className="text-2xl">{quiz.title}</CardTitle>
            <p className="text-muted-foreground">{quiz.description}</p>
          </CardHeader>
        </Card>

        <div className="space-y-6">
          {quiz.questions.map((question, index) => (
            <Card key={question.id} className="shadow-card">
              <CardHeader>
                <CardTitle className="text-lg">
                  Question {index + 1} of {quiz.questions.length}
                </CardTitle>
                <p className="text-base font-medium mt-2">{question.text}</p>
              </CardHeader>
              <CardContent>
                <RadioGroup
                  value={
                    answers[index]?.selectedChoiceIndex !== null
                      ? answers[index].selectedChoiceIndex?.toString()
                      : undefined
                  }
                  onValueChange={(value) =>
                    handleAnswerChange(question.id, parseInt(value))
                  }
                >
                  {question.choices.map((choice, cIndex) => (
                    <div
                      key={choice.id}
                      className="flex items-center space-x-3 p-3 rounded-lg hover:bg-muted/50 transition-colors"
                    >
                      <RadioGroupItem value={cIndex.toString()} id={`${question.id}-${choice.id}`} />
                      <Label
                        htmlFor={`${question.id}-${choice.id}`}
                        className="flex-1 cursor-pointer"
                      >
                        {choice.text}
                      </Label>
                    </div>
                  ))}
                </RadioGroup>
              </CardContent>
            </Card>
          ))}
        </div>

        <Button
          onClick={handleSubmit}
          className="w-full mt-8 bg-gradient-primary hover:opacity-90 transition-opacity"
          size="lg"
        >
          Submit Answers
        </Button>
      </div>
    </div>
  );
};

export default SolveQuiz;
