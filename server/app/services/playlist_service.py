from sqlalchemy.orm import Session
from fastapi import HTTPException
from app.models.playlist import Playlist
from app.models.playlist_user import Playlist_User
from app.schemas.playlist import PlaylistCreate, PlaylistUpdate, PlaylistCreateForClient
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import func
from unidecode import unidecode
import os
import base64

from app.services import playlist_song_service, playlist_user_service
from app.schemas.playlist_song import PlaylistSongCreate
from app.schemas.playlist_user import PlaylistUserCreate
from datetime import datetime

# get data -----------------------------------------------------------------------------------------------------------
async def get_all_playlists(db: Session) -> list:
    return db.query(Playlist).all()

async def get_playlist_by_id(db: Session, id: int):
    return db.query(Playlist).filter(Playlist.id == id).first()

async def get_top_5_playlists_for_search(db: Session, key_word: str) -> list:
    return db.query(Playlist).filter(func.lower(Playlist.name).collate('utf8mb4_bin').ilike(key_word)).limit(5).all()

async def get_top_50_playlists_for_search(db: Session, key_word: str) -> list:
    return db.query(Playlist).filter(func.lower(Playlist.name).collate('utf8mb4_bin').ilike(key_word)).limit(50).all()

async def get_all_playlists_by_user_email(db: Session, user_email: str) -> list:
    return( 
        db.query(Playlist)
        .join(Playlist_User, Playlist.id == Playlist_User.playlist_id)
        .filter(Playlist_User.user_email==user_email)
        .order_by(Playlist.modify_date.desc())
        .all()
    )
# create data -----------------------------------------------------------------------------------------------------------
async def create_playlist_for_admin_dashboard(db: Session, new_playlist: PlaylistCreate) -> Playlist:
    # Kiểm tra nếu new_playlist là None
    if not new_playlist:
        raise HTTPException(status_code=400, detail="Invalid new_playlist data")
    
    print(f"new_playlist.song_ids : {new_playlist.song_ids}")

    # Kiểm tra nếu new_playlist.name là None
    if not new_playlist.name.strip():
        raise HTTPException(status_code=400, detail="Invalid new_playlist.name data")
    
    # Kiểm tra nếu new_playlist.modify_date là None
    if not new_playlist.modify_date:
        raise HTTPException(status_code=400, detail="Invalid new_playlist.modify_date data")
    
    # Tạo Playlist mới và thêm vào cơ sở dữ liệu
    try:
        create_playlist = Playlist(
        name=new_playlist.name,
        description=new_playlist.description,
        modify_date=new_playlist.modify_date,
        picture=new_playlist.picture
        )
        db.add(create_playlist)
        db.commit()
        db.refresh(create_playlist)

        # Vì Playlist có thể bỏ trống hình nên phải kiểm tra new_playlist.picture_base64 có truyên hình vào không
        if new_playlist.picture_base64:
            # Giải mã base64 và lưu file hình ảnh
            picture_data = base64.b64decode(new_playlist.picture_base64)
            picture_path = f"app/uploads/images/playlist/{create_playlist.id}_{new_playlist.picture}.png"
            with open(picture_path, "wb") as picture:
                picture.write(picture_data)
                print(f"Đã thêm playlist.picture : {picture_path}")


        # dựa vào danh sách các Song được gửi trong new_playlist sẽ tạo ra các record trên bảng playlist_song
        # thể hiện playlist có những bài hát nào.
        # Vì có thể tạo 1 Playlist với 0 bài hát nào nên phải kiểm tra new_playlist.song_ids có truyên hình vào không
        # Tạo các record playlist_song
        if new_playlist.song_ids:
            for song_id in new_playlist.song_ids:
                print(f"Song_id: {song_id}")
                new_playlist_song = PlaylistSongCreate(   
                    playlist_id=create_playlist.id,
                    song_id=song_id
                )
                await playlist_song_service.create_playlist_song(db, new_playlist_song)
                print(f"Đã tạo thành công Playlist_song với song_id: {new_playlist_song.song_id} và playlist_id: {new_playlist_song.playlist_id}")

        return create_playlist
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to create the playlist")
    
async def create_playlist_for_client(db: Session, new_playlist: PlaylistCreateForClient) -> Playlist:
    # Kiểm tra nếu new_playlist là None
    if not new_playlist:
        raise HTTPException(status_code=400, detail="Invalid new_playlist data")

    # Kiểm tra nếu new_playlist.name là None
    if not new_playlist.name.strip():
        raise HTTPException(status_code=400, detail="Invalid new_playlist.name data")
    
    # Kiểm tra nếu new_playlist.modify_date là None
    if not new_playlist.modify_date:
        raise HTTPException(status_code=400, detail="Invalid new_playlist.modify_date data")
    
    # Tạo Playlist mới và thêm vào cơ sở dữ liệu
    try:
        create_playlist = Playlist(
        name=new_playlist.name,
        description=new_playlist.description,
        modify_date=new_playlist.modify_date,
        picture=new_playlist.picture
        )
        db.add(create_playlist)
        db.commit()
        db.refresh(create_playlist)

        # Sau khi tạo thành công 1 record trong bảng playlist, tiến hành tạo thêm record trong bảng playlist_user
        # thể hiện playlist đó là của user nào
        # Tạo các record playlist_user
        print(f"new_playlist.user_email: {new_playlist.user_email}")
        new_playlist_user = PlaylistUserCreate(
            user_email=new_playlist.user_email,
            playlist_id=create_playlist.id
        )
        await playlist_user_service.create_playlist_user(db, new_playlist_user)
        print(f"Đã tạo thành công playlist_user với user_email: {new_playlist.user_email} và playlist_id: {create_playlist.id}")

        return create_playlist
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to create the playlist")

