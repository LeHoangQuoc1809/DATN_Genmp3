from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from app.api.v0.api_v0 import api_router
from fastapi.staticfiles import StaticFiles

import os
import librosa
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.svm import SVC
import joblib

from pydantic import BaseModel

from nltk.tokenize import word_tokenize
from sklearn.metrics import accuracy_score
from sklearn.feature_extraction.text import TfidfVectorizer
import pandas as pd
import re
from sklearn.naive_bayes import MultinomialNB
from sklearn.pipeline import make_pipeline
from typing import List
from scipy.interpolate import interp1d

from app.services.ai_service import genre_model, topic_model

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Cho phép tất cả các domain
    allow_credentials=True,
    allow_methods=["*"],  # Cho phép tất cả phương thức
    allow_headers=["*"],  # Cho phép tất cả headers
)

# Mount static files directory
app.mount("/static/images/album", StaticFiles(directory="app/uploads/images/album"), name="images")
app.mount("/static/images/artist", StaticFiles(directory="app/uploads/images/artist"), name="images")
app.mount("/static/images/playlist", StaticFiles(directory="app/uploads/images/playlist"), name="images")
app.mount("/static/images/song", StaticFiles(directory="app/uploads/images/song"), name="images")
app.mount("/static/images/user", StaticFiles(directory="app/uploads/images/user"), name="images")
app.mount("/static/mp3/song", StaticFiles(directory="app/uploads/mp3/song"), name="mp3")
app.mount("/static/mp3/user_upload_song", StaticFiles(directory="app/uploads/mp3/user_upload_song"), name="mp3")
app.mount("/static/lyrics", StaticFiles(directory="app/uploads/lyrics"), name="lyrics")
app.mount("/static/defaults", StaticFiles(directory="app/uploads/defaults"), name="defaults")

@app.get("/")
def read_root():
    return {"message": "Welcome to the API"}

@app.on_event("startup")
async def startup_event():
    await genre_model()
    await topic_model()

app.include_router(api_router, prefix="/api/v0")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000, workers=12)
