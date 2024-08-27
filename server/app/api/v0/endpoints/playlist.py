from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.schemas import playlist
from app.core.connectdb import get_db
from app.services import playlist_service

router = APIRouter()

# get data -----------------------------------------------------------------------------------------------------------
@router.get("/", response_model=list[playlist.PlaylistBase])
async def get_all_playlists(db: Session = Depends(get_db)):
    playlists = await playlist_service.get_all_playlists(db)
    return playlists  

@router.get("/get-playlist-by-id/{id}", response_model=playlist.PlaylistBase)
async def get_playlist_by_id(id: int, db: Session = Depends(get_db)):
    playlist = await playlist_service.get_playlist_by_id(db, id)
    if playlist is None:
        raise HTTPException(status_code=404, detail="Playlist not found")
    return playlist

@router.get("/get-top-50-playlists-for-search/{key_word}", response_model=list[playlist.PlaylistBaseForSearch])
async def get_top_50_playlists_for_search(key_word: str, db: Session = Depends(get_db)):
    key_word = f"%{(key_word).lower()}%"
    playlists = await playlist_service.get_top_50_playlists_for_search(db, key_word)
    return playlists

@router.get("/get-all-playlists-by-user-email/{user_email}", response_model=list[playlist.PlaylistBaseForGetAllPlaylistsByUserEmail])
async def get_all_playlists_by_user_email(user_email: str, db: Session = Depends(get_db)):
    playlists = await playlist_service.get_all_playlists_by_user_email(db, user_email)
    return playlists

# post data -----------------------------------------------------------------------------------------------------------
@router.post("/create-playlist-for-admin-dashboard/", response_model=playlist.PlaylistBase)
async def create_playlist_for_admin_dashboard(new_playlist: playlist.PlaylistCreate, db: Session = Depends(get_db)):
    try:
        create_playlist = await playlist_service.create_playlist_for_admin_dashboard(db, new_playlist)
        if create_playlist is None:
            raise HTTPException(status_code=500, detail="Failed to create playlist")
        return create_playlist
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    
@router.post("/create-playlist-for-client/", response_model=playlist.PlaylistBaseForCreatePlaylistForClient)
async def create_playlist_for_client(new_playlist: playlist.PlaylistCreateForClient, db: Session = Depends(get_db)):
    try:
        create_playlist = await playlist_service.create_playlist_for_client(db, new_playlist)
        if create_playlist is None:
            raise HTTPException(status_code=500, detail="Failed to create playlist")
        return create_playlist
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# put data -----------------------------------------------------------------------------------------------------------
@router.put("/update-playlist-by-id/{id}", response_model=playlist.PlaylistBase)
async def update_playlist_by_id(id: int, new_playlist: playlist.PlaylistUpdate, db: Session = Depends(get_db)):
    try:
        update_playlist = await playlist_service.update_playlist_by_id(db, id, new_playlist)
        if update_playlist is None:
            raise HTTPException(status_code=404, detail="Playlist not found")
        return update_playlist
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# delete data -----------------------------------------------------------------------------------------------------------
@router.delete("/delete-playlist-by-id/{id}", status_code=200)
async def delete_playlist_by_id(id: int, db: Session = Depends(get_db)):
    try:
        await playlist_service.delete_playlist_by_id(db, id)
        return {"detail": "Playlist deleted successfully"}
    except HTTPException as e:
        raise e 
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")