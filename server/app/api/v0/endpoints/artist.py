from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.schemas import artist
from app.core.connectdb import get_db
from app.services import artist_service

router = APIRouter()

# get data -----------------------------------------------------------------------------------------------------------
@router.get("/", response_model=list[artist.ArtistBase])
async def get_all_artists(db: Session = Depends(get_db)):
    artists = await artist_service.get_all_artists(db)
    return artists  

@router.get("/get-artist-by-id/{id}", response_model=artist.ArtistBase)
async def get_artist_by_id(id: int, db: Session = Depends(get_db)):
    artist = await artist_service.get_artist_by_id(db, id)
    if artist is None:
        raise HTTPException(status_code=404, detail="Artist not found")
    return artist

@router.get("/get-top-5-artists-similar-by-id/{id}", response_model=list[artist.ArtistBaseForGetTop5ArtistsSimilarById])
async def get_top_5_artists_similar_by_id(id: int, db: Session = Depends(get_db)):
    artists = await artist_service.get_top_5_artists_similar_by_id(db, id)
    return artists

@router.get("/get-top-50-artists-for-search/{key_word}", response_model=list[artist.ArtistBaseForSearch])
async def get_top_50_artists_for_search(key_word: str, db: Session = Depends(get_db)):
    key_word = f"%{(key_word).lower()}%"
    artists = await artist_service.get_top_50_artists_for_search(db, key_word)
    return artists

# post data -----------------------------------------------------------------------------------------------------------
@router.post("/create-artist/", response_model=artist.ArtistBase)
async def create_artist(new_artist: artist.ArtistCreate, db: Session = Depends(get_db)):
    try:
        create_artist = await artist_service.create_artist(db, new_artist)
        if create_artist is None:
            raise HTTPException(status_code=500, detail="Failed to create artist")
        return create_artist
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# put data -----------------------------------------------------------------------------------------------------------
@router.put("/update-artist-by-id/{id}", response_model=artist.ArtistBase)
async def update_artist_by_id(id: int, new_artist: artist.ArtistUpdate, db: Session = Depends(get_db)):
    try:
        update_artist = await artist_service.update_artist_by_id(db, id, new_artist)
        if update_artist is None:
            raise HTTPException(status_code=404, detail="Artist not found")
        return update_artist
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# delete data -----------------------------------------------------------------------------------------------------------
@router.delete("/delete-artist-by-id/{id}", status_code=200)
async def delete_artist_by_id(id: int, db: Session = Depends(get_db)):
    try:
        await artist_service.delete_artist_by_id(db, id)
        return {"detail": "Artist deleted successfully"}
    except HTTPException as e:
        raise e 
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")