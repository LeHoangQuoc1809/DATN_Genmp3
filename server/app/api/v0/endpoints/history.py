from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.schemas import history
from app.core.connectdb import get_db
from app.services import history_service

router = APIRouter()

# get data -----------------------------------------------------------------------------------------------------------
@router.get("/", response_model=list[history.HistoryBase])
async def get_all_historys(db: Session = Depends(get_db)):
    historys = await history_service.get_all_historys(db)
    return historys 
 
@router.get("/get-history-by-id/{id}", response_model=history.HistoryBase)
async def get_history_by_id(id: int, db: Session = Depends(get_db)):
    history = await history_service.get_history_by_id(db, id)
    if history is None:
        raise HTTPException(status_code=404, detail="History not found")
    return history

@router.get("/get-historys-by-user-email/{user_email}", response_model=list[history.HistoryBase])
async def get_historys_by_user_email(user_email: str, db: Session = Depends(get_db)):
    historys = await history_service.get_historys_by_user_email(db, user_email)
    return historys
 
@router.get("/get-historys-by-song-id/{song_id}", response_model=list[history.HistoryBase])
async def get_historys_by_song_id(song_id: int, db: Session = Depends(get_db)):
    historys = await history_service.get_historys_by_song_id(db, song_id)
    return historys

@router.get("/get-history-by-user-email-song-id/{user_email}/{song_id}", response_model=history.HistoryBase)
async def get_history_by_user_email_song_id(user_email: str, song_id:int, db: Session = Depends(get_db)):
    history = await history_service.get_history_by_user_email_song_id(db, user_email, song_id)
    if history is None:
        raise HTTPException(status_code=404, detail="History not found")
    return history

# post data -----------------------------------------------------------------------------------------------------------
@router.post("/create-history/", response_model=history.HistoryBase)
async def create_history(new_history: history.HistoryCreate, db: Session = Depends(get_db)):
    try:
        create_history = await history_service.create_history(db, new_history)
        if create_history is None:
            raise HTTPException(status_code=500, detail="Failed to create history")
        return create_history
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# put data -----------------------------------------------------------------------------------------------------------
@router.put("/update-history-by-user-email-song-id/{user_email}/{song_id}", response_model=history.HistoryBase)
async def update_history_by_user_email_song_id(user_email: str, song_id: int, new_history: history.HistoryUpdate, db: Session = Depends(get_db)):
    try:
        update_history = await history_service.update_history_by_user_email_song_id(db, user_email, song_id, new_history)
        if update_history is None:
            raise HTTPException(status_code=404, detail="History not found")
        return update_history
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# delete data -----------------------------------------------------------------------------------------------------------
@router.delete("/delete-history-by-user-email-song-id/{user_email}/{song_id}", status_code=200)
async def delete_history_by_user_email_song_id(user_email: str, song_id: int, db: Session = Depends(get_db)):
    try:
        await history_service.delete_history_by_user_email_song_id(db, user_email, song_id)
        return {"detail": "History deleted successfully"}
    except HTTPException as e:
        raise e 
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    