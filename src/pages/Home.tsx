import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { getCurrentUser, getQuizzes, setCurrentUser } from "@/lib/storage";
import { Quiz } from "@/types/quiz";
import { Plus, BookOpen, LogOut, FileQuestion } from "lucide-react";
import { toast } from "sonner";

const Home = () => {
  const [quizzes, setQuizzes] = useState<Quiz[]>([]);
  const [currentUser, setCurrentUserState] = useState(getCurrentUser());
  const navigate = useNavigate();

  useEffect(() => {
    const user = getCurrentUser();
    if (!user) {
      navigate("/");
      return;
    }
    setCurrentUserState(user);
    loadQuizzes();
  }, [navigate]);

  const loadQuizzes = () => {
    const allQuizzes = getQuizzes();
    setQuizzes(allQuizzes);
  };

  const handleLogout = () => {
    setCurrentUser(null);
    toast.success("Logged out successfully");
    navigate("/");
  };

  const handleQuizClick = (quizId: string) => {
    navigate(`/quiz/${quizId}`);
  };

  return (
    <div className="min-h-screen bg-gradient-bg">
      <header className="border-b bg-card/50 backdrop-blur-sm sticky top-0 z-10">
        <div className="container mx-auto px-4 py-4 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="h-10 w-10 rounded-full bg-gradient-primary flex items-center justify-center">
              <BookOpen className="h-5 w-5 text-primary-foreground" />
            </div>
            <div>
              <h1 className="text-xl font-bold">Quiz Master</h1>
              <p className="text-sm text-muted-foreground">Welcome, {currentUser?.username}</p>
            </div>
          </div>
          <Button variant="outline" size="sm" onClick={handleLogout}>
            <LogOut className="h-4 w-4 mr-2" />
            Logout
          </Button>
        </div>
      </header>

      <main className="container mx-auto px-4 py-8">
        <div className="flex items-center justify-between mb-8">
          <div>
            <h2 className="text-3xl font-bold mb-2">All Quizzes</h2>
            <p className="text-muted-foreground">Create and explore multiple choice quizzes</p>
          </div>
          <Button
            onClick={() => navigate("/create-quiz")}
            className="bg-gradient-primary hover:opacity-90 transition-opacity"
          >
            <Plus className="h-4 w-4 mr-2" />
            Create Quiz
          </Button>
        </div>

        {quizzes.length === 0 ? (
          <Card className="text-center py-12 shadow-card">
            <CardContent>
              <div className="flex justify-center mb-4">
                <div className="h-16 w-16 rounded-full bg-muted flex items-center justify-center">
                  <FileQuestion className="h-8 w-8 text-muted-foreground" />
                </div>
              </div>
              <h3 className="text-xl font-semibold mb-2">No quizzes yet</h3>
              <p className="text-muted-foreground mb-4">
                Get started by creating your first quiz!
              </p>
              <Button
                onClick={() => navigate("/create-quiz")}
                className="bg-gradient-primary hover:opacity-90 transition-opacity"
              >
                <Plus className="h-4 w-4 mr-2" />
                Create Your First Quiz
              </Button>
            </CardContent>
          </Card>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {quizzes.map((quiz) => (
              <Card
                key={quiz.id}
                className="shadow-card hover:shadow-card-hover transition-all duration-300 cursor-pointer hover:scale-105"
                onClick={() => handleQuizClick(quiz.id)}
              >
                <CardHeader>
                  <CardTitle className="line-clamp-2">{quiz.title}</CardTitle>
                  <CardDescription className="line-clamp-3">{quiz.description}</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="flex items-center justify-between text-sm text-muted-foreground">
                    <span>{quiz.questions.length} questions</span>
                    <span className="text-xs">
                      {new Date(quiz.createdAt).toLocaleDateString()}
                    </span>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        )}
      </main>
    </div>
  );
};

export default Home;
