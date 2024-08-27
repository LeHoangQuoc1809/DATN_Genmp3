from sqlalchemy.orm import Session, aliased
from fastapi import HTTPException, UploadFile, File
from app.models.song import Song
from app.models.album import Album
from app.models.song_genre import Song_Genre
from app.models.song_topic import Song_Topic
from app.models.artist_song import Artist_Song
from app.models.playlist_song import Playlist_Song
from app.schemas.song import SongCreate, SongUpdate
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import func, text
from unidecode import unidecode
from sqlalchemy.future import select
from sqlalchemy.ext.asyncio import AsyncSession
import os
import base64
import shutil
import logging
from app.services import song_genre_service, song_topic_service, artist_song_service
from app.schemas.song_genre import SongGenreCreate
from app.schemas.song_topic import SongTopicCreate
from app.schemas.artist_song import ArtistSongCreate
from datetime import datetime

# Logging configuration
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# get data -----------------------------------------------------------------------------------------------------------
async def get_all_songs(db: Session) -> list:
    return db.query(Song).all()

async def get_song_by_id(db: Session, id: int):
    return db.query(Song).filter(Song.id == id).first()

async def get_songs_by_name(db: Session, name: str) -> list:
    return db.query(Song).filter(func.lower(Song.name).ilike(f"%{name.lower()}%")).all()

async def get_songs_by_album_id(db: Session, album_id: int) -> list:
    return db.query(Song).filter(Song.album_id == album_id).all()

async def get_top_5_songs_listen_count_max(db: Session) -> list:
    return db.query(Song).order_by(Song.listen_count.desc()).limit(5).all()

async def get_top_100_songs_listen_count_max(db: Session) -> list:
    return db.query(Song).order_by(Song.listen_count.desc()).limit(100).all()

async def get_top_12_recent_songs(db: Session) -> list:
    return db.query(Song).join(Album, Song.album_id == Album.id).order_by(Album.release_date.desc()).limit(12).all()

async def get_top_100_songs_listen_count_max_by_genre_id(db: Session, genre_id: int) -> list:
    return (
        db.query(Song)
        .join(Song_Genre, Song.id == Song_Genre.song_id)
        .filter(Song_Genre.genre_id == genre_id)
        .order_by(Song.listen_count.desc())
        .limit(100)
        .all()
    )

async def get_top_100_songs_listen_count_max_by_topic_id(db: Session, topic_id: int) -> list:
    return (
        db.query(Song)
        .join(Song_Topic, Song.id == Song_Topic.song_id)
        .filter(Song_Topic.topic_id == topic_id)
        .order_by(Song.listen_count.desc())
        .limit(100)
        .all()
    )

async def get_top_5_songs_for_search(db: Session, key_word: str) -> list:
    return db.query(Song).filter((func.lower(Song.name).collate('utf8mb4_bin').ilike(key_word))).limit(5).all()

async def get_top_50_songs_for_search(db: Session, key_word: str) -> list:
    return db.query(Song).filter((func.lower(Song.name).collate('utf8mb4_bin').ilike(key_word))).limit(50).all()

async def get_all_songs_by_artist_id(db: Session, artist_id: int) -> list:
    return db.query(Song).join(Artist_Song, Song.id == Artist_Song.song_id).filter(Artist_Song.artist_id == artist_id).all()

async def get_top_songs_listen_count_max_by_artist_id(db: Session, artist_id: int, top: int) -> list:
    return (
        db.query(Song)
        .join(Artist_Song, Song.id == Artist_Song.song_id)
        .filter(Artist_Song.artist_id == artist_id)
        .order_by(Song.listen_count.desc())
        .limit(top)
        .all()
    )

async def get_top_songs_listen_count_max_by_album_id(db: Session, album_id: int, top: int) -> list:
    return (
        db.query(Song)
        .filter(Song.album_id == album_id)
        .order_by(Song.listen_count.desc())
        .limit(top)
        .all()
    )

async def get_all_songs_by_playlist_id(db: Session, playlist_id: int) -> list:
    return (
        db.query(Song)
        .join(Playlist_Song, Song.id == Playlist_Song.song_id)
        .filter(Playlist_Song.playlist_id == playlist_id)
        .all()
    )

