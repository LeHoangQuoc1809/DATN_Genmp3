from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.schemas import song_genre
from app.core.connectdb import get_db
from app.services import song_genre_service

router = APIRouter()

# get data -----------------------------------------------------------------------------------------------------------
@router.get("/", response_model=list[song_genre.SongGenreBase])
async def get_all_song_genres(db: Session = Depends(get_db)):
    song_genres = await song_genre_service.get_all_song_genres(db)
    return song_genres 
 
@router.get("/get-song-genres-by-song-id/{song_id}", response_model=list[song_genre.SongGenreBase])
async def get_song_genres_by_song_id(song_id: int, db: Session = Depends(get_db)):
    song_genres = await song_genre_service.get_song_genres_by_song_id(db, song_id)
    print(f'song_genres[0].genre_id: {song_genres[0].genre_id}')
    return song_genres
 
@router.get("/get-song-genres-by-genre-id/{genre_id}", response_model=list[song_genre.SongGenreBase])
async def get_song_genres_by_genre_id(genre_id: int, db: Session = Depends(get_db)):
    song_genres = await song_genre_service.get_song_genres_by_genre_id(db, genre_id)
    return song_genres

@router.get("/get-song-genre-by-song-id-genre-id/{song_id}/{genre_id}", response_model=song_genre.SongGenreBase)
async def get_song_genre_by_song_id_genre_id(song_id: int, genre_id:int, db: Session = Depends(get_db)):
    song_genre = await song_genre_service.get_song_genre_by_song_id_genre_id(db, song_id, genre_id)
    if song_genre is None:
        raise HTTPException(status_code=404, detail="Song_Genre not found")
    return song_genre

# post data -----------------------------------------------------------------------------------------------------------
@router.post("/create-song-genre/", response_model=song_genre.SongGenreBase)
async def create_song_genre(new_song_genre: song_genre.SongGenreCreate, db: Session = Depends(get_db)):
    try:
        create_song_genre = await song_genre_service.create_song_genre(db, new_song_genre)
        if create_song_genre is None:
            raise HTTPException(status_code=500, detail="Failed to create song_genre")
        return create_song_genre
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# put data -----------------------------------------------------------------------------------------------------------
@router.put("/update-song-genre-by-song-id-genre-id/{song_id}/{genre_id}", response_model=song_genre.SongGenreBase)
async def update_song_genre_by_song_id_genre_id(song_id: int, genre_id: int, new_song_genre: song_genre.SongGenreUpdate, db: Session = Depends(get_db)):
    try:
        update_song_genre = await song_genre_service.update_song_genre_by_song_id_genre_id(db, song_id, genre_id, new_song_genre)
        if update_song_genre is None:
            raise HTTPException(status_code=404, detail="Song_Genre not found")
        return update_song_genre
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# delete data -----------------------------------------------------------------------------------------------------------
@router.delete("/delete-song-genre-by-song-id-genre-id/{song_id}/{genre_id}", status_code=200)
async def delete_song_genre_by_song_id_genre_id(song_id: int, genre_id: int, db: Session = Depends(get_db)):
    try:
        await song_genre_service.delete_song_genre_by_song_id_genre_id(db, song_id, genre_id)
        return {"detail": "Song_Genre deleted successfully"}
    except HTTPException as e:
        raise e 
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    