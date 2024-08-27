from sqlalchemy.orm import Session
from fastapi import HTTPException
from app.models.user_upload_song import User_Upload_Song
from app.schemas.user_upload_song import UserUploadSongCreate
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import func

# get data -----------------------------------------------------------------------------------------------------------
async def get_all_user_upload_songs(db: Session) -> list:
    return db.query(User_Upload_Song).all()

async def get_user_upload_song_by_id(db: Session, id: int):
    return db.query(User_Upload_Song).filter(User_Upload_Song.id == id).first()

async def get_user_upload_songs_by_user_email(db: Session, user_email: str) -> list:
    return db.query(User_Upload_Song).filter(User_Upload_Song.user_email == user_email).all()

# create data -----------------------------------------------------------------------------------------------------------
async def create_user_upload_song(db: Session, new_user_upload_song: UserUploadSongCreate) -> User_Upload_Song:
    # Kiểm tra nếu new_user_upload_song là None
    if not new_user_upload_song:
        raise HTTPException(status_code=400, detail="Invalid new_user_upload_song data")
    
    # Kiểm tra nếu new_user_upload_song.name là None
    if not new_user_upload_song.name.strip():
        raise HTTPException(status_code=400, detail="Invalid new_user_upload_song.name data")
    
    # Kiểm tra nếu new_user_upload_song.upload_at là None
    if not new_user_upload_song.upload_at:
        raise HTTPException(status_code=400, detail="Invalid new_user_upload_song.upload_at data")
    
    # Kiểm tra nếu new_user_upload_song.duration là None
    if not new_user_upload_song.duration:
        raise HTTPException(status_code=400, detail="Invalid new_user_upload_song.duration data")
    
    # Kiểm tra nếu new_user_upload_song.user_email là None
    if not new_user_upload_song.user_email.strip():
        raise HTTPException(status_code=400, detail="Invalid new_user_upload_song.user_email data")
    
    # Tạo user_upload_song mới và thêm vào cơ sở dữ liệu
    try:
        create_user_upload_song = User_Upload_Song(
        name=new_user_upload_song.name,
        upload_at=new_user_upload_song.upload_at,
        lyric=new_user_upload_song.lyric,
        duration=new_user_upload_song.duration,
        user_email=new_user_upload_song.user_email,
        )
        db.add(create_user_upload_song)
        db.commit()
        db.refresh(create_user_upload_song)
        return create_user_upload_song
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to create the User_Upload_Song")

# update data -----------------------------------------------------------------------------------------------------------


# delete data -----------------------------------------------------------------------------------------------------------
async def delete_user_upload_song_by_id_user_email(db: Session, id: int, user_email: str):
    try:
        delete_user_upload_song = db.query(User_Upload_Song).filter(User_Upload_Song.id == id, User_Upload_Song.user_email == user_email).first()
        if delete_user_upload_song is None:
            raise HTTPException(status_code=404, detail="User_Upload_Song not found")
        else:
            db.delete(delete_user_upload_song)
            db.commit()
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to delete the user_upload_song")