# def get_all_songs_by_playlist_id(db: Session, playlist_id: int) -> list:
#     PlaylistSongAlias = aliased(Playlist_Song)
#     query = (
#         select(Song)
#         .join(PlaylistSongAlias, Song.id == PlaylistSongAlias.song_id)
#         .filter(PlaylistSongAlias.playlist_id == playlist_id)
#     )
#     result = db.execute(query)
#     songs = result.scalars().all()  # Dùng scalars().all() để lấy tất cả các bản sao
#     return songs
    

# create data -----------------------------------------------------------------------------------------------------------
def get_full_path_for_windows(path):
    if os.name == 'nt':
        return f"\\\\?\\{os.path.abspath(path)}"
    return path

async def create_song(db: Session, new_song: SongCreate) -> Song:
    # Kiểm tra nếu new_song là None
    if not new_song:
        raise HTTPException(status_code=400, detail="Invalid new_song data")
    
    # Kiểm tra nếu new_song.name là None
    if not new_song.name.strip():
        raise HTTPException(status_code=400, detail="Invalid new_song.name data")
    
    # Kiểm tra nếu new_song.duration là None
    if not new_song.duration:
        raise HTTPException(status_code=400, detail="Invalid new_song.duration data")
    
    # Kiểm tra nếu new_song.picture là None
    if not new_song.picture.strip():
        raise HTTPException(status_code=400, detail="Invalid new_song.picture data")
    
    # Kiểm tra nếu new_song.album_id là None
    if not new_song.album_id:
        raise HTTPException(status_code=400, detail="Invalid new_song.album_id data")
    
    # Tạo Song mới và thêm vào cơ sở dữ liệu sau đó lưu hình và mp3 
    try:
        create_song = Song(
        name=new_song.name,
        duration=new_song.duration,
        picture=new_song.picture,
        lyric=new_song.lyric,
        album_id=new_song.album_id
        )
        db.add(create_song)
        db.commit()
        db.refresh(create_song)

        # Giải mã base64 và lưu file hình ảnh
        picture_data = base64.b64decode(new_song.picture_base64)
        picture_path = f"app/uploads/images/song/{create_song.id}_{new_song.picture}.png"
        full_picture_path = get_full_path_for_windows(picture_path)
        with open(full_picture_path, "wb") as picture:
            picture.write(picture_data)
            print(f"Đã thêm song.picture : {picture_path}")

        # Vì có thể không thêm file lyric nên phải kiểm tra trước
        if new_song.lyric_base64:
            lyric_data = base64.b64decode(new_song.lyric_base64)
            lyric_path = f"app/uploads/lyrics/{create_song.id}.txt"
            with open(lyric_path, "wb") as lyric:
                lyric.write(lyric_data)
                print(f"Đã thêm file lyric : {lyric_path}")

        # Giải mã base64 và lưu file mp3
        mp3_data = base64.b64decode(new_song.mp3_base64)
        mp3_path = f"app/uploads/mp3/song/{create_song.id}.mp3"
        with open(mp3_path, "wb") as mp3:
            mp3.write(mp3_data)
            print(f"Đã thêm song.mp3 : {mp3_path}")
        #################################################################################################################################
        # dựa vào danh sách các Genre được gửi trong new_song sẽ tạo ra các record trên bảng song_genre
        # thể hiện bài hát thuộc những thể loại nào
        # Tạo các record song_genre
        print(f"new_song.genre_ids: {new_song.genre_ids}")
        for genre_id in new_song.genre_ids:
            print(f"Genre_id: {genre_id}")
            new_song_genre = SongGenreCreate(
                song_id=create_song.id,
                genre_id=genre_id
            )
            await song_genre_service.create_song_genre(db, new_song_genre)
            print(f"Đã tạo thành công Song_Genre với song_id: {new_song_genre.song_id} và genre_id: {new_song_genre.genre_id}")
        #################################################################################################################################
        # dựa vào danh sách các Topic được gửi trong new_song sẽ tạo ra các record trên bảng song_topic
        # thể hiện bài hát thuộc những chủ đề nào
        # Tạo các record song_topic
        print(f"new_song.topic_ids: {new_song.topic_ids}")
        for topic_id in new_song.topic_ids:
            print(f"Topic_id: {topic_id}")
            new_song_topic = SongTopicCreate(
                song_id=create_song.id,
                topic_id=topic_id
            )
            await song_topic_service.create_song_topic(db, new_song_topic)
            print(f"Đã tạo thành công Song_Topic với song_id: {new_song_topic.song_id} và topic_id: {new_song_topic.topic_id}")
        #################################################################################################################################
        # dựa vào danh sách các Artist được gửi trong new_song sẽ tạo ra các record trên bảng artist_song
        # thể hiện bài hát của những tác giả nào
        # Tạo các record artist_song
        print(f"new_song.artist_ids: {new_song.artist_ids}")
        for artist_id in new_song.artist_ids:
            print(f"Artist_id: {artist_id}")
            new_artist_song = ArtistSongCreate(
                artist_id=artist_id,
                song_id=create_song.id,
                create_at=datetime.utcnow()
            )
            await artist_song_service.create_artist_song(db, new_artist_song)
            print(f"Đã tạo thành công Artist_Song với song_id: {new_artist_song.song_id} và artist_id: {new_artist_song.artist_id}")
        #################################################################################################################################
        return create_song
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        logger.error(f"SQLAlchemyError: {e}")
        raise HTTPException(status_code=500, detail="An error occurred while trying to create the song")

