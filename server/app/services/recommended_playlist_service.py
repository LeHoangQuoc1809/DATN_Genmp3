from sqlalchemy.orm import Session
from fastapi import HTTPException
from app.models.recommended_playlist import Recommended_Playlist
from app.schemas.recommended_playlist import RecommendedPlaylistCreate, RecommendedPlaylistUpdate
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import func

# get data -----------------------------------------------------------------------------------------------------------
async def get_all_recommended_playlists(db: Session) -> list:
    return db.query(Recommended_Playlist).all()

async def get_recommended_playlist_by_id(db: Session, id: int):
    return db.query(Recommended_Playlist).filter(Recommended_Playlist.id == id).first()

async def get_recommended_playlists_by_user_email(db: Session, user_email: str) -> list:
    return db.query(Recommended_Playlist).filter(Recommended_Playlist.user_email == user_email).all()

async def get_recommended_playlists_by_playlist_id(db: Session, playlist_id: int) -> list:
    return db.query(Recommended_Playlist).filter(Recommended_Playlist.playlist_id == playlist_id).all()

async def get_recommended_playlist_by_user_email_playlist_id(db: Session, user_email: str, playlist_id: int):
    return db.query(Recommended_Playlist).filter(Recommended_Playlist.user_email == user_email, Recommended_Playlist.playlist_id == playlist_id).first()

# create data -----------------------------------------------------------------------------------------------------------
async def create_recommended_playlist(db: Session, new_recommended_playlist: RecommendedPlaylistCreate) -> Recommended_Playlist:
    # Kiểm tra nếu new_recommended_playlist là None
    if not new_recommended_playlist:
        raise HTTPException(status_code=400, detail="Invalid new_recommended_playlist data")
    
    # Kiểm tra nếu new_recommended_playlist.user_email là None
    if not new_recommended_playlist.user_email:
        raise HTTPException(status_code=400, detail="Invalid new_recommended_playlist.user_email data")
    
    # Kiểm tra nếu new_recommended_playlist.playlist_id là None
    if not new_recommended_playlist.playlist_id:
        raise HTTPException(status_code=400, detail="Invalid new_recommended_playlist.playlist_id data")
    
    # Tạo Recommended_Playlist mới và thêm vào cơ sở dữ liệu
    try:
        create_recommended_playlist = RecommendedPlaylistCreate(
        user_email=new_recommended_playlist.user_email,
        playlist_id=new_recommended_playlist.playlist_id
        )
        db.add(create_recommended_playlist)
        db.commit()
        db.refresh(create_recommended_playlist)
        return create_recommended_playlist
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to create the recommended_playlist")
    
# update data -----------------------------------------------------------------------------------------------------------
async def update_recommended_playlist_by_user_email_playlist_id(db: Session, user_email: str, playlist_id: int, new_recommended_playlist: RecommendedPlaylistUpdate) -> Recommended_Playlist:
    # Lấy dữ liệu old_recommended_playlist từ cơ sở dữ liệu
    old_recommended_playlist = db.query(Recommended_Playlist).filter(Recommended_Playlist.user_email == user_email, Recommended_Playlist.playlist_id == playlist_id).first()
    if not old_recommended_playlist:
        raise HTTPException(status_code=404, detail="Playlist_User not found")

    # Kiểm tra nếu new_recommended_playlist là None
    if not new_recommended_playlist:
        raise HTTPException(status_code=400, detail="Invalid recommended_playlist update data")
    
    # Kiểm tra nếu new_recommended_playlist.user_email là None
    if not new_recommended_playlist.user_email:
        raise HTTPException(status_code=400, detail="Invalid recommended_playlist.user_email update data")
    
    # Kiểm tra nếu new_recommended_playlist.playlist_id là None
    if not new_recommended_playlist.playlist_id:
        raise HTTPException(status_code=400, detail="Invalid recommended_playlist.playlist_id update data")
    
    # Cập nhật các trường được chỉ định trong new_recommended_playlist
    for var, value in vars(new_recommended_playlist).items():
        if value is not None:
            setattr(old_recommended_playlist, var, value)

    # Lưu thay đổi vào cơ sở dữ liệu
    try:
        db.commit()
        db.refresh(old_recommended_playlist)
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to update the recommended_playlist")
    
    return old_recommended_playlist

# delete data -----------------------------------------------------------------------------------------------------------
async def delete_recommended_playlist_by_user_email_playlist_id(db: Session, user_email: str, playlist_id: int):
    try:
        delete_recommended_playlist = db.query(Recommended_Playlist).filter(Recommended_Playlist.user_email == user_email, Recommended_Playlist.playlist_id == playlist_id).first()
        if delete_recommended_playlist is None:
            raise HTTPException(status_code=404, detail="Recommended_Playlist not found")
        else:
            db.delete(delete_recommended_playlist)
            db.commit()
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to delete the recommended_playlist")
    