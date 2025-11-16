import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { getCurrentUser, saveQuiz } from "@/lib/storage";
import { Quiz, QuizQuestion, QuizChoice } from "@/types/quiz";
import { toast } from "sonner";
import { Plus, Trash2, ArrowLeft, Save } from "lucide-react";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";

const CreateQuiz = () => {
  const navigate = useNavigate();
  const currentUser = getCurrentUser();

  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [questions, setQuestions] = useState<QuizQuestion[]>([
    {
      id: crypto.randomUUID(),
      text: "",
      choices: [
        { id: crypto.randomUUID(), text: "" },
        { id: crypto.randomUUID(), text: "" },
        { id: crypto.randomUUID(), text: "" },
      ],
      correctAnswerIndex: 0,
    },
  ]);

  if (!currentUser) {
    navigate("/");
    return null;
  }

  const addQuestion = () => {
    setQuestions([
      ...questions,
      {
        id: crypto.randomUUID(),
        text: "",
        choices: [
          { id: crypto.randomUUID(), text: "" },
          { id: crypto.randomUUID(), text: "" },
          { id: crypto.randomUUID(), text: "" },
        ],
        correctAnswerIndex: 0,
      },
    ]);
  };

  const removeQuestion = (questionId: string) => {
    if (questions.length === 1) {
      toast.error("Quiz must have at least one question");
      return;
    }
    setQuestions(questions.filter((q) => q.id !== questionId));
  };

  const updateQuestion = (questionId: string, text: string) => {
    setQuestions(
      questions.map((q) => (q.id === questionId ? { ...q, text } : q))
    );
  };

  const addChoice = (questionId: string) => {
    setQuestions(
      questions.map((q) =>
        q.id === questionId
          ? {
              ...q,
              choices: [...q.choices, { id: crypto.randomUUID(), text: "" }],
            }
          : q
      )
    );
  };

  const removeChoice = (questionId: string, choiceId: string) => {
    setQuestions(
      questions.map((q) => {
        if (q.id === questionId) {
          if (q.choices.length <= 2) {
            toast.error("Question must have at least 2 choices");
            return q;
          }
          return {
            ...q,
            choices: q.choices.filter((c) => c.id !== choiceId),
          };
        }
        return q;
      })
    );
  };

  const updateChoice = (questionId: string, choiceId: string, text: string) => {
    setQuestions(
      questions.map((q) =>
        q.id === questionId
          ? {
              ...q,
              choices: q.choices.map((c) => (c.id === choiceId ? { ...c, text } : c)),
            }
          : q
      )
    );
  };

  const setCorrectAnswer = (questionId: string, index: number) => {
    setQuestions(
      questions.map((q) =>
        q.id === questionId ? { ...q, correctAnswerIndex: index } : q
      )
    );
  };

  const handleSave = () => {
    if (!title.trim()) {
      toast.error("Please enter a quiz title");
      return;
    }

    if (!description.trim()) {
      toast.error("Please enter a quiz description");
      return;
    }

    for (const question of questions) {
      if (!question.text.trim()) {
        toast.error("All questions must have text");
        return;
      }

      if (question.choices.length < 2) {
        toast.error("Each question must have at least 2 choices");
        return;
      }

      for (const choice of question.choices) {
        if (!choice.text.trim()) {
          toast.error("All choices must have text");
          return;
        }
      }
    }

    const newQuiz: Quiz = {
      id: crypto.randomUUID(),
      title,
      description,
      questions,
      createdBy: currentUser.id,
      createdAt: new Date().toISOString(),
    };

    saveQuiz(newQuiz);
    toast.success("Quiz created successfully!");
    navigate("/home");
  };

  return (
    <div className="min-h-screen bg-gradient-bg py-8">
      <div className="container mx-auto px-4 max-w-4xl">
        <div className="mb-6 flex items-center justify-between">
          <Button variant="outline" onClick={() => navigate("/home")}>
            <ArrowLeft className="h-4 w-4 mr-2" />
            Back
          </Button>
          <Button
            onClick={handleSave}
            className="bg-gradient-primary hover:opacity-90 transition-opacity"
          >
            <Save className="h-4 w-4 mr-2" />
            Save Quiz
          </Button>
        </div>

        <Card className="mb-6 shadow-card">
          <CardHeader>
            <CardTitle>Quiz Details</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="title">Quiz Title</Label>
              <Input
                id="title"
                placeholder="Enter quiz title"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="description">Description</Label>
              <Textarea
                id="description"
                placeholder="Enter quiz description"
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                rows={3}
              />
            </div>
          </CardContent>
        </Card>

        <div className="space-y-6">
          {questions.map((question, qIndex) => (
            <Card key={question.id} className="shadow-card">
              <CardHeader>
                <div className="flex items-center justify-between">
                  <CardTitle className="text-lg">Question {qIndex + 1}</CardTitle>
                  <Button
                    variant="destructive"
                    size="sm"
                    onClick={() => removeQuestion(question.id)}
                  >
                    <Trash2 className="h-4 w-4" />
                  </Button>
                </div>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <Label>Question Text</Label>
                  <Input
                    placeholder="Enter your question"
                    value={question.text}
                    onChange={(e) => updateQuestion(question.id, e.target.value)}
                  />
                </div>

                <div className="space-y-3">
                  <Label>Choices (select the correct answer)</Label>
                  <RadioGroup
                    value={question.correctAnswerIndex.toString()}
                    onValueChange={(value) =>
                      setCorrectAnswer(question.id, parseInt(value))
                    }
                  >
                    {question.choices.map((choice, cIndex) => (
                      <div key={choice.id} className="flex items-center gap-3">
                        <RadioGroupItem value={cIndex.toString()} id={choice.id} />
                        <Input
                          placeholder={`Choice ${cIndex + 1}`}
                          value={choice.text}
                          onChange={(e) =>
                            updateChoice(question.id, choice.id, e.target.value)
                          }
                          className="flex-1"
                        />
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => removeChoice(question.id, choice.id)}
                        >
                          <Trash2 className="h-4 w-4" />
                        </Button>
                      </div>
                    ))}
                  </RadioGroup>
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={() => addChoice(question.id)}
                  >
                    <Plus className="h-4 w-4 mr-2" />
                    Add Choice
                  </Button>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>

        <Button
          onClick={addQuestion}
          variant="outline"
          className="w-full mt-6"
        >
          <Plus className="h-4 w-4 mr-2" />
          Add Question
        </Button>
      </div>
    </div>
  );
};

export default CreateQuiz;