# update data -----------------------------------------------------------------------------------------------------------
async def update_song_by_id(db: Session, id: int, new_song: SongUpdate) -> Song:
    # Lấy dữ liệu old_song từ cơ sở dữ liệu
    old_song = db.query(Song).filter(Song.id == id).first()
    if not old_song:
        raise HTTPException(status_code=404, detail="Song not found")
    
    # Đường dẫn file hình ảnh cũ
    old_picture_path = f"app/uploads/images/song/{id}_{old_song.picture}.png"
    print(f"old_picture_path: {old_picture_path}")

    # Đường dẫn file mp3 cũ
    old_mp3_path = f"app/uploads/mp3/song/{id}.mp3"
    print(f"old_mp3_path: {old_mp3_path}")

    # Kiểm tra nếu new_song là None
    if not new_song:
        raise HTTPException(status_code=400, detail="Invalid song update data")
    
    # Kiểm tra nếu new_song.name là None
    if not new_song.name.strip():
        raise HTTPException(status_code=400, detail="Invalid song.name update data")
    
    # Kiểm tra nếu new_song.duration là None
    if not new_song.duration:
        raise HTTPException(status_code=400, detail="Invalid song.duration update data")
    
    # Kiểm tra nếu new_song.picture là None
    if not new_song.picture.strip():
        raise HTTPException(status_code=400, detail="Invalid song.picture update data")
    
    # Kiểm tra nếu new_song.album_id là None
    if not new_song.album_id:
        raise HTTPException(status_code=400, detail="Invalid song.album_id update data")
    
    # Lưu thay đổi vào cơ sở dữ liệu
    try:    
        # Cập nhật các trường được chỉ định trong new_song
        for var, value in vars(new_song).items():
            if value is not None:
                setattr(old_song, var, value)

        db.commit()
        db.refresh(old_song)

        # Kiểm tra xem file hình ảnh cũ có tồn tại không
        if os.path.exists(old_picture_path):
            os.remove(old_picture_path)  # Xóa file hình ảnh cũ
            print(f"Đã xóa song.picture : {old_picture_path}")

        # Giải mã base64 và lưu file hình ảnh
        picture_data = base64.b64decode(new_song.picture_base64)
        picture_path = f"app/uploads/images/song/{id}_{new_song.picture}.png"
        with open(picture_path, "wb") as picture:
            picture.write(picture_data)
            print(f"Đã thêm song.picture : {picture_path}")

        # Vì có thể không thêm file lyric nên phải kiểm tra trước
        if new_song.lyric_base64:
            lyric_data = base64.b64decode(new_song.lyric_base64)
            lyric_path = f"app/uploads/lyrics/{id}.txt"
            with open(lyric_path, "wb") as lyric:
                lyric.write(lyric_data)
                print(f"Đã thêm file lyric : {lyric_path}")

        # Kiểm tra xem file mp3 cũ có tồn tại không
        if os.path.exists(old_mp3_path):
            os.remove(old_mp3_path)  # Xóa file mp3 cũ
            print(f"Đã xóa song.mp3 : {old_mp3_path}")

        # Giải mã base64 và lưu file mp3
        mp3_data = base64.b64decode(new_song.mp3_base64)
        mp3_path = f"app/uploads/mp3/song/{id}.mp3"
        with open(mp3_path, "wb") as mp3:
            mp3.write(mp3_data)
            print(f"Đã thêm song.mp3 : {mp3_path}")
        #################################################################################################################################
        # dựa vào danh sách các Genre được gửi trong new_song sẽ thay đổi các record trên bảng song_genre
        # thể hiện bài hát thuộc những thể loại nào
        # danh sách genre_id cũ lấy từ table song_genre
        old_genre_ids_int = []
        old_genre_ids =  await song_genre_service.get_song_genres_by_song_id(db, id)
        for old_genre_id in old_genre_ids:
            old_genre_id.genre_id
            old_genre_ids_int.append(old_genre_id.genre_id)
        print(f"old_genre_ids_int: {old_genre_ids_int}")

        # Xóa các bản ghi cũ không tồn tại trong new_song.genre_ids
        for old_genre_id in old_genre_ids_int:
            if old_genre_id not in new_song.genre_ids:
                # Xóa bản ghi tương ứng trong bảng song_genre
                await song_genre_service.delete_song_genre_by_song_id_genre_id(db, id, old_genre_id)
                print(f"Đã xóa thành công Song_Genre với song_id: {id} và genre_id: {old_genre_id}")

        # Thêm các bản ghi mới từ new_song.genre_ids
        for genre_id in new_song.genre_ids:
            if genre_id not in old_genre_ids_int:
                # Thêm bản ghi mới vào bảng song_genre
                new_song_genre = SongGenreCreate(
                    song_id=id,
                    genre_id=genre_id
                )
                await song_genre_service.create_song_genre(db, new_song_genre)
                print(f"Đã tạo thành công Song_Genre với song_id: {new_song_genre.song_id} và genre_id: {new_song_genre.genre_id}")
        #################################################################################################################################
        # dựa vào danh sách các Topic được gửi trong new_song sẽ thay đổi các record trên bảng song_topic
        # thể hiện bài hát thuộc những chủ đề nào
        # danh sách topic_id cũ lấy từ table song_topic
        old_topic_ids_int = []
        old_topic_ids =  await song_topic_service.get_song_topics_by_song_id(db, id)
        for old_topic_id in old_topic_ids:
            old_topic_id.topic_id
            old_topic_ids_int.append(old_topic_id.topic_id)
        print(f"old_topic_ids_int: {old_topic_ids_int}")

        # Xóa các bản ghi cũ không tồn tại trong new_song.topic_ids
        for old_topic_id in old_topic_ids_int:
            if old_topic_id not in new_song.topic_ids:
                # Xóa bản ghi tương ứng trong bảng song_topic
                await song_topic_service.delete_song_topic_by_song_id_topic_id(db, id, old_topic_id)
                print(f"Đã xóa thành công Song_Topic với song_id: {id} và topic_id: {old_topic_id}")

        # Thêm các bản ghi mới từ new_song.topic_ids
        for topic_id in new_song.topic_ids:
            if topic_id not in old_topic_ids_int:
                # Thêm bản ghi mới vào bảng song_topic
                new_song_topic = SongTopicCreate(
                    song_id=id,
                    topic_id=topic_id
                )
                await song_topic_service.create_song_topic(db, new_song_topic)
                print(f"Đã tạo thành công Song_Topic với song_id: {new_song_topic.song_id} và topic_id: {new_song_topic.topic_id}")
        #################################################################################################################################
        # dựa vào danh sách các Artist được gửi trong new_song sẽ thay đổi các record trên bảng artist_song
        # thể hiện bài hát của những tác giả nào
        # danh sách artist_id cũ lấy từ table artist_song
        old_artist_ids_int = []
        old_artist_ids =  await artist_song_service.get_artist_songs_by_song_id(db, id)
        for old_artist_id in old_artist_ids:
            old_artist_id.artist.id
            old_artist_ids_int.append(old_artist_id.artist.id)
        print(f"old_artist_ids_int: {old_artist_ids_int}")

        # Xóa các bản ghi cũ không tồn tại trong new_song.artist_ids
        for old_artist_id in old_artist_ids_int:
            if old_artist_id not in new_song.artist_ids:
                # Xóa bản ghi tương ứng trong bảng artist_song
                await artist_song_service.delete_artist_song_by_artist_id_song_id(db, old_artist_id, id)
                print(f"Đã xóa thành công Artist_Song với song_id: {id} và artist_id: {old_artist_id}")

        # Thêm các bản ghi mới từ new_song.artist_ids
        for artist_id in new_song.artist_ids:
            if artist_id not in old_artist_ids_int:
                # Thêm bản ghi mới vào bảng artist_song
                new_artist_song = ArtistSongCreate(
                    artist_id=artist_id,
                    song_id=id,
                    create_at=datetime.now()
                )
                await artist_song_service.create_artist_song(db, new_artist_song)
                print(f"Đã tạo thành công Artist_Song với song_id: {new_artist_song.song_id} và artist_id: {new_artist_song.artist_id}")
        #################################################################################################################################
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to update the song")
    
    return old_song

