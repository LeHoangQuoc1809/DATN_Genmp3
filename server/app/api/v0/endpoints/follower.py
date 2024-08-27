from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.schemas import follower
from app.core.connectdb import get_db
from app.services import follower_service

router = APIRouter()

# get data -----------------------------------------------------------------------------------------------------------
@router.get("/", response_model=list[follower.FollowerBase])
async def get_all_followers(db: Session = Depends(get_db)):
    followers = await follower_service.get_all_followers(db)
    return followers 
 
@router.get("/get-followers-by-user-email/{user_email}", response_model=list[follower.FollowerBase])
async def get_followers_by_user_email(user_email: str, db: Session = Depends(get_db)):
    followers = await follower_service.get_followers_by_user_email(db, user_email)
    return followers
 
@router.get("/get-followers-by-artist-id/{artist_id}", response_model=list[follower.FollowerBase])
async def get_followers_by_artist_id(artist_id: int, db: Session = Depends(get_db)):
    followers = await follower_service.get_followers_by_artist_id(db, artist_id)
    return followers

@router.get("/get-follower-by-user-email-artist-id/{user_email}/{artist_id}", response_model=follower.FollowerBase)
async def get_follower_by_user_email_artist_id(user_email: str, artist_id:int, db: Session = Depends(get_db)):
    follower = await follower_service.get_follower_by_user_email_artist_id(db, user_email, artist_id)
    if follower is None:
        raise HTTPException(status_code=404, detail="Follower not found")
    return follower

# post data -----------------------------------------------------------------------------------------------------------
@router.post("/create-follower/", response_model=follower.FollowerBase)
async def create_follower(new_follower: follower.FollowerCreate, db: Session = Depends(get_db)):
    try:
        create_follower = await follower_service.create_follower(db, new_follower)
        if create_follower is None:
            raise HTTPException(status_code=500, detail="Failed to create follower")
        return create_follower
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# put data -----------------------------------------------------------------------------------------------------------


# delete data -----------------------------------------------------------------------------------------------------------
@router.delete("/delete-follower-by-user-email-artist-id/{user_email}/{artist_id}", status_code=200)
async def delete_follower_by_user_email_artist_id(user_email: str, artist_id: int, db: Session = Depends(get_db)):
    try:
        await follower_service.delete_follower_by_user_email_artist_id(db, user_email, artist_id)
        return {"detail": "Follower deleted successfully"}
    except HTTPException as e:
        raise e 
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    