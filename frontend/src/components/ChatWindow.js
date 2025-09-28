import React, { useState } from "react";
import axios from "axios";
import { Bar, Pie } from "react-chartjs-2";
import "chart.js/auto";
import LoadingSkeleton from "./LoadingSkeleton";
import Header from "./Header";

const ChatWindow = () => {
  const [question, setQuestion] = useState("");
  const [response, setResponse] = useState(null);
  const [loading, setLoading] = useState(false);
  const [filters, setFilters] = useState({
    region: "",
    category: "",
    startDate: "",
    endDate: "",
  });

  const askQuestion = async () => {
    if (!question.trim()) return;
    setLoading(true);

    // Append filters to question
    let filterText = "";
    if (filters.region) filterText += ` in region ${filters.region}`;
    if (filters.category) filterText += ` for category ${filters.category}`;
    if (filters.startDate && filters.endDate)
      filterText += ` from ${filters.startDate} to ${filters.endDate}`;

    try {
      const res = await axios.post("http://127.0.0.1:8000/query", {
        question: question + filterText,
      });
      console.log(res.data); 
      setResponse(res.data);
      setQuestion("");
    } catch (err) {
      setResponse({ answer: "Something went wrong!" });
    } finally {
      setLoading(false);
    }
  };

  const renderChart = () => {
    if (!response?.chart) return null;

    const chartData = {
      labels: response.chart.labels,
      datasets: [
        {
          label: "Values",
          data: response.chart.values,
          backgroundColor: [
            "#1F2937", // dark gray
            "#3B82F6", // blue
            "#F59E0B", // amber
            "#EF4444", // red
            "#10B981", // green
          ],
        },
      ],
    };

    if (response.chart.type === "bar") return <Bar data={chartData} />;
    if (response.chart.type === "pie") return <Pie data={chartData} />;
    return null;
  };

  // Get max/min for highlighting
  const getHighlightValue = (table) => {
    if (!table || table.length === 0) return {};
    let values = table
      .map((row) => Object.values(row).filter((v) => typeof v === "number"))
      .flat();
    return { max: Math.max(...values), min: Math.min(...values) };
  };

  const highlights = getHighlightValue(response?.table);

  return (
    <div className="w-full max-w-4xl mx-auto mt-8">
      <Header/> 
      {/* Filters */}
      <div className="flex gap-2 mb-4 flex-wrap">
        <input
          type="text"
          placeholder="Region"
          className="p-2 border rounded"
          value={filters.region}
          onChange={(e) =>
            setFilters({ ...filters, region: e.target.value })
          }
        />
        <input
          type="text"
          placeholder="Category"
          className="p-2 border rounded"
          value={filters.category}
          onChange={(e) =>
            setFilters({ ...filters, category: e.target.value })
          }
        />
        <input
          type="date"
          placeholder="Start Date"
          className="p-2 border rounded"
          value={filters.startDate}
          onChange={(e) =>
            setFilters({ ...filters, startDate: e.target.value })
          }
        />
        <input
          type="date"
          placeholder="End Date"
          className="p-2 border rounded"
          value={filters.endDate}
          onChange={(e) =>
            setFilters({ ...filters, endDate: e.target.value })
          }
        />
      </div>

      {/* Question input */}
      <div className="flex mb-4">
        <input
          type="text"
          value={question}
          onChange={(e) => setQuestion(e.target.value)}
          placeholder="Ask your question..."
          className="flex-1 p-3 rounded-l-lg border border-gray-300 focus:outline-none"
        />
        <button
          onClick={askQuestion}
          className="bg-blue-600 text-white px-4 rounded-r-lg hover:bg-blue-700"
        >
          {loading ? "Loading..." : "Ask"}
        </button>
      </div>

      {/* Loading */}
      {loading && (
        <LoadingSkeleton />
      )}

      {/* Response */}
      {!loading && response && (
        <div className="bg-white p-6 rounded-lg shadow-lg mt-4 transition-all duration-500">
          {/* Show Question */}
          {response.question && (
            <p className="text-gray-700 mb-2">
              <span className="font-semibold">Question:</span>{" "}
              {response.question}
            </p>
          )}

          {/* Show Answer or Error */}
          {response?.error ? (
            <p className="text-lg font-semibold mb-4 text-red-600">
              {response.error}
            </p>
          ) : (
            <p className="text-lg font-semibold mb-4 text-blue-700">
              {response.answer}
            </p>
          )}

          {/* SQL */}
          {response.sql &&
            <div className="my-6">
              <h2 className="text-xl font-semibold text-gray-700 mb-2">SQL:</h2>
              <pre className="bg-gray-100 p-4 rounded-lg text-sm overflow-x-auto">
                {response.sql}
              </pre>
            </div>
          }
          {/* Table with highlights */}
          {response.table && response.table.length > 0 && (
            <div className="mt-6 overflow-x-auto">
              <table className="min-w-full border border-gray-200">
                <thead className="bg-blue-100">
                  <tr>
                    {Object.keys(response.table[0]).map((key) => (
                      <th
                        key={key}
                        className="px-4 py-2 text-left text-gray-600"
                      >
                        {key}
                      </th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {response.table.map((row, idx) => (
                    <tr
                      key={idx}
                      className="border-t border-gray-200 hover:bg-gray-50"
                    >
                      {Object.values(row).map((val, i) => (
                        <td
                          key={i}
                          className={`px-4 py-2 ${
                            typeof val === "number"
                              ? val === highlights.max
                                ? "font-bold text-green-600"  
                                : val === highlights.min
                                ? "font-bold text-red-600"    
                                : ""
                              : ""
                          }`}
                        >
                          {val}
                        </td>
                      ))}
                    </tr>
                  ))}
                </tbody>
              </table>
              {/* Chart */}
              <div className="mt-10 ">
                {renderChart()}
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  );
};

export default ChatWindow;