# delete data -----------------------------------------------------------------------------------------------------------
async def delete_song_by_id(db: Session, id: int):
    try:
        # Trước khi xóa 1 song phải xóa tất cả các record thuộc về song đó trong bảng artist_song
        await artist_song_service.delete_artist_song_by_song_id(db, id)
        
        # # Trước khi xóa 1 song phải xóa tất cả các record thuộc về song đó trong bảng song_genre
        # await song_genre_service.delete_song_genre_by_song_id(db, id)
        
        # # Trước khi xóa 1 song phải xóa tất cả các record thuộc về song đó trong bảng song_topic
        # await song_topic_service.delete_song_topic_by_song_id(db, id)
        
        # Sau đó xóa song
        delete_song = db.query(Song).filter(Song.id == id).first()
        if delete_song is None:
            print(f"delete_song is None")
            raise HTTPException(status_code=404, detail="Song not found")
        else:
            db.delete(delete_song)
            db.commit()
            
            # Đường dẫn file hình ảnh cũ
            old_picture_path = f"app/uploads/images/song/{id}_{delete_song.picture}.png"
            print(f"old_picture_path: {old_picture_path}")

            # Kiểm tra xem file hình ảnh cũ có tồn tại không
            if os.path.exists(old_picture_path):
                os.remove(old_picture_path)  # Xóa file hình ảnh cũ
                print(f"Đã xóa song.picture : {old_picture_path}")

            # Đường dẫn file mp3 cũ
            old_mp3_path = f"app/uploads/mp3/song/{id}.mp3"
            print(f"old_mp3_path: {old_mp3_path}")

            # Kiểm tra xem file mp3 cũ có tồn tại không
            if os.path.exists(old_mp3_path):
                os.remove(old_mp3_path)  # Xóa file mp3 cũ
                print(f"Đã xóa song.mp3 : {old_mp3_path}")
            
            # Đường dẫn file lyric cũ
            old_lyric_path = f"app/uploads/lyrics/{id}.txt"
            print(f"old_lyric_path: {old_lyric_path}")

            # Kiểm tra xem file lyric cũ có tồn tại không
            if os.path.exists(old_lyric_path):
                os.remove(old_lyric_path)  # Xóa file lyric cũ
                print(f"Đã xóa song.lyric : {old_lyric_path}")

    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        print(f"-----------------e-----------------: \n{e}")
        raise HTTPException(status_code=500, detail="An error occurred while trying to delete the song")
 