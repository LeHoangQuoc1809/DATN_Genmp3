from sqlalchemy.orm import Session
from fastapi import HTTPException
from app.models.song_genre import Song_Genre
from app.schemas.song_genre import SongGenreCreate, SongGenreUpdate
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import func 

# get data -----------------------------------------------------------------------------------------------------------
async def get_all_song_genres(db: Session) -> list:
    return db.query(Song_Genre).all()

async def get_song_genres_by_song_id(db: Session, song_id: int) -> list:
    return db.query(Song_Genre).filter(Song_Genre.song_id == song_id).all()

async def get_song_genres_by_genre_id(db: Session, genre_id: int) -> list:
    return db.query(Song_Genre).filter(Song_Genre.genre_id == genre_id).all()

async def get_song_genre_by_song_id_genre_id(db: Session, song_id: int, genre_id: int):
    return db.query(Song_Genre).filter(Song_Genre.song_id == song_id, Song_Genre.genre_id == genre_id).first()

# create data -----------------------------------------------------------------------------------------------------------
async def create_song_genre(db: Session, new_song_genre: SongGenreCreate) -> Song_Genre:
    # Kiểm tra nếu new_song_genre là None
    if not new_song_genre:
        raise HTTPException(status_code=400, detail="Invalid new_song_genre data")
    
    # Kiểm tra nếu new_song_genre.song_id là None
    if not new_song_genre.song_id:
        raise HTTPException(status_code=400, detail="Invalid new_song_genre.song_id data")
    
    # Kiểm tra nếu new_song_genre.genre_id là None
    if not new_song_genre.genre_id:
        raise HTTPException(status_code=400, detail="Invalid new_song_genre.genre_id data")

    # Tạo Song_Genre mới và thêm vào cơ sở dữ liệu
    try:
        create_song_genre = Song_Genre(
        song_id=new_song_genre.song_id,
        genre_id=new_song_genre.genre_id,
        )
        db.add(create_song_genre)
        db.commit()
        db.refresh(create_song_genre)
        return create_song_genre
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to create the song_genre")
    
# update data -----------------------------------------------------------------------------------------------------------
async def update_song_genre_by_song_id_genre_id(db: Session, song_id: int, genre_id: int, new_song_genre: SongGenreUpdate) -> Song_Genre:
    # Lấy dữ liệu old_song_genre từ cơ sở dữ liệu
    old_song_genre = db.query(Song_Genre).filter(Song_Genre.song_id == song_id, Song_Genre.genre_id == genre_id).first()
    if not old_song_genre:
        raise HTTPException(status_code=404, detail="Song_Genre not found")

    # Kiểm tra nếu new_song_genre là None
    if not new_song_genre:
        raise HTTPException(status_code=400, detail="Invalid song_genre update data")
    
    # Kiểm tra nếu new_song_genre.song_id là None
    if not new_song_genre.song_id:
        raise HTTPException(status_code=400, detail="Invalid song_genre.song_id update data")
    
    # Kiểm tra nếu new_song_genre.genre_id là None
    if not new_song_genre.genre_id:
        raise HTTPException(status_code=400, detail="Invalid song_genre.genre_id update data")
    
    # Cập nhật các trường được chỉ định trong new_song_genre
    for var, value in vars(new_song_genre).items():
        if value is not None:
            setattr(old_song_genre, var, value)

    # Lưu thay đổi vào cơ sở dữ liệu
    try:
        db.commit()
        db.refresh(old_song_genre)
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to update the song_genre")
    
    return old_song_genre

# delete data -----------------------------------------------------------------------------------------------------------
async def delete_song_genre_by_song_id_genre_id(db: Session, song_id: int, genre_id: int):
    try:
        delete_song_genre = db.query(Song_Genre).filter(Song_Genre.song_id == song_id, Song_Genre.genre_id == genre_id).first()
        if delete_song_genre is None:
            raise HTTPException(status_code=404, detail="Song_Genre not found")
        else:
            db.delete(delete_song_genre)
            db.commit()
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to delete the song_genre")
    
async def delete_song_genre_by_song_id(db: Session, song_id: int):
    try:
        delete_song_genres = db.query(Song_Genre).filter(Song_Genre.song_id == song_id).all()
        if not delete_song_genres:
            raise HTTPException(status_code=404, detail="Song_Genre not found")
        else:
            print(f"Deleting Song_Genre records with song_id: {song_id}")
            for record in delete_song_genres:
                print(f"Deleting record: {record}")
            db.query(Song_Genre).filter(Song_Genre.song_id == song_id).delete()
            db.commit()
            print("Delete successful")
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        print(f"SQLAlchemyError: {e}")  # Print lỗi SQLAlchemyError
        raise HTTPException(status_code=500, detail="An error occurred while trying to delete the song_genre")
    