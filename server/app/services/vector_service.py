from sqlalchemy.orm import Session
from fastapi import HTTPException
from app.models.vector import Vector
from app.schemas.vector import VectorCreate,VectorUpdate
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import func

# get data -----------------------------------------------------------------------------------------------------------
async def get_all_vectors(db: Session) -> list:
    return db.query(Vector).all()

async def get_vector_by_song_id(db: Session, song_id: int):
    return db.query(Vector).filter(Vector.song_id == song_id).first()

# create data -----------------------------------------------------------------------------------------------------------
async def create_vector(db: Session, new_vector: VectorCreate) -> Vector:
    # Kiểm tra nếu new_vector là None
    if not new_vector:
        raise HTTPException(status_code=400, detail="Invalid new_vector data")
    
    # Kiểm tra nếu new_vector.song_id là None
    if not new_vector.song_id:
        raise HTTPException(status_code=400, detail="Invalid new_vector.song_id data")
    
    # Tạo Vector mới và thêm vào cơ sở dữ liệu
    try:
        create_vector = Vector(
        song_id=new_vector.song_id,
        mfcc=new_vector.mfcc,
        tf_idf=new_vector.tf_idf
        )
        db.add(create_vector)
        db.commit()
        db.refresh(create_vector)
        return create_vector
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to create the vector")

# update data -----------------------------------------------------------------------------------------------------------
async def update_vector_by_song_id(db: Session, song_id: int, new_vector: VectorUpdate) -> Vector:
    # Lấy dữ liệu old_vector từ cơ sở dữ liệu
    old_vector = db.query(Vector).filter(Vector.song_id == song_id).first()
    if not old_vector:
        raise HTTPException(status_code=404, detail="Vector not found")

    # Kiểm tra nếu new_vector là None
    if not new_vector:
        raise HTTPException(status_code=400, detail="Invalid vector update data")
    
    # Kiểm tra nếu vector_update.song_id là None
    if not new_vector.song_id:
        raise HTTPException(status_code=400, detail="Invalid vector.song_id update data")
   
    # Cập nhật các trường được chỉ định trong new_vector
    for var, value in vars(new_vector).items():
        if value is not None:
            setattr(old_vector, var, value)

    # Lưu thay đổi vào cơ sở dữ liệu
    try:
        db.commit()
        db.refresh(old_vector)
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to update the vector")
                            
    return old_vector

# delete data -----------------------------------------------------------------------------------------------------------
async def delete_vector_by_song_id(db: Session, song_id: int):
    try:
        delete_vector = db.query(Vector).filter(Vector.song_id == song_id).first()
        if delete_vector is None:
            raise HTTPException(status_code=404, detail="Vector not found")
        else:
            db.delete(delete_vector)
            db.commit()
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to delete the vector")