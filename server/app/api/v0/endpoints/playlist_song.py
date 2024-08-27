from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.schemas import playlist_song
from app.core.connectdb import get_db
from app.services import playlist_song_service

router = APIRouter()

# get data -----------------------------------------------------------------------------------------------------------
@router.get("/", response_model=list[playlist_song.PlaylistSongBase])
async def get_all_playlist_songs(db: Session = Depends(get_db)):
    playlist_songs = await playlist_song_service.get_all_playlist_songs(db)
    return playlist_songs 
 
@router.get("/get-playlist-song-by-id/{id}", response_model=playlist_song.PlaylistSongBase)
async def get_playlist_song_by_id(id: int, db: Session = Depends(get_db)):
    playlist_song = await playlist_song_service.get_playlist_song_by_id(db, id)
    if playlist_song is None:
        raise HTTPException(status_code=404, detail="Playlist_Song not found")
    return playlist_song
 
@router.get("/get-playlist-songs-by-playlist-id/{playlist_id}", response_model=list[playlist_song.PlaylistSongBase])
async def get_playlist_songs_by_playlist_id(playlist_id: int, db: Session = Depends(get_db)):
    artist_songs = await playlist_song_service.get_playlist_songs_by_playlist_id(db, playlist_id)
    return artist_songs

@router.get("/get-playlist-songs-by-song-id/{song_id}", response_model=list[playlist_song.PlaylistSongBase])
async def get_playlist_songs_by_song_id(song_id: int, db: Session = Depends(get_db)):
    artist_songs = await playlist_song_service.get_playlist_songs_by_song_id(db, song_id)
    return artist_songs

@router.get("/get-playlist-song-by-playlist-id-song-id/{playlist_id}/{song_id}", response_model=playlist_song.PlaylistSongBase)
async def get_playlist_song_by_playlist_id_song_id(playlist_id: int, song_id:int, db: Session = Depends(get_db)):
    artist_song = await playlist_song_service.get_playlist_song_by_playlist_id_song_id(db, playlist_id, song_id)
    if artist_song is None:
        raise HTTPException(status_code=404, detail="Playlist_Song not found")
    return artist_song

# post data -----------------------------------------------------------------------------------------------------------
@router.post("/create-playlist-song/", response_model=playlist_song.PlaylistSongBase)
async def create_playlist_song(new_playlist_song: playlist_song.PlaylistSongCreate, db: Session = Depends(get_db)):
    try:
        create_playlist_song = await playlist_song_service.create_playlist_song(db, new_playlist_song)
        if create_playlist_song is None:
            raise HTTPException(status_code=500, detail="Failed to create playlist_song")
        return create_playlist_song
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# put data -----------------------------------------------------------------------------------------------------------
@router.put("/update-playlist-song-by-playlist-id-song-id/{playlist_id}/{song_id}", response_model=playlist_song.PlaylistSongBase)
async def update_playlist_song_by_playlist_id_song_id(playlist_id: int, song_id: int, new_playlist_song: playlist_song.PlaylistSongUpdate, db: Session = Depends(get_db)):
    try:
        update_playlist_song = await playlist_song_service.update_playlist_song_by_playlist_id_song_id(db, playlist_id, song_id, new_playlist_song)
        if update_playlist_song is None:
            raise HTTPException(status_code=404, detail="Playlist_Song not found")
        return update_playlist_song
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# delete data -----------------------------------------------------------------------------------------------------------
@router.delete("/delete-playlist-song-by-playlist-id-song-id/{playlist_id}/{song_id}", status_code=200)
async def delete_playlist_song_by_playlist_id_song_id(playlist_id: int, song_id: int, db: Session = Depends(get_db)):
    try:
        await playlist_song_service.delete_playlist_song_by_playlist_id_song_id(db, playlist_id, song_id)
        return {"detail": "Playlist_Song deleted successfully"}
    except HTTPException as e:
        raise e 
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    