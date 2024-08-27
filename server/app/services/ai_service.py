from fastapi import FastAPI, HTTPException
import base64
import os
import librosa
import numpy as np
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.svm import SVC
import joblib
from pydantic import BaseModel
from datetime import datetime 
from nltk.tokenize import word_tokenize
import nltk
# nltk.download('punkt')
from sklearn.metrics import accuracy_score
from sklearn.feature_extraction.text import TfidfVectorizer
import pandas as pd
import re
from sklearn.naive_bayes import MultinomialNB
from sklearn.pipeline import make_pipeline
from typing import List
from scipy.interpolate import interp1d
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

###########################################################################################################################
def load_vietnamese_stopwords(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        stopwords = f.read().splitlines()
    return set(stopwords)

filepath_stop_words = os.path.join(os.path.dirname(__file__), '..', 'ai', 'vietnamese_stopwords.txt')
stop_words = load_vietnamese_stopwords(filepath_stop_words)

# Đường dẫn đến thư mục chứa các file lyric
# lyric_directory = 'D:\\University\\HK8\\LuanVanTotNghiep\\training-data\\lyric-topic'
# categories = ['Tinh_Yeu_Lang_Man', 'Chia_Tay_Tan_Vo', 'Tinh_Yeu_Don_Phuong', 'Tinh_Ban', 'Tinh_Cam_Gia_Dinh', 'Tinh_Yeu_Que_Huong', 'Hanh_Trinh_Trai_Nghiem', 'Triet_Ly_Song']

# Đường dẫn lưu mô hình
model_path_topic = os.path.join(os.path.dirname(__file__), '..', 'ai', 'svm_topic_model.joblib')

topic_model = None
# Khởi tạo hoặc tải mô hình
async def topic_model():
    if os.path.exists(model_path_topic):
        global topic_model
        topic_model = joblib.load(model_path_topic)
    else:
         # Thay đổi đường dẫn này thành đường dẫn thực tế của thư mục chứa các chủ đề của bạn
        directory_path = 'D:\\University\\HK8\\LuanVanTotNghiep\\training-data\\lyric-topic'
        print(" @@@@@@@@@@@@@@@@ START TOPIC Model @@@@@@@@@@@@@@@@")
        topic_model = train_topic_model(directory_path)
        print(" @@@@@@@@@@@@@@@@ Finish Topic Model @@@@@@@@@@@@@@@@")
        print(" @@@@@@@@@@@@@@@@ Finish Topic Model @@@@@@@@@@@@@@@@")
        print(" @@@@@@@@@@@@@@@@ Finish Topic Model @@@@@@@@@@@@@@@@")

def preprocess_text(text):
    try:
        # Chuyển đổi văn bản thành chữ thường
        text = text.lower()
        # Loại bỏ các ký tự không phải chữ
        text = re.sub(r'[^a-zA-Z\sÀ-ỹ]', '', text)
        # Tách từ
        words = word_tokenize(text)
        # Loại bỏ stopwords
        words = [word for word in words if word not in stop_words]
        # Gộp các từ lại thành văn bản đã được xử lý
        return ' '.join(words)
    except Exception as e:
        print(f'===============preprocess_text===================: \n{e}')

# Hàm đọc dữ liệu từ cây thư mục
def read_data_from_directory(directory_path: str):
    texts = []
    labels = []
    for root, dirs, files in os.walk(directory_path):
        for file in files:
            if file.endswith(".txt"):
                file_path = os.path.join(root, file)
                with open(file_path, 'r', encoding='utf-8') as f:
                    text = f.read()
                    # Tiền xử lý văn bản
                    processed_text = preprocess_text(text)
                    texts.append(processed_text)
                    # Nhãn là tên thư mục cha
                    label = os.path.basename(root)
                    labels.append(label)
    return texts, labels

def train_topic_model(directory_path: str):
    texts, labels = read_data_from_directory(directory_path)
    # Chia dữ liệu thành tập huấn luyện và tập kiểm tra
    # X_train, X_test, y_train, y_test = train_test_split(texts, labels, test_size=0, random_state=42)
    
    # Tạo pipeline với TfidfVectorizer và MultinomialNB
    pipeline = make_pipeline(TfidfVectorizer(), MultinomialNB())
    param_grid = {
        'tfidfvectorizer__ngram_range': [(1, 1), (1, 2), (1, 3)],
        'tfidfvectorizer__max_df': [0.9, 0.95, 1.0],
        'tfidfvectorizer__min_df': [1, 2, 5],
        'multinomialnb__alpha': [0.1, 0.5, 1.0]
    }
    grid_search = GridSearchCV(pipeline, param_grid, cv=5, n_jobs=-1)
    # grid_search.fit(X_train, y_train)
    grid_search.fit(texts, labels)
    topic_model = grid_search.best_estimator_
    # topic_model.fit(X_train, y_train)
    topic_model.fit(texts, labels)
    
    # Dự đoán trên tập kiểm tra
    # y_pred = topic_model.predict(X_test)
    
    # Tính toán độ chính xác
    # accuracy = accuracy_score(y_test, y_pred)
    
    # Lưu mô hình
    joblib.dump(topic_model, model_path_topic)
    
    return topic_model

async def predict_topic_from_path(txt_base64: str):
    try:
        # Bước 1: Tiếp nhận và giải mã base64 string
        file_data = base64.b64decode(txt_base64)

        # Bước 2: Tạo đường dẫn tạm thời cho file
        file_name = f"topic_{datetime.now().strftime('%d-%m-%Y_%H-%M-%S-%f')}.txt"  # Có thể thay đổi đuôi file nếu cần thiết
        file_path = f"app/uploads/temp/{file_name}"

        # Tạo thư mục nếu chưa tồn tại
        os.makedirs(os.path.dirname(file_path), exist_ok=True)
            
        # Lưu file tạm thời
        with open(file_path, "wb") as f:
            f.write(file_data)
            print(f"Đã ghi file : {file_name}")

        global topic_model
        if topic_model is None:
            raise HTTPException(status_code=500, detail="Model not trained yet")
        if not os.path.exists(file_path):
            raise HTTPException(status_code=404, detail="File not found")

        with open(file_path, 'r', encoding='utf-8') as file:
            text = file.read()
            print(f"File read successfully: {file_path}")

        # Bước 4: Xóa file sau khi hoàn thành công việc
        os.remove(file_path)
        print(f"Đã xóa file : {file_path}")

        processed_text = preprocess_text(text)
        proba  = topic_model.predict_proba([processed_text])[0]
        topic_probabilities = sorted(zip(topic_model.classes_, proba), key=lambda x: x[1], reverse=True)
        
        print(f'topic_probabilities in service: {topic_probabilities}')
        return {'topic_probabilities': topic_probabilities}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))  

