from sqlalchemy.orm import Session
from fastapi import HTTPException
from app.models.follower import Follower
from app.schemas.follower import FollowerCreate, FollowerUpdate
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import func

# get data -----------------------------------------------------------------------------------------------------------
async def get_all_followers(db: Session) -> list:
    return db.query(Follower).all()

async def get_followers_by_user_email(db: Session, user_email: str) -> list:
    return db.query(Follower).filter(Follower.user_email == user_email).all()

async def get_followers_by_artist_id(db: Session, artist_id: int) -> list:
    return db.query(Follower).filter(Follower.artist_id == artist_id).all()

async def get_follower_by_user_email_artist_id(db: Session, user_email: str, artist_id: int):
    return db.query(Follower).filter(Follower.user_email == user_email, Follower.artist_id == artist_id).first()

# create data -----------------------------------------------------------------------------------------------------------
async def create_follower(db: Session, new_follower: FollowerCreate) -> Follower:
    # Kiểm tra nếu new_follower là None
    if not new_follower:
        raise HTTPException(status_code=400, detail="Invalid new_follower data")
    
    # Kiểm tra nếu new_follower.user_email là None
    if not new_follower.user_email.strip():
        raise HTTPException(status_code=400, detail="Invalid new_follower.user_email data")
    
    # Kiểm tra nếu new_follower.artist_id là None
    if not new_follower.artist_id:
        raise HTTPException(status_code=400, detail="Invalid new_follower.artist_id data")
    
    # Tạo Follower mới và thêm vào cơ sở dữ liệu
    try:
        create_follower = Follower(
        user_email=new_follower.user_email,
        artist_id=new_follower.artist_id
        )
        db.add(create_follower)
        db.commit()
        db.refresh(create_follower)
        return create_follower
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to create the follower")
    
# update data -----------------------------------------------------------------------------------------------------------


# delete data -----------------------------------------------------------------------------------------------------------
async def delete_follower_by_user_email_artist_id(db: Session, user_email: str, artist_id: int):
    try:
        delete_follower = db.query(Follower).filter(Follower.user_email == user_email, Follower.artist_id == artist_id).first()
        if delete_follower is None:
            raise HTTPException(status_code=404, detail="Follower not found")
        else:
            db.delete(delete_follower)
            db.commit()
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to delete the follower")
    