from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
from sqlalchemy.orm import Session, aliased
from sqlalchemy.future import select
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.schemas import song
from app.core.connectdb import get_db
from app.services import song_service
import base64
import os
import logging

router = APIRouter()

# Logging configuration
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# get data -----------------------------------------------------------------------------------------------------------
@router.get("/", response_model=list[song.SongBase_ArtistBase_Id_Name_Description_Picture])
async def get_all_songs(db: Session = Depends(get_db)):
    songs = await song_service.get_all_songs(db)
    return songs 

@router.get("/get-song-by-id/{id}", response_model=song.SongBase)
async def get_song_by_id(id: int, db: Session = Depends(get_db)):
    song = await song_service.get_song_by_id(db, id)
    if song is None:
        raise HTTPException(status_code=404, detail="Song not found")
    return song

@router.get("/get-songs-by-name/{name}", response_model=list[song.SongBase])
async def get_songs_by_name(name: str, db: Session = Depends(get_db)):
    name = name.strip()  # Loại bỏ khoảng trắng đầu cuối
    if not name:
        raise HTTPException(status_code=400, detail="Name cannot be empty or whitespace only")
    else:
        songs = await song_service.get_songs_by_name(db, name)
    return songs

@router.get("/get-songs-by-album-id/{album_id}", response_model=list[song.SongBase_No_Artists])
async def get_songs_by_album_id(album_id: int, db: Session = Depends(get_db)):
    songs = await song_service.get_songs_by_album_id(db, album_id)
    return songs

@router.get("/get-top-5-songs-listen-count-max", response_model=list[song.SongBaseForGetTop5SongsListenCountMax])
async def get_top_5_songs_listen_count_max(db: Session = Depends(get_db)):
    songs = await song_service.get_top_5_songs_listen_count_max(db)
    return songs 

@router.get("/get-top-100-songs-listen-count-max", response_model=list[song.SongBaseForGetTop100SongsListenCountMax])
async def get_top_100_songs_listen_count_max(db: Session = Depends(get_db)):
    songs = await song_service.get_top_100_songs_listen_count_max(db)
    return songs 

@router.get("/get-top-12-recent-songs", response_model=list[song.SongBaseForGetTop12RecentSongs])
async def get_top_12_recent_songs(db: Session = Depends(get_db)):
    songs = await song_service.get_top_12_recent_songs(db)
    return songs 

@router.get("/get-top-100-songs-listen-count-max-by-genre-id/{genre_id}", response_model=list[song.SongBaseForGetTop100SongsListenCountMax])
async def get_top_100_songs_listen_count_max_by_genre_id(genre_id: int, db: Session = Depends(get_db)):
    songs = await song_service.get_top_100_songs_listen_count_max_by_genre_id(db, genre_id)
    return songs

@router.get("/get-top-100-songs-listen-count-max-by-topic-id/{topic_id}", response_model=list[song.SongBaseForGetTop100SongsListenCountMax])
async def get_top_100_songs_listen_count_max_by_topic_id(topic_id: int, db: Session = Depends(get_db)):
    songs = await song_service.get_top_100_songs_listen_count_max_by_topic_id(db, topic_id)
    return songs

@router.get("/get-top-50-songs-for-search/{key_word}", response_model=list[song.SongBaseForSearch])
async def get_top_50_songs_for_search(key_word: str, db: Session = Depends(get_db)):
    key_word = f"%{(key_word).lower()}%"
    songs = await song_service.get_top_50_songs_for_search(db, key_word)
    return songs

@router.get("/get-all-songs-by-artist-id/{artist_id}", response_model=list[song.SongBaseForGetAllSongsByArtistId])
async def get_all_songs_by_artist_id(artist_id: int, db: Session = Depends(get_db)):
    songs = await song_service.get_all_songs_by_artist_id(db, artist_id)
    return songs

@router.get("/get-top-{top}-songs-listen-count-max-by-artist-id/{artist_id}", response_model=list[song.SongBaseForGetTopSongsListenCountMaxByArtistId])
async def get_top_songs_listen_count_max_by_artist_id(artist_id: int, top: int, db: Session = Depends(get_db)):
    songs = await song_service.get_top_songs_listen_count_max_by_artist_id(db, artist_id, top)
    return songs

@router.get("/get-top-{top}-songs-listen-count-max-by-album-id/{album_id}", response_model=list[song.SongBaseForGetTopSongsListenCountMaxByAlbumId])
async def get_top_songs_listen_count_max_by_album_id(album_id: int, top: int, db: Session = Depends(get_db)):
    songs = await song_service.get_top_songs_listen_count_max_by_album_id(db, album_id, top)
    return songs

@router.get("/get-all-songs-by-playlist-id/{playlist_id}", response_model=list[song.SongBaseForGetAllSongsByPlaylistId])
async def get_all_songs_by_playlist_id(playlist_id: int, db: Session = Depends(get_db)):
    songs = await song_service.get_all_songs_by_playlist_id(db, playlist_id)
    return songs

# post data -----------------------------------------------------------------------------------------------------------
@router.post("/create-song/", response_model=song.SongBase_ArtistBase_Id_Name_Description_Picture)
async def create_song(new_song: song.SongCreate, db: Session = Depends(get_db)):
    try:
        create_song = await song_service.create_song(db, new_song)
        if create_song is None:
            raise HTTPException(status_code=500, detail="Failed to create song")
        return create_song
    except HTTPException as e:
        logger.error(f"HTTPException: {e.detail}")
        raise e
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# put data -----------------------------------------------------------------------------------------------------------
@router.put("/update-song-by-id/{id}", response_model=song.SongBase)
async def update_song_by_id(id: int, new_song: song.SongUpdate, db: Session = Depends(get_db)):
    try:
        update_song = await song_service.update_song_by_id(db, id, new_song)
        if update_song is None:
            raise HTTPException(status_code=404, detail="Song not found")
        return update_song
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# delete data -----------------------------------------------------------------------------------------------------------
@router.delete("/delete-song-by-id/{id}", status_code=200)
async def delete_song_by_id(id: int, db: Session = Depends(get_db)):
    try:
        await song_service.delete_song_by_id(db, id)
        return {"detail": "Song deleted successfully"}
    except HTTPException as e:
        raise e 
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    