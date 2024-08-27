from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.schemas import album
from app.core.connectdb import get_db
from app.services import album_service

router = APIRouter()

# get data -----------------------------------------------------------------------------------------------------------
@router.get("/", response_model=list[album.AlbumBase])
async def get_all_albums(db: Session = Depends(get_db)):
    albums = await album_service.get_all_albums(db)
    return albums  

@router.get("/get-album-by-id/{id}", response_model=album.AlbumBase)
async def get_album_by_id(id: int, db: Session = Depends(get_db)):
    album = await album_service.get_album_by_id(db, id)
    if album is None:
        raise HTTPException(status_code=404, detail="Album not found")
    return album

@router.get("/get-albums-by-artist-id/{artist_id}", response_model=list[album.AlbumGetAllByAritstId])
async def get_albums_by_artist_id(artist_id: int, db: Session = Depends(get_db)):
    albums = await album_service.get_albums_by_artist_id(db, artist_id)
    return albums

@router.get("/get-top-5-albums-by-artist-id/{artist_id}", response_model=list[album.AlbumGetAllByAritstId])
async def get_top_5_albums_by_artist_id(artist_id: int, db: Session = Depends(get_db)):
    albums = await album_service.get_top_5_albums_by_artist_id(db, artist_id)
    return albums

@router.get("/get-top-50-albums-for-search/{key_word}", response_model=list[album.AlbumBaseForSearch])
async def get_top_50_albums_for_search(key_word: str, db: Session = Depends(get_db)):
    key_word = f"%{(key_word).lower()}%"
    albums = await album_service.get_top_50_albums_for_search(db, key_word)
    return albums

# post data -----------------------------------------------------------------------------------------------------------
@router.post("/create-album/", response_model=album.AlbumBase)
async def create_album(new_album: album.AlbumCreate, db: Session = Depends(get_db)):
    try:
        create_album = await album_service.create_album(db, new_album)
        if create_album is None:
            raise HTTPException(status_code=500, detail="Failed to create album")
        return create_album
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# put data -----------------------------------------------------------------------------------------------------------
@router.put("/update-album-by-id/{id}", response_model=album.AlbumBase)
async def update_album_by_id(id: int, new_album: album.AlbumUpdate, db: Session = Depends(get_db)):
    try:
        update_album = await album_service.update_album_by_id(db, id, new_album)
        if update_album is None:
            raise HTTPException(status_code=404, detail="Album not found")
        return update_album
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# delete data -----------------------------------------------------------------------------------------------------------
@router.delete("/delete-album-by-id/{id}", status_code=200)
async def delete_album_by_id(id: int, db: Session = Depends(get_db)):
    try:
        await album_service.delete_album_by_id(db, id)
        return {"detail": "Album deleted successfully"}
    except HTTPException as e:
        raise e 
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

