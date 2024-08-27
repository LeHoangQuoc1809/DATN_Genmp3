from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.schemas import genre
from app.core.connectdb import get_db
from app.services import genre_service

router = APIRouter()

# get data -----------------------------------------------------------------------------------------------------------
@router.get("/get-all-genres-for-admin-dashboard", response_model=list[genre.GenreBase])
async def get_all_genres(db: Session = Depends(get_db)):
    genres = await genre_service.get_all_genres(db)
    return genres  

@router.get("/get-genre-by-id/{id}", response_model=genre.GenreBase)
async def get_genre_by_id(id: int, db: Session = Depends(get_db)):
    genre = await genre_service.get_genre_by_id(db, id)
    if genre is None:
        raise HTTPException(status_code=404, detail="Genre not found")
    return genre

@router.get("/get-genres-by-name/{name}", response_model=list[genre.GenreBase])
async def get_genres_by_name(name: str, db: Session = Depends(get_db)):
    name = name.strip()  # Loại bỏ khoảng trắng đầu cuối
    if not name:
        raise HTTPException(status_code=400, detail="Name cannot be empty or whitespace only")
    else:
        genres = await genre_service.get_genres_by_name(db, name)
    return genres

@router.get("/get-top-3-genres", response_model=list[genre.GenreBaseForGetTop3Genres])
async def get_top_3_genres(db: Session = Depends(get_db)):
    genres = await genre_service.get_top_3_genres(db)
    return genres  

@router.get("/get-all-genres-for-client", response_model=list[genre.GenreBaseForGetAllGenresForClient])
async def get_all_genres(db: Session = Depends(get_db)):
    genres = await genre_service.get_all_genres(db)
    return genres

# post data -----------------------------------------------------------------------------------------------------------
@router.post("/create-genre/", response_model=genre.GenreBase)
async def create_genre(new_genre: genre.GenreCreate, db: Session = Depends(get_db)):
    try:
        create_genre = await genre_service.create_genre(db, new_genre)
        if create_genre is None:
            raise HTTPException(status_code=500, detail="Failed to create genre")
        return create_genre
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# put data -----------------------------------------------------------------------------------------------------------
@router.put("/update-genre-by-id/{id}", response_model=genre.GenreBase)
async def update_genre_by_id(id: int, new_genre: genre.GenreUpdate, db: Session = Depends(get_db)):
    try:
        update_genre = await genre_service.update_genre_by_id(db, id, new_genre)
        if update_genre is None:
            raise HTTPException(status_code=404, detail="Genre not found")
        return update_genre
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# delete data -----------------------------------------------------------------------------------------------------------
@router.delete("/delete-genre-by-id/{id}", status_code=200)
async def delete_genre_by_id(id: int, db: Session = Depends(get_db)):
    try:
        await genre_service.delete_genre_by_id(db, id)
        return {"detail": "Genre deleted successfully"}
    except HTTPException as e:
        raise e 
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")