# update data -----------------------------------------------------------------------------------------------------------
async def update_playlist_by_id(db: Session, id: int, new_playlist: PlaylistUpdate) -> Playlist:
    # Lấy dữ liệu old_playlist từ cơ sở dữ liệu
    old_playlist = db.query(Playlist).filter(Playlist.id == id).first()
    if not old_playlist:
        raise HTTPException(status_code=404, detail="Playlist not found")

    # Đường dẫn file hình ảnh cũ
    old_picture_path = f"app/uploads/images/song/{id}_{old_playlist.picture}.png"
    print(f"old_picture_path: {old_picture_path}")

    # Kiểm tra nếu new_playlist là None
    if not new_playlist:
        raise HTTPException(status_code=400, detail="Invalid playlist update data")
    
    # Kiểm tra nếu new_playlist.name là None
    if not new_playlist.name.strip():
        raise HTTPException(status_code=400, detail="Invalid playlist.name update data")
    
    # Kiểm tra nếu new_playlist.modify_date là None
    if not new_playlist.modify_date:
        raise HTTPException(status_code=400, detail="Invalid playlist.modify_date update data")

    # Lưu thay đổi vào cơ sở dữ liệu
    try:
        # Cập nhật các trường được chỉ định trong new_playlist
        for var, value in vars(new_playlist).items():
            if value is not None:
                setattr(old_playlist, var, value)

        db.commit()
        db.refresh(old_playlist)

        # Kiểm tra xem file hình ảnh cũ có tồn tại không
        if os.path.exists(old_picture_path):
            os.remove(old_picture_path)  # Xóa file hình ảnh cũ
            print(f"Đã xóa playlist.picture : {old_picture_path}")

        # Vì Playlist có thể bỏ trống hình nên phải kiểm tra new_playlist.picture_base64 có truyên hình vào không
        if new_playlist.picture_base64:
        # Giải mã base64 và lưu file hình ảnh
            picture_data = base64.b64decode(new_playlist.picture_base64)
            picture_path = f"app/uploads/images/playlist/{id}_{new_playlist.picture}.png"
            with open(picture_path, "wb") as picture:
                picture.write(picture_data)
                print(f"Đã thêm playlist.picture : {picture_path}")

        # dựa vào danh sách các Song được gửi trong new_playlist sẽ thay đổi các record trên bảng playlist_song
        # thể hiện playlist có những bài hát nào.

        # danh sách song_id cũ lấy từ table playlist_song
        old_song_ids_int = []
        old_song_ids =  await playlist_song_service.get_playlist_songs_by_playlist_id(db, id)
        for old_song_id in old_song_ids:
            old_song_id.song_id
            old_song_ids_int.append(old_song_id.song_id)
        print(f"old_song_ids_int: {old_song_ids_int}")

        # Xóa các bản ghi cũ không tồn tại trong new_playlist.song_ids
        for old_song_id in old_song_ids_int:
            if old_song_id not in new_playlist.song_ids:
                # Xóa bản ghi tương ứng trong bảng playlist_song
                await playlist_song_service.delete_playlist_song_by_playlist_id_song_id(db, id, old_song_id)
                print(f"Đã xóa thành công Playlist_Song với playlist_id: {id} và song_id: {old_song_id}")

        # Thêm các bản ghi mới từ new_playlist.song_ids
        for song_id in new_playlist.song_ids:
            if song_id not in old_song_ids_int:
                # Thêm bản ghi mới vào bảng playlist_song
                new_playlist_song = PlaylistSongCreate(
                    playlist_id=id,
                    song_id=song_id
                )
                await playlist_song_service.create_playlist_song(db, new_playlist_song)
                print(f"Đã tạo thành công Playlist_Song với playlist_id: {new_playlist_song.playlist_id} và song_id: {new_playlist_song.song_id}")

    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to update the playlist")

    return old_playlist

# delete data -----------------------------------------------------------------------------------------------------------
async def delete_playlist_by_id(db: Session, id: int):
    try:
        # Trước khi xóa 1 platlist phải xóa tất cả các record thuộc về platlist đó trong bảng platlist_song
        await playlist_song_service.delete_playlist_song_by_playlist_id(db, id)

        # Sau đó xóa platlist
        delete_playlist = db.query(Playlist).filter(Playlist.id == id).first()
        if delete_playlist is None:
            raise HTTPException(status_code=404, detail="Playlist not found")
        else:
            db.delete(delete_playlist)
            db.commit()
            
            # Đường dẫn file hình ảnh cũ
            old_picture_path = f"app/uploads/images/playlist/{id}_{delete_playlist.picture}.png"
            print(f"old_picture_path: {old_picture_path}")

            # Kiểm tra xem file hình ảnh cũ có tồn tại không
            if os.path.exists(old_picture_path):
                os.remove(old_picture_path)  # Xóa file hình ảnh cũ
                print(f"Đã xóa playlist.picture : {old_picture_path}")

    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to delete the playlist")