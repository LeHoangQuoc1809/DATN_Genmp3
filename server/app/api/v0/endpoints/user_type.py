from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.schemas import user_type
from app.core.connectdb import get_db
from app.services import user_type_service

router = APIRouter()

# get data -----------------------------------------------------------------------------------------------------------
@router.get("/", response_model=list[user_type.UserTypeBase])
async def get_all_user_types(db: Session = Depends(get_db)):
    user_types = await user_type_service.get_all_user_types(db)
    return user_types  

@router.get("/get-user-type-by-id/{id}", response_model=user_type.UserTypeBase)
async def get_user_type_by_id(id: int, db: Session = Depends(get_db)):
    user_type = await user_type_service.get_user_type_by_id(db, id)
    if user_type is None:
        raise HTTPException(status_code=404, detail="User_type not found")
    return user_type

# post data -----------------------------------------------------------------------------------------------------------
@router.post("/create-user-type/", response_model=user_type.UserTypeBase)
async def create_user_type(new_user_type: user_type.UserTypeCreate, db: Session = Depends(get_db)):
    try:
        create_user_type = await user_type_service.create_user_type(db, new_user_type)
        if create_user_type is None:
            raise HTTPException(status_code=500, detail="Failed to create user_type")
        return create_user_type
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# put data -----------------------------------------------------------------------------------------------------------
@router.put("/update-user-type-by-id/{id}", response_model=user_type.UserTypeBase)
async def update_user_type_by_id(id: int, new_user_type: user_type.UserTypeUpdate, db: Session = Depends(get_db)):
    try:
        update_user_type = await user_type_service.update_user_type_by_id(db, id, new_user_type)
        if update_user_type is None:
            raise HTTPException(status_code=404, detail="User_type not found")
        return update_user_type
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# delete data -----------------------------------------------------------------------------------------------------------
@router.delete("/delete-user-type-by-id/{id}", status_code=200)
async def delete_user_type_by_id(id: int, db: Session = Depends(get_db)):
    try:
        await user_type_service.delete_user_type_by_id(db, id)
        return {"detail": "User_type deleted successfully"}
    except HTTPException as e:
        raise e 
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    
    
    