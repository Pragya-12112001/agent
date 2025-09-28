// frontend/src/components/QuestionInput.js
import React, { useState } from "react";

const QuestionInput = ({ onAsk }) => {
  const [question, setQuestion] = useState("");

  const handleAsk = () => {
    if (question.trim() === "") return;
    onAsk(question);
    setQuestion("");
  };

  return (
    <div className="flex mb-4">
      <input
        type="text"
        value={question}
        onChange={(e) => setQuestion(e.target.value)}
        placeholder="Ask your question..."
        className="flex-1 p-3 rounded-l-lg border border-gray-300 focus:outline-none"
      />
      <button
        onClick={handleAsk}
        className="bg-blue-600 text-white px-4 rounded-r-lg hover:bg-blue-700"
      >
        Ask
      </button>
    </div>
  );
};

export default QuestionInput;
