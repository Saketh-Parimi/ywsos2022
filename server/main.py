from fastapi import FastAPI, Request
from routers import posts
from routers import auth
import uvicorn
from fastapi.responses import JSONResponse 
from fastapi.middleware.cors import CORSMiddleware

from config import settings

app = FastAPI()
app.add_middleware(CORSMiddleware, allow_methods=['*'], allow_headers=['*'], allow_credentials=True, allow_origins=['*'])
app.include_router(posts.router, tags=["Posts"], prefix="/api/posts")
app.include_router(auth.router, tags=["Authentication"], prefix="/api/auth")
@app.get('/')
def index():
    return {'message': f'welcome to youngwonks'}

if __name__ == '__main__':
    uvicorn.run("main:app", host="127.0.0.1", port=8000, log_level="info", reload=True)