from sqlalchemy.orm import Session
from fastapi import HTTPException
from app.models.album import Album
from app.schemas.album import AlbumCreate, AlbumUpdate
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import func
from unidecode import unidecode
import os
import base64

# get data -----------------------------------------------------------------------------------------------------------
async def get_all_albums(db: Session) -> list:
    return db.query(Album).all()

async def get_album_by_id(db: Session, id: int):
    return db.query(Album).filter(Album.id == id).first()

async def get_albums_by_artist_id(db: Session, artist_id: int) -> list:
    return db.query(Album).filter(Album.artist_id == artist_id).all()

async def get_top_5_albums_by_artist_id(db: Session, artist_id: int) -> list:
    return db.query(Album).filter(Album.artist_id == artist_id).limit(5).all()

async def get_top_5_albums_for_search(db: Session, key_word: str) -> list:
    return db.query(Album).filter(func.lower(Album.name).collate('utf8mb4_bin').ilike(key_word)).limit(5).all()

async def get_top_50_albums_for_search(db: Session, key_word: str) -> list:
    return db.query(Album).filter(func.lower(Album.name).collate('utf8mb4_bin').ilike(key_word)).limit(50).all()

# create data -----------------------------------------------------------------------------------------------------------
async def create_album(db: Session, new_album: AlbumCreate) -> Album:
    # Kiểm tra nếu new_album là None
    if not new_album:
        raise HTTPException(status_code=400, detail="Invalid new_album data")
    
    # Kiểm tra nếu new_album.name là None
    if not new_album.name.strip():
        raise HTTPException(status_code=400, detail="Invalid new_album.name data")
    
    # Kiểm tra nếu new_album.release_date là None
    if not new_album.release_date:
        raise HTTPException(status_code=400, detail="Invalid new_album.release_date data")
    print(f'release_date: {new_album.release_date}')
    
    # Kiểm tra nếu new_album.picture là None
    if not new_album.picture.strip():
        raise HTTPException(status_code=400, detail="Invalid new_album.picture data")
    
    # Kiểm tra nếu new_album.artist_id là None
    if not new_album.artist_id:
        raise HTTPException(status_code=400, detail="Invalid new_album.artist_id data")

    # Tạo Album mới và thêm vào cơ sở dữ liệu
    try:
        create_album = Album(
        name=new_album.name,
        release_date=new_album.release_date,
        picture=new_album.picture,
        artist_id=new_album.artist_id,
        description=new_album.description
        )
        db.add(create_album)
        db.commit()
        db.refresh(create_album)

        # Giải mã base64 và lưu file hình ảnh
        picture_data = base64.b64decode(new_album.picture_base64)
        picture_path = f"app/uploads/images/album/{create_album.id}_{new_album.picture}.png"
        with open(picture_path, "wb") as picture:
            picture.write(picture_data)
            print(f"Đã thêm album.picture : {picture_path}")

        return create_album
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to create the album")
    
# update data -----------------------------------------------------------------------------------------------------------
async def update_album_by_id(db: Session, id: int, new_album: AlbumUpdate) -> Album:
    # Lấy dữ liệu old_album từ cơ sở dữ liệu
    old_album = db.query(Album).filter(Album.id == id).first()
    if not old_album:
        raise HTTPException(status_code=404, detail="Album not found")
    
    # Đường dẫn file hình ảnh cũ
    old_picture_path = f"app/uploads/images/album/{id}_{old_album.picture}.png"
    print(f"old_picture_path: {old_picture_path}")

    # Kiểm tra nếu new_album là None
    if not new_album:
        raise HTTPException(status_code=400, detail="Invalid album update data")
    
    # Kiểm tra nếu new_album.name là None
    if not new_album.name.strip():
        raise HTTPException(status_code=400, detail="Invalid album.name update data")
    
    # Kiểm tra nếu new_album.release_date là None
    if not new_album.release_date:
        raise HTTPException(status_code=400, detail="Invalid album.release_date update data")
    
    # Kiểm tra nếu new_album.picture là None
    if not new_album.picture.strip():
        raise HTTPException(status_code=400, detail="Invalid album.picture update data")
    
    # Kiểm tra nếu new_album.artist_id là None
    if not new_album.artist_id:
        raise HTTPException(status_code=400, detail="Invalid album.artist_id update data")

    # Lưu thay đổi vào cơ sở dữ liệu
    try:   
        # Cập nhật các trường được chỉ định trong new_album
        for var, value in vars(new_album).items():
            if value is not None:
                setattr(old_album, var, value)

        db.commit()
        db.refresh(old_album)

        # Kiểm tra xem file hình ảnh cũ có tồn tại không
        if os.path.exists(old_picture_path):
            os.remove(old_picture_path)  # Xóa file hình ảnh cũ
            print(f"Đã xóa album.picture : {old_picture_path}")
        
        # Giải mã base64 và lưu file hình ảnh
        picture_data = base64.b64decode(new_album.picture_base64)
        picture_path = f"app/uploads/images/album/{id}_{new_album.picture}.png"
        with open(picture_path, "wb") as picture:
            picture.write(picture_data)
            print(f"Đã thêm album.picture : {picture_path}")

    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to update the album")
    
    return old_album

# delete data -----------------------------------------------------------------------------------------------------------
async def delete_album_by_id(db: Session, id: int):
    try:
        delete_album = db.query(Album).filter(Album.id == id).first()
        if delete_album is None:
            raise HTTPException(status_code=404, detail="Album not found")
        else:
            db.delete(delete_album)
            db.commit()
            
            # Đường dẫn file hình ảnh cũ
            old_picture_path = f"app/uploads/images/album/{id}_{delete_album.picture}.png"
            print(f"old_picture_path: {old_picture_path}")

            # Kiểm tra xem file hình ảnh cũ có tồn tại không
            if os.path.exists(old_picture_path):
                os.remove(old_picture_path)  # Xóa file hình ảnh cũ
                print(f"Đã xóa album.picture : {old_picture_path}")

    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to delete the album")
 