from sqlalchemy.orm import Session
from fastapi import HTTPException
from app.models.playlist_song import Playlist_Song
from app.schemas.playlist_song import PlaylistSongCreate, PlaylistSongUpdate
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import func

# get data -----------------------------------------------------------------------------------------------------------
async def get_all_playlist_songs(db: Session) -> list:
    return db.query(Playlist_Song).all()

async def get_playlist_song_by_id(db: Session, id: int):
    return db.query(Playlist_Song).filter(Playlist_Song.id == id).first()

async def get_playlist_songs_by_playlist_id(db: Session, playlist_id: int) -> list:
    return db.query(Playlist_Song).filter(Playlist_Song.playlist_id == playlist_id).all()

async def get_playlist_songs_by_song_id(db: Session, song_id: int) -> list:
    return db.query(Playlist_Song).filter(Playlist_Song.song_id == song_id).all()

async def get_playlist_song_by_playlist_id_song_id(db: Session, playlist_id: int, song_id: int):
    return db.query(Playlist_Song).filter(Playlist_Song.playlist_id == playlist_id, Playlist_Song.song_id == song_id).first()

# create data -----------------------------------------------------------------------------------------------------------
async def create_playlist_song(db: Session, new_playlist_song: PlaylistSongCreate) -> Playlist_Song:
    # Kiểm tra nếu new_playlist_song là None
    if not new_playlist_song:
        raise HTTPException(status_code=400, detail="Invalid new_playlist_song data")
    
    # Kiểm tra nếu new_playlist_song.playlist_id là None
    if not new_playlist_song.playlist_id:
        raise HTTPException(status_code=400, detail="Invalid new_playlist_song.playlist_id data")
    
    # Kiểm tra nếu new_playlist_song.song_id là None
    if not new_playlist_song.song_id:
        raise HTTPException(status_code=400, detail="Invalid new_playlist_song.song_id data")
    
    # Tạo Playlist_Song mới và thêm vào cơ sở dữ liệu
    try:
        create_playlist_song = Playlist_Song(
        playlist_id=new_playlist_song.playlist_id,
        song_id=new_playlist_song.song_id
        )
        db.add(create_playlist_song)
        db.commit()
        db.refresh(create_playlist_song)
        return create_playlist_song
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to create the playlist_song")
    
# update data -----------------------------------------------------------------------------------------------------------
async def update_playlist_song_by_playlist_id_song_id(db: Session, playlist_id: int, song_id: int, new_playlist_song: PlaylistSongUpdate) -> Playlist_Song:
    # Lấy dữ liệu old_playlist_song từ cơ sở dữ liệu
    old_playlist_song = db.query(Playlist_Song).filter(Playlist_Song.playlist_id == playlist_id, Playlist_Song.song_id == song_id).first()
    if not old_playlist_song:
        raise HTTPException(status_code=404, detail="Playlist_Song not found")

    # Kiểm tra nếu new_playlist_song là None
    if not new_playlist_song:
        raise HTTPException(status_code=400, detail="Invalid playlist_song update data")
    
    # Kiểm tra nếu new_playlist_song.playlist_id là None
    if not new_playlist_song.playlist_id:
        raise HTTPException(status_code=400, detail="Invalid playlist_song.playlist_id update data")
    
    # Kiểm tra nếu new_playlist_song.song_id là None
    if not new_playlist_song.song_id:
        raise HTTPException(status_code=400, detail="Invalid playlist_song.song_id update data")
    
    # Cập nhật các trường được chỉ định trong new_playlist_song
    for var, value in vars(new_playlist_song).items():
        if value is not None:
            setattr(old_playlist_song, var, value)

    # Lưu thay đổi vào cơ sở dữ liệu
    try:
        db.commit()
        db.refresh(old_playlist_song)
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to update the playlist_song")
    
    return old_playlist_song

# delete data -----------------------------------------------------------------------------------------------------------
async def delete_playlist_song_by_playlist_id_song_id(db: Session, playlist_id: int, song_id: int):
    try:
        delete_playlist_song = db.query(Playlist_Song).filter(Playlist_Song.playlist_id == playlist_id, Playlist_Song.song_id == song_id).first()
        if delete_playlist_song is None:
            raise HTTPException(status_code=404, detail="Playlist_Song not found")
        else:
            db.delete(delete_playlist_song)
            db.commit()
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to delete the playlist_song")
    
async def delete_playlist_song_by_playlist_id(db: Session, playlist_id: int):
    try:
        delete_playlist_songs = db.query(Playlist_Song).filter(Playlist_Song.playlist_id == playlist_id).all()
        if not delete_playlist_songs:
            raise HTTPException(status_code=404, detail="Playlist_Song not found")
        else:
            print(f"Deleting Playlist_Song records with playlist_id: {playlist_id}")
            for record in delete_playlist_songs:
                print(f"Deleting record: {record}")
            db.query(Playlist_Song).filter(Playlist_Song.playlist_id == playlist_id).delete()
            db.commit()
            print("Delete successful")
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        print(f"SQLAlchemyError: {e}")  # Print lỗi SQLAlchemyError
        raise HTTPException(status_code=500, detail="An error occurred while trying to delete the artist_song")
    