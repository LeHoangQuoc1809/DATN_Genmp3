from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.schemas import recommended_playlist
from app.core.connectdb import get_db
from app.services import recommended_playlist_service

router = APIRouter()

# get data -----------------------------------------------------------------------------------------------------------
@router.get("/", response_model=list[recommended_playlist.RecommendedPlaylistBase])
async def get_all_recommended_playlists(db: Session = Depends(get_db)):
    recommended_playlists = await recommended_playlist_service.get_all_recommended_playlists(db)
    return recommended_playlists 

@router.get("/get-recommended-playlist-by-id/{id}", response_model=recommended_playlist.RecommendedPlaylistBase)
async def get_recommended_playlist_by_id(id: int, db: Session = Depends(get_db)):
    recommended_playlist = await recommended_playlist_service.get_recommended_playlist_by_id(db, id)
    if recommended_playlist is None:
        raise HTTPException(status_code=404, detail="Recommended_Playlist not found")
    return recommended_playlist

@router.get("/get-recommended-playlists-by-user-email/{user_email}", response_model=list[recommended_playlist.RecommendedPlaylistBase])
async def get_recommended_playlists_by_user_email(user_email: str, db: Session = Depends(get_db)):
    recommended_playlists = await recommended_playlist_service.get_recommended_playlists_by_user_email(db, user_email)
    return recommended_playlists
 
@router.get("/get-recommended-playlists-by-playlist-id/{playlist_id}", response_model=list[recommended_playlist.RecommendedPlaylistBase])
async def get_recommended_playlists_by_playlist_id(playlist_id: int, db: Session = Depends(get_db)):
    recommended_playlist = await recommended_playlist_service.get_recommended_playlists_by_playlist_id(db, playlist_id)
    return recommended_playlist

@router.get("/get-recommended-playlist-by-user-email-playlist-id/{user_email}/{playlist_id}", response_model=recommended_playlist.RecommendedPlaylistBase)
async def get_recommended_playlist_by_user_email_playlist_id(user_email: str, playlist_id:int, db: Session = Depends(get_db)):
    recommended_playlist = await recommended_playlist_service.get_recommended_playlist_by_user_email_playlist_id(db, user_email, playlist_id)
    if recommended_playlist is None:
        raise HTTPException(status_code=404, detail="Recommended_Playlist not found")
    return recommended_playlist

# post data -----------------------------------------------------------------------------------------------------------
@router.post("/create-recommended-playlist/", response_model=recommended_playlist.RecommendedPlaylistBase)
async def create_recommended_playlist(new_recommended_playlist: recommended_playlist.RecommendedPlaylistCreate, db: Session = Depends(get_db)):
    try:
        create_recommended_playlist = await recommended_playlist_service.create_recommended_playlist(db, new_recommended_playlist)
        if create_recommended_playlist is None:
            raise HTTPException(status_code=500, detail="Failed to create recommended_playlist")
        return create_recommended_playlist
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# put data -----------------------------------------------------------------------------------------------------------
@router.put("/update-recommended-playlist-by-user-email-playlist-id/{user_email}/{playlist_id}", response_model=recommended_playlist.RecommendedPlaylistUpdate)
async def update_recommended_playlist_by_user_email_playlist_id(user_email: str, playlist_id: int, new_recommended_playlist: recommended_playlist.RecommendedPlaylistUpdate, db: Session = Depends(get_db)):
    try:
        update_recommended_playlist = await recommended_playlist_service.update_recommended_playlist_by_user_email_playlist_id(db, user_email, playlist_id, new_recommended_playlist)
        if update_recommended_playlist is None:
            raise HTTPException(status_code=404, detail="Recommended_Playlist not found")
        return update_recommended_playlist
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# delete data -----------------------------------------------------------------------------------------------------------
@router.delete("/delete-recommended-playlist-by-user-email-playlist-id/{user_email}/{playlist_id}", status_code=200)
async def delete_recommended_playlist_by_user_email_playlist_id(user_email: str, playlist_id: int, db: Session = Depends(get_db)):
    try:
        await recommended_playlist_service.delete_recommended_playlist_by_user_email_playlist_id(db, user_email, playlist_id)
        return {"detail": "Recommended_Playlist deleted successfully"}
    except HTTPException as e:
        raise e 
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    