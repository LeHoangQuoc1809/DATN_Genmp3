from sqlalchemy.orm import Session
from fastapi import HTTPException
from app.models.playlist_user import Playlist_User
from app.schemas.playlist_user import PlaylistUserCreate, PlaylistUserUpdate
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import func

# get data -----------------------------------------------------------------------------------------------------------
async def get_all_playlist_users(db: Session) -> list:
    return db.query(Playlist_User).all()

async def get_playlist_user_by_id(db: Session, id: int):
    return db.query(Playlist_User).filter(Playlist_User.id == id).first()

async def get_playlist_users_by_user_email(db: Session, user_email: str) -> list:
    return db.query(Playlist_User).filter(Playlist_User.user_email == user_email).all()

async def get_playlist_users_by_playlist_id(db: Session, playlist_id: int) -> list:
    return db.query(Playlist_User).filter(Playlist_User.playlist_id == playlist_id).all()

async def get_playlist_user_by_user_email_playlist_id(db: Session, user_email: str, playlist_id: int):
    return db.query(Playlist_User).filter(Playlist_User.user_email == user_email, Playlist_User.playlist_id == playlist_id).first()

# create data -----------------------------------------------------------------------------------------------------------
async def create_playlist_user(db: Session, new_playlist_user: PlaylistUserCreate) -> Playlist_User:
    # Kiểm tra nếu new_playlist_user là None
    if not new_playlist_user:
        raise HTTPException(status_code=400, detail="Invalid new_playlist_user data")
    
    # Kiểm tra nếu new_playlist_user.user_email là None
    if not new_playlist_user.user_email:
        raise HTTPException(status_code=400, detail="Invalid new_playlist_user.user_email data")
    
    # Kiểm tra nếu new_playlist_user.playlist_id là None
    if not new_playlist_user.playlist_id:
        raise HTTPException(status_code=400, detail="Invalid new_playlist_user.playlist_id data")
    
    # Tạo Playlist_User mới và thêm vào cơ sở dữ liệu
    try:
        create_playlist_user = Playlist_User(
        user_email=new_playlist_user.user_email,
        playlist_id=new_playlist_user.playlist_id
        )
        db.add(create_playlist_user)
        db.commit()
        db.refresh(create_playlist_user)
        return create_playlist_user
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to create the playlist_user")
    
# update data -----------------------------------------------------------------------------------------------------------
async def update_playlist_user_by_user_email_playlist_id(db: Session, user_email: str, playlist_id: int, new_playlist_user: PlaylistUserUpdate) -> Playlist_User:
    # Lấy dữ liệu old_playlist_user từ cơ sở dữ liệu
    old_playlist_user = db.query(Playlist_User).filter(Playlist_User.user_email == user_email, Playlist_User.playlist_id == playlist_id).first()
    if not old_playlist_user:
        raise HTTPException(status_code=404, detail="Playlist_User not found")

    # Kiểm tra nếu new_playlist_user là None
    if not new_playlist_user:
        raise HTTPException(status_code=400, detail="Invalid playlist_user update data")
    
    # Kiểm tra nếu new_playlist_user.user_email là None
    if not new_playlist_user.user_email:
        raise HTTPException(status_code=400, detail="Invalid playlist_user.user_email update data")
    
    # Kiểm tra nếu new_playlist_user.playlist_id là None
    if not new_playlist_user.playlist_id:
        raise HTTPException(status_code=400, detail="Invalid playlist_user.playlist_id update data")
    
    # Cập nhật các trường được chỉ định trong new_playlist_user
    for var, value in vars(new_playlist_user).items():
        if value is not None:
            setattr(old_playlist_user, var, value)

    # Lưu thay đổi vào cơ sở dữ liệu
    try:
        db.commit()
        db.refresh(old_playlist_user)
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to update the playlist_user")
    
    return old_playlist_user

# delete data -----------------------------------------------------------------------------------------------------------
async def delete_playlist_user_by_user_email_playlist_id(db: Session, user_email: str, playlist_id: int):
    try:
        delete_playlist_user = db.query(Playlist_User).filter(Playlist_User.user_email == user_email, Playlist_User.playlist_id == playlist_id).first()
        if delete_playlist_user is None:
            raise HTTPException(status_code=404, detail="Playlist_User not found")
        else:
            db.delete(delete_playlist_user)
            db.commit()
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to delete the playlist_user")
    