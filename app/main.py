from fastapi import FastAPI, HTTPException

app = FastAPI()

@app.get("/success")
def get_success():
    return {"status": "ok", "message": "Valid response"}

@app.get("/bad-request")
def get_bad_request():
    raise HTTPException(status_code=400, detail="Bad Request Example")

@app.get("/error")
def get_error():
    raise HTTPException(status_code=500, detail="Internal Server Error Example")