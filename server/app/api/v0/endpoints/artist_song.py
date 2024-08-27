from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.schemas import artist_song
from app.core.connectdb import get_db
from app.services import artist_song_service

router = APIRouter()

# get data -----------------------------------------------------------------------------------------------------------
@router.get("/", response_model=list[artist_song.ArtistSongBase])
async def get_all_artist_songs(db: Session = Depends(get_db)):
    artist_songs = await artist_song_service.get_all_artist_songs(db)
    return artist_songs 
 
@router.get("/get-artist-songs-by-artist-id/{artist_id}", response_model=list[artist_song.ArtistSongBase])
async def get_artist_songs_by_artist_id(artist_id: int, db: Session = Depends(get_db)):
    artist_songs = await artist_song_service.get_artist_songs_by_artist_id(db, artist_id)
    return artist_songs
 
@router.get("/get-artist-songs-by-song-id/{song_id}", response_model=list[artist_song.ArtistSongBaseGetArtist])
async def get_artist_songs_by_song_id(song_id: int, db: Session = Depends(get_db)):
    artist_songs = await artist_song_service.get_artist_songs_by_song_id(db, song_id)
    return artist_songs

@router.get("/get-artist-song-by-artist-id-song-id/{artist_id}/{song_id}", response_model=artist_song.ArtistSongBase)
async def get_artist_song_by_artist_id_song_id(artist_id: int, song_id:int, db: Session = Depends(get_db)):
    artist_song = await artist_song_service.get_artist_song_by_artist_id_song_id(db, artist_id, song_id)
    if artist_song is None:
        raise HTTPException(status_code=404, detail="Artist_Song not found")
    return artist_song

# post data -----------------------------------------------------------------------------------------------------------
@router.post("/create-artist-song/", response_model=artist_song.ArtistSongBase)
async def create_artist_song(new_artist_song: artist_song.ArtistSongCreate, db: Session = Depends(get_db)):
    try:
        create_artist_song = await artist_song_service.create_artist_song(db, new_artist_song)
        if create_artist_song is None:
            raise HTTPException(status_code=500, detail="Failed to create artist_song")
        return create_artist_song
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# put data -----------------------------------------------------------------------------------------------------------
@router.put("/update-artist-song-by-artist-id-song-id/{artist_id}/{song_id}", response_model=artist_song.ArtistSongBase)
async def update_artist_song_by_artist_id_song_id(artist_id: int, song_id: int, new_artist_song: artist_song.ArtistSongUpdate, db: Session = Depends(get_db)):
    try:
        update_artist_song = await artist_song_service.update_artist_song_by_artist_id_song_id(db, artist_id, song_id, new_artist_song)
        if update_artist_song is None:
            raise HTTPException(status_code=404, detail="Artist_Song not found")
        return update_artist_song
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# delete data -----------------------------------------------------------------------------------------------------------
@router.delete("/delete-artist-song-by-artist-id-song-id/{artist_id}/{song_id}", status_code=200)
async def delete_artist_song_by_artist_id_song_id(artist_id: int, song_id: int, db: Session = Depends(get_db)):
    try:
        await artist_song_service.delete_artist_song_by_artist_id_song_id(db, artist_id, song_id)
        return {"detail": "Artist_Song deleted successfully"}
    except HTTPException as e:
        raise e 
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    