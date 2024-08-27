from fastapi import APIRouter, Depends, HTTPException, Request
from app.services import ai_service

router = APIRouter()

# post data -----------------------------------------------------------------------------------------------------------
@router.post("/predict-genre/")
async def predict_genre_from_path(request: Request):
    try:
        data = await request.json()
        mp3_base64 = data.get("mp3_base64")
        prediction = await ai_service.predict_genre_from_path(mp3_base64)
        if prediction is None:
            raise HTTPException(status_code=500, detail="Failed to predict mp3_base64")
        print(f'prediction for mp3_base64 in endpoint: {prediction}')
        return prediction
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    
@router.post("/predict-topic/")
async def predict_topic_from_path(request: Request):
    try:
        data = await request.json()
        txt_base64 = data.get("txt_base64")
        prediction = await ai_service.predict_topic_from_path(txt_base64)
        if prediction is None:
            raise HTTPException(status_code=500, detail="Failed to predict txt_base64")
        print(f'prediction for txt_base64 in endpoint: {prediction}')
        return prediction
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")


    
    