###########################################################################################################################
parrent_path = 'D:\\Document\\HK8\\GenMp3\\training-data\\mp3\\'
vpop_directory = parrent_path + 'vpop'
ballad_directory = parrent_path + 'ballad'
bolero_directory = parrent_path + 'bolero'
edm_directory = parrent_path + 'edm'
rap_directory = parrent_path + 'rap'
rock_directory = parrent_path + 'rock'
model_path_genre = os.path.join(os.path.dirname(__file__), '..', 'ai', 'svm_genre_model.joblib')


def extract_features(file_path, num_mfcc=120, max_frames=2000):
    try:
        y, sr = librosa.load(file_path, sr=None)

        # Xác định thông số cho việc trích xuất đặc trưng MFCC
        mfcc = librosa.feature.mfcc(y=y, sr=sr, n_mfcc=num_mfcc)

        # If number of frames is less than max_frames, pad with zeros
        if mfcc.shape[1] < max_frames:
            pad_width = max_frames - mfcc.shape[1]
            mfcc = np.pad(mfcc, pad_width=((0, 0), (0, pad_width)), mode='constant')

        # Otherwise, truncate to max_frames
        else:
            mfcc = mfcc[:, :max_frames]

        return mfcc.flatten()
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return None

def train_genre_model():
    vpop_songs = [(os.path.join(vpop_directory, file), 'vpop') for file in os.listdir(vpop_directory)]
    ballad_songs = [(os.path.join(ballad_directory, file), 'ballad') for file in os.listdir(ballad_directory)]
    bolero_songs = [(os.path.join(bolero_directory, file), 'bolero') for file in os.listdir(bolero_directory)]
    edm_songs = [(os.path.join(edm_directory, file), 'edm') for file in os.listdir(edm_directory)]
    rap_songs = [(os.path.join(rap_directory, file), 'rap') for file in os.listdir(rap_directory)]
    rock_songs = [(os.path.join(rock_directory, file), 'rock') for file in os.listdir(rock_directory)]

    all_songs = vpop_songs + ballad_songs + bolero_songs + edm_songs + rap_songs + rock_songs

    X = []
    y = []
    for song, label in all_songs:
        features = extract_features(song)
        print(f"label: {label}")
        if features is not None:
            X.append(features)
            y.append(label)

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)
    genre_model = SVC(kernel='linear', probability=True)
    print("~ ~ ~ ~ START TRAIN MODEL ~ ~ ~ ~")
    genre_model.fit(X_train, y_train)
    print("~ ~ ~ ~ START TEST MODEL ~ ~ ~ ~")
    accuracy = genre_model.score(X_test, y_test)
    print("~ ~ ~ ~ START SAVE MODEL ~ ~ ~ ~")

    joblib.dump(genre_model, model_path_genre)
    print("~ ~ ~ ~ DONE ~ ~ ~ ~")

    return genre_model, accuracy

# Load or train the model at startup
genre_model = None
async def genre_model():
    if os.path.exists(model_path_genre):
        global genre_model
        genre_model = joblib.load(model_path_genre)
        # features = extract_features('D:\\Music\\Cảm Giác Không Phải Thực Tại.mp3')
        # probabilities = genre_model.predict_proba([features])[0]
        # genres = genre_model.classes_
        # genre_probabilities = sorted(zip(genres, probabilities), key=lambda x: x[1], reverse=True)
        # print(f"genre_probabilities: {genre_probabilities}")
    else:
        print(" @@@@@@@@@@@@@@@@ START GENRE Model @@@@@@@@@@@@@@@@")
        genre_model, accuracy = train_genre_model()
        print(" @@@@@@@@@@@@@@@@ Finish GENRE Model @@@@@@@@@@@@@@@@")
        print(" @@@@@@@@@@@@@@@@ Finish GENRE Model @@@@@@@@@@@@@@@@")
        print(" @@@@@@@@@@@@@@@@ Finish GENRE Model @@@@@@@@@@@@@@@@")
        print(f"Model trained at startup with accuracy: {accuracy}")

def api_train_genre_model():
    global genre_model
    genre_model, accuracy = train_genre_model()
    
    return {"accuracy": accuracy}

async def predict_genre_from_path(mp3_base64: str):
    try:
        # Bước 1: Tiếp nhận và giải mã base64 string
        file_data = base64.b64decode(mp3_base64)
        # Bước 2: Tạo đường dẫn tạm thời cho file

        file_name = f"genre_{datetime.now().strftime('%d-%m-%Y_%H-%M-%S-%f')}.mp3"  # Có thể thay đổi đuôi file nếu cần thiết
        file_path = f"app/uploads/temp/{file_name}"

        # Tạo thư mục nếu chưa tồn tại
        os.makedirs(os.path.dirname(file_path), exist_ok=True)
        
        # Lưu file tạm thời
        with open(file_path, "wb") as f:
            f.write(file_data)
            print(f"Đã ghi file : {file_name}")
        # Trích xuất đặc trưng
        features = extract_features(file_path)

        # Bước 4: Xóa file sau khi hoàn thành công việc
        os.remove(file_path)
        print(f"Đã xóa file : {file_path}")

        global genre_model
        if genre_model is None:
            return {"error": "Model not trained yet"}
        probabilities = genre_model.predict_proba([features])[0]
        genres = genre_model.classes_
        genre_probabilities = sorted(zip(genres, probabilities), key=lambda x: x[1], reverse=True)
        print(f'genre_probabilities in service: {genre_probabilities}')
        return {'genre_probabilities': genre_probabilities}
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    