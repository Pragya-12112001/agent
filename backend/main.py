# backend/main.py
from fastapi import FastAPI
from pydantic import BaseModel
from db import get_connection
from query_engine import question_to_sql, format_answer
from mysql.connector import Error
from fastapi.middleware.cors import CORSMiddleware

origins = ["http://localhost:3000"]  # React frontend
app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class QueryRequest(BaseModel):
    question: str

@app.get("/")
def root():
    return {"message": "Backend connected ..."}

@app.post("/query")
def query_db(req: QueryRequest):
    sql = question_to_sql(req.question)
    if not sql:
        return {
            "question": req.question,
            "error": "I cannot understand this question yet.",
            "answer": None,
            "chart": None,
            "table": []
        }

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(sql)
    rows = cursor.fetchall()
    cursor.close()
    conn.close()

    result = format_answer(sql, rows)

    return {
        "question": req.question,
        "sql": sql.strip(),
        "table": rows,
        "answer": result["answer"],   # fixed key
        "chart": result["chart"]
    }
