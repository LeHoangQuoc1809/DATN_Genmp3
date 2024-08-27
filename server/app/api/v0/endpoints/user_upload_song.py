from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.schemas import user_upload_song
from app.core.connectdb import get_db
from app.services import user_upload_song_service

router = APIRouter()

# get data -----------------------------------------------------------------------------------------------------------
@router.get("/", response_model=list[user_upload_song.UserUploadSongBase])
async def get_all_user_upload_songs(db: Session = Depends(get_db)):
    user_upload_songs = await user_upload_song_service.get_all_user_upload_songs(db)
    return user_upload_songs  

@router.get("/get-user-upload-song-by-id/{id}", response_model=user_upload_song.UserUploadSongBase)
async def get_user_upload_song_by_id(id: int, db: Session = Depends(get_db)):
    user_upload_song = await user_upload_song_service.get_user_upload_song_by_id(db, id)
    if user_upload_song is None:
        raise HTTPException(status_code=404, detail="User_upload_song not found")
    return user_upload_song

@router.get("/get-user-upload-songs-by-user-email/{user_email}", response_model=list[user_upload_song.UserUploadSongBase])
async def get_user_upload_songs_by_user_email(user_email: str, db: Session = Depends(get_db)):
    user_upload_songs = await user_upload_song_service.get_user_upload_songs_by_user_email(db, user_email)
    return user_upload_songs

# post data -----------------------------------------------------------------------------------------------------------
@router.post("/create-user-upload-song/", response_model=user_upload_song.UserUploadSongBase)
async def create_user_upload_song(new_user_upload_song: user_upload_song.UserUploadSongCreate, db: Session = Depends(get_db)):
    try:
        create_user_upload_song = await user_upload_song_service.create_user_upload_song(db, new_user_upload_song)
        if create_user_upload_song is None:
            raise HTTPException(status_code=500, detail="Failed to create user_upload_song")
        return create_user_upload_song
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# put data -----------------------------------------------------------------------------------------------------------


# delete data -----------------------------------------------------------------------------------------------------------
@router.delete("/delete-user-upload-song-by-id-user-email/{id}/{user_email}", status_code=200)
async def delete_user_upload_song_by_id_user_email(id: int, user_email:str, db: Session = Depends(get_db)):
    try:
        await user_upload_song_service.delete_user_upload_song_by_id_user_email(db, id, user_email)
        return {"detail": "User_upload_song deleted successfully"}
    except HTTPException as e:
        raise e 
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    
    
    