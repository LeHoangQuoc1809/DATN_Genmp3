from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.schemas import playlist_user
from app.core.connectdb import get_db
from app.services import playlist_user_service

router = APIRouter()

# get data -----------------------------------------------------------------------------------------------------------
@router.get("/", response_model=list[playlist_user.PlaylistUserBase])
async def get_all_playlist_users(db: Session = Depends(get_db)):
    playlist_users = await playlist_user_service.get_all_playlist_users(db)
    return playlist_users 

@router.get("/get-playlist-user-by-id/{id}", response_model=playlist_user.PlaylistUserBase)
async def get_playlist_user_by_id(id: int, db: Session = Depends(get_db)):
    playlist_user = await playlist_user_service.get_playlist_user_by_id(db, id)
    if playlist_user is None:
        raise HTTPException(status_code=404, detail="Playlist_User not found")
    return playlist_user

@router.get("/get-playlist-users-by-user-email/{user_email}", response_model=list[playlist_user.PlaylistUserBase])
async def get_playlist_users_by_user_email(user_email: str, db: Session = Depends(get_db)):
    playlist_users = await playlist_user_service.get_playlist_users_by_user_email(db, user_email)
    return playlist_users
 
@router.get("/get-playlist-users-by-playlist-id/{playlist_id}", response_model=list[playlist_user.PlaylistUserBase])
async def get_playlist_users_by_playlist_id(playlist_id: int, db: Session = Depends(get_db)):
    playlist_user = await playlist_user_service.get_playlist_users_by_playlist_id(db, playlist_id)
    return playlist_user

@router.get("/get-playlist-user-by-user-email-playlist-id/{user_email}/{playlist_id}", response_model=playlist_user.PlaylistUserBase)
async def get_playlist_user_by_user_email_playlist_id(user_email: str, playlist_id:int, db: Session = Depends(get_db)):
    playlist_user = await playlist_user_service.get_playlist_user_by_user_email_playlist_id(db, user_email, playlist_id)
    if playlist_user is None:
        raise HTTPException(status_code=404, detail="Playlist_User not found")
    return playlist_user

# post data -----------------------------------------------------------------------------------------------------------
@router.post("/create-playlist-user/", response_model=playlist_user.PlaylistUserBase)
async def create_playlist_user(new_playlist_user: playlist_user.PlaylistUserCreate, db: Session = Depends(get_db)):
    try:
        create_playlist_user = await playlist_user_service.create_playlist_user(db, new_playlist_user)
        if create_playlist_user is None:
            raise HTTPException(status_code=500, detail="Failed to create playlist_user")
        return create_playlist_user
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# put data -----------------------------------------------------------------------------------------------------------
@router.put("/update-playlist-user-by-user-email-playlist-id/{user_email}/{playlist_id}", response_model=playlist_user.PlaylistUserBase)
async def update_playlist_user_by_user_email_playlist_id(user_email: str, playlist_id: int, new_playlist_user: playlist_user.PlaylistUserUpdate, db: Session = Depends(get_db)):
    try:
        update_playlist_user = await playlist_user_service.update_playlist_user_by_user_email_playlist_id(db, user_email, playlist_id, new_playlist_user)
        if update_playlist_user is None:
            raise HTTPException(status_code=404, detail="Playlist_User not found")
        return update_playlist_user
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# delete data -----------------------------------------------------------------------------------------------------------
@router.delete("/delete-playlist-user-by-user-email-playlist-id/{user_email}/{playlist_id}", status_code=200)
async def delete_playlist_user_by_user_email_playlist_id(user_email: str, playlist_id: int, db: Session = Depends(get_db)):
    try:
        await playlist_user_service.delete_playlist_user_by_user_email_playlist_id(db, user_email, playlist_id)
        return {"detail": "Playlist_User deleted successfully"}
    except HTTPException as e:
        raise e 
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    