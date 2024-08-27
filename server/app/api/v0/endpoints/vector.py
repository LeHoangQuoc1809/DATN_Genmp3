from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.schemas import vector
from app.core.connectdb import get_db
from app.services import vector_service

router = APIRouter()

# get data -----------------------------------------------------------------------------------------------------------
@router.get("/", response_model=list[vector.VectorBase])
async def get_all_vectors(db: Session = Depends(get_db)):
    vectors = await vector_service.get_all_vectors(db)
    return vectors  

@router.get("/get-vector-by-song-id/{song_id}", response_model=vector.VectorBase)
async def get_vector_by_song_id(song_id: int, db: Session = Depends(get_db)):
    vector = await vector_service.get_vector_by_song_id(db, song_id)
    if vector is None:
        raise HTTPException(status_code=404, detail="Vector not found")
    return vector

# post data -----------------------------------------------------------------------------------------------------------
@router.post("/create-vector/", response_model=vector.VectorBase)
async def create_topic(new_vector: vector.VectorCreate, db: Session = Depends(get_db)):
    try:
        create_vector = await vector_service.create_vector(db, new_vector)
        if create_vector is None:
            raise HTTPException(status_code=500, detail="Failed to create vector")
        return create_vector
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# put data -----------------------------------------------------------------------------------------------------------
@router.put("/update-vector-by-song-id/{song_id}", response_model=vector.VectorBase)
async def update_vector_by_song_id(song_id: int, new_vector: vector.VectorUpdate, db: Session = Depends(get_db)):
    try:
        update_vector = await vector_service.update_vector_by_song_id(db, song_id, new_vector)
        if update_vector is None:
            raise HTTPException(status_code=404, detail="Vector not found")
        return update_vector
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# delete data -----------------------------------------------------------------------------------------------------------
@router.delete("/delete-vector-by-song-id/{song_id}", status_code=200)
async def delete_vector_by_song_id(song_id: int, db: Session = Depends(get_db)):
    try:
        await vector_service.delete_vector_by_song_id(db, song_id)
        return {"detail": "Vector deleted successfully"}
    except HTTPException as e:
        raise e 
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    
    
    