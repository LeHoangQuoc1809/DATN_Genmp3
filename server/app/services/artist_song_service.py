from sqlalchemy.orm import Session
from fastapi import HTTPException
from app.models.artist_song import Artist_Song
from app.schemas.artist_song import ArtistSongCreate, ArtistSongUpdate
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import func 

# get data -----------------------------------------------------------------------------------------------------------
async def get_all_artist_songs(db: Session) -> list:
    return db.query(Artist_Song).all()

async def get_artist_songs_by_artist_id(db: Session, artist_id: int) -> list:
    return db.query(Artist_Song).filter(Artist_Song.artist_id == artist_id).all()

async def get_artist_songs_by_song_id(db: Session, song_id: int) -> list:
    return db.query(Artist_Song).filter(Artist_Song.song_id == song_id).all()

async def get_artist_song_by_artist_id_song_id(db: Session, artist_id: int, song_id: int):
    return db.query(Artist_Song).filter(Artist_Song.artist_id == artist_id, Artist_Song.song_id == song_id).first()

# create data -----------------------------------------------------------------------------------------------------------
async def create_artist_song(db: Session, new_artist_song: ArtistSongCreate) -> Artist_Song:
    # Kiểm tra nếu new_artist_song là None
    if not new_artist_song:
        raise HTTPException(status_code=400, detail="Invalid new_artist_song data")
    
    # Kiểm tra nếu new_artist_song.artist_id là None
    if not new_artist_song.artist_id:
        raise HTTPException(status_code=400, detail="Invalid new_artist_song.artist_id data")
    
    # Kiểm tra nếu new_artist_song.song_id là None
    if not new_artist_song.song_id:
        raise HTTPException(status_code=400, detail="Invalid new_artist_song.song_id data")
    
    # Kiểm tra nếu new_artist_song.create_at là None
    if not new_artist_song.create_at:
        raise HTTPException(status_code=400, detail="Invalid new_artist_song.create_at data")
    
    # Tạo Artist_Song mới và thêm vào cơ sở dữ liệu
    try:
        create_artist_song = Artist_Song(
        artist_id=new_artist_song.artist_id,
        song_id=new_artist_song.song_id,
        create_at=new_artist_song.create_at
        )
        db.add(create_artist_song)
        db.commit()
        db.refresh(create_artist_song)
        return create_artist_song
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to create the artist_song")
    
# update data -----------------------------------------------------------------------------------------------------------
async def update_artist_song_by_artist_id_song_id(db: Session, artist_id: int, song_id: int, new_artist_song: ArtistSongUpdate) -> Artist_Song:
    # Lấy dữ liệu old_artist_song từ cơ sở dữ liệu
    old_artist_song = db.query(Artist_Song).filter(Artist_Song.artist_id == artist_id, Artist_Song.song_id == song_id).first()
    if not old_artist_song:
        raise HTTPException(status_code=404, detail="Artist_Song not found")

    # Kiểm tra nếu new_artist_song là None
    if not new_artist_song:
        raise HTTPException(status_code=400, detail="Invalid artist_song update data")
    
    # Kiểm tra nếu new_artist_song.artist_id là None
    if not new_artist_song.artist_id:
        raise HTTPException(status_code=400, detail="Invalid artist_song.artist_id update data")
    
    # Kiểm tra nếu new_artist_song.song_id là None
    if not new_artist_song.song_id:
        raise HTTPException(status_code=400, detail="Invalid artist_song.song_id update data")
    
    # Kiểm tra nếu new_artist_song.create_at là None
    if not new_artist_song.create_at:
        raise HTTPException(status_code=400, detail="Invalid artist_song.create_at update data")
    
    # Cập nhật các trường được chỉ định trong new_artist_song
    for var, value in vars(new_artist_song).items():
        if value is not None:
            setattr(old_artist_song, var, value)

    # Lưu thay đổi vào cơ sở dữ liệu
    try:
        db.commit()
        db.refresh(old_artist_song)
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to update the artist_song")
    
    return old_artist_song

# delete data -----------------------------------------------------------------------------------------------------------
async def delete_artist_song_by_artist_id_song_id(db: Session, artist_id: int, song_id: int):
    try:
        delete_artist_song = db.query(Artist_Song).filter(Artist_Song.artist_id == artist_id, Artist_Song.song_id == song_id).first()
        if delete_artist_song is None:
            raise HTTPException(status_code=404, detail="Artist_Song not found")
        else:
            db.delete(delete_artist_song)
            db.commit()
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to delete the artist_song")
    
async def delete_artist_song_by_song_id(db: Session, song_id: int):
    try:
        delete_artist_songs = db.query(Artist_Song).filter(Artist_Song.song_id == song_id).all()
        if not delete_artist_songs:
            raise HTTPException(status_code=404, detail="Artist_Song not found")
        else:
            print(f"Deleting Artist_Song records with song_id: {song_id}")
            for record in delete_artist_songs:
                print(f"Deleting record: {record}")
            db.query(Artist_Song).filter(Artist_Song.song_id == song_id).delete()
            db.commit()
            print("Delete successful")
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        print(f"SQLAlchemyError: {e}")  # Print lỗi SQLAlchemyError
        raise HTTPException(status_code=500, detail="An error occurred while trying to delete the artist_song")
    