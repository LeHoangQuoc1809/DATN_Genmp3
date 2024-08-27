from sqlalchemy.orm import Session
from fastapi import HTTPException
from app.models.artist import Artist
from app.models.song import Song
from app.models.artist_song import Artist_Song
from app.models.genre import Genre
from app.models.song_genre import Song_Genre
from app.models.song_topic import Song_Topic
from app.schemas.artist import ArtistCreate, ArtistUpdate
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import func, text
from unidecode import unidecode
import os
import base64

# get data -----------------------------------------------------------------------------------------------------------
async def get_all_artists(db: Session) -> list:
    return db.query(Artist).all()

async def get_artist_by_id(db: Session, id: int):
    return db.query(Artist).filter(Artist.id == id).first()

async def get_top_5_artists_similar_by_id(db: Session, id: int) -> list:
    try:
        query = text("""
            SELECT a.*
            FROM genmp3.artist a
            JOIN genmp3.artist_song ats ON a.id = ats.artist_id
            JOIN genmp3.song s ON ats.song_id = s.id
            JOIN genmp3.song_genre sg ON s.id = sg.song_id
            JOIN genmp3.genre g ON sg.genre_id = g.id
            WHERE a.id != :artist_id
            AND g.name = (
                SELECT g.name
                FROM genmp3.artist_song ats 
                JOIN genmp3.song s ON ats.song_id = s.id
                JOIN genmp3.song_genre sg ON s.id = sg.song_id 
                JOIN genmp3.genre g ON sg.genre_id = g.id
                WHERE ats.artist_id = :artist_id
                GROUP BY g.name
                ORDER BY COUNT(g.name) DESC
                LIMIT 1
            )
            GROUP BY a.id, a.name, a.description, a.picture
            ORDER BY COUNT(g.name) DESC
            LIMIT 5;
        """)
        
        result = db.execute(query, {"artist_id": id}).fetchall()
        
        artists = [dict(row._mapping) for row in result]
        
        return artists
    except Exception as e:
        raise HTTPException(status_code=500, detail="An error occurred while trying to fetch similar artists")
    
async def get_top_5_artists_for_search(db: Session, key_word) -> list:
    return db.query(Artist).filter(func.lower(Artist.name).collate('utf8mb4_bin').ilike(key_word)).limit(5).all()
    
async def get_top_50_artists_for_search(db: Session, key_word) -> list:
    return db.query(Artist).filter(func.lower(Artist.name).collate('utf8mb4_bin').ilike(key_word)).limit(50).all()

# create data -----------------------------------------------------------------------------------------------------------
async def create_artist(db: Session, new_artist: ArtistCreate) -> Artist:
    # Kiểm tra nếu new_artist là None
    if not new_artist:
        raise HTTPException(status_code=400, detail="Invalid new_artist data")
    
    # Kiểm tra nếu new_artist.name là None
    if not new_artist.name.strip():
        raise HTTPException(status_code=400, detail="Invalid new_artist.name data")
    
    # Tạo Artist mới và thêm vào cơ sở dữ liệu
    try:
        create_artist = Artist(
        name=new_artist.name,
        description=new_artist.description,
        picture=new_artist.picture
        )
        db.add(create_artist)
        db.commit()
        db.refresh(create_artist)
        
        # Vì Artist có thể bỏ trống hình nên phải kiểm tra new_artist.picture_base64 có truyên hình vào không
        if new_artist.picture_base64:
            # Giải mã base64 và lưu file hình ảnh
            picture_data = base64.b64decode(new_artist.picture_base64)
            picture_path = f"app/uploads/images/artist/{create_artist.id}_{create_artist.picture}.png"
            with open(picture_path, "wb") as picture:
                picture.write(picture_data)
                print(f"Đã thêm artist.picture : {picture_path}")
            
        return create_artist
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to create the artist")

# update data -----------------------------------------------------------------------------------------------------------
async def update_artist_by_id(db: Session, id: int, new_artist: ArtistUpdate) -> Artist:
    # Lấy dữ liệu old_artist từ cơ sở dữ liệu
    old_artist = db.query(Artist).filter(Artist.id == id).first()
    if not old_artist:
        raise HTTPException(status_code=404, detail="Artist not found")
    
    # Đường dẫn file hình ảnh cũ
    old_picture_path = f"app/uploads/images/artist/{id}_{old_artist.picture}.png"
    print(f"old_picture_path: {old_picture_path}")

    # Kiểm tra nếu new_artist là None
    if not new_artist:
        raise HTTPException(status_code=400, detail="Invalid artist update data")
    
    # Kiểm tra nếu new_artist.name là None
    if not new_artist.name.strip():
        raise HTTPException(status_code=400, detail="Invalid artist.name update data")

    # Lưu thay đổi vào cơ sở dữ liệu
    try: 
        # Cập nhật các trường được chỉ định trong new_artist
        for var, value in vars(new_artist).items():
            if value is not None:
                setattr(old_artist, var, value)

        db.commit()
        db.refresh(old_artist)

        # Kiểm tra xem file hình ảnh cũ có tồn tại không
        if os.path.exists(old_picture_path):
            os.remove(old_picture_path)  # Xóa file hình ảnh cũ
            print(f"Đã xóa artist.picture : {old_picture_path}")

        # Vì Artist có thể bỏ trống hình nên phải kiểm tra new_artist.picture_base64 có truyên hình vào không
        if new_artist.picture_base64:
            # Giải mã base64 và lưu file hình ảnh
            picture_data = base64.b64decode(new_artist.picture_base64)
            picture_path = f"app/uploads/images/artist/{id}_{new_artist.picture}.png"
            with open(picture_path, "wb") as picture:
                picture.write(picture_data)
                print(f"Đã thêm artist.picture : {picture_path}")

    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to update the artist")

    return old_artist

# delete data -----------------------------------------------------------------------------------------------------------
async def delete_artist_by_id(db: Session, id: int):
    try:
        delete_artist = db.query(Artist).filter(Artist.id == id).first()
        if delete_artist is None:
            raise HTTPException(status_code=404, detail="Artist not found")
        else:
            db.delete(delete_artist)
            db.commit()
            
            # Đường dẫn file hình ảnh cũ
            old_picture_path = f"app/uploads/images/artist/{id}_{delete_artist.picture}.png"
            print(f"old_picture_path: {old_picture_path}")

            # Kiểm tra xem file hình ảnh cũ có tồn tại không
            if os.path.exists(old_picture_path):
                os.remove(old_picture_path)  # Xóa file hình ảnh cũ
                print(f"Đã xóa artist.picture : {old_picture_path}")

    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to delete the artist")