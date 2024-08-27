from sqlalchemy.orm import Session
from fastapi import HTTPException
from app.models.genre import Genre
from app.schemas.genre import GenreCreate,GenreUpdate
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import func

# get data -----------------------------------------------------------------------------------------------------------
async def get_all_genres(db: Session) -> list:
    return db.query(Genre).all()

async def get_genre_by_id(db: Session, id: int):
    return db.query(Genre).filter(Genre.id == id).first()

async def get_genres_by_name(db: Session, name: str) -> list:
    return db.query(Genre).filter(func.lower(Genre.name).ilike(f"%{name.lower()}%")).all()

async def get_top_3_genres(db: Session) -> list:
    return db.query(Genre).limit(3).all()

# create data -----------------------------------------------------------------------------------------------------------
async def create_genre(db: Session, new_genre: GenreCreate) -> Genre:
    # Kiểm tra nếu new_genre là None
    if not new_genre:
        raise HTTPException(status_code=400, detail="Invalid new_genre data")
    
    # Kiểm tra nếu new_genre.name là None
    if not new_genre.name.strip():
        raise HTTPException(status_code=400, detail="Invalid new_genre.name data")
    
    # Kiểm tra xem new_genre.name có tồn tại trong cơ sở dữ liệu hay không
    existing_genre = db.query(Genre).filter(Genre.name == new_genre.name).first()
    if existing_genre:
        raise HTTPException(status_code=400, detail="Genre with this name already exists")

    # Tạo Genre mới và thêm vào cơ sở dữ liệu
    try:
        create_genre = Genre(
        name=new_genre.name,
        description=new_genre.description,
        )
        db.add(create_genre)
        db.commit()
        db.refresh(create_genre)
        return create_genre
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to create the genre")
    
# update data -----------------------------------------------------------------------------------------------------------
async def update_genre_by_id(db: Session, id: int, new_genre: GenreUpdate) -> Genre: 
    # Lấy dữ liệu old_genre từ cơ sở dữ liệu
    old_genre = db.query(Genre).filter(Genre.id == id).first()
    if not old_genre:
        raise HTTPException(status_code=404, detail="Genre not found")

    # Kiểm tra nếu new_genre là None
    if not new_genre:
        raise HTTPException(status_code=400, detail="Invalid genre update data")
    
    # Kiểm tra nếu new_genre.name là None
    if not new_genre.name.strip():
        raise HTTPException(status_code=400, detail="Invalid genre.name update data")
    
    # Nếu như có update name
    if old_genre.name != new_genre.name:
        # Kiểm tra xem new_genre.name có tồn tại trong cơ sở dữ liệu hay không
        existing_genre = db.query(Genre).filter(Genre.name == new_genre.name).first()
        if existing_genre:
            raise HTTPException(status_code=400, detail="Genre with this name already exists")
   
    # Cập nhật các trường được chỉ định trong new_genre
    for var, value in vars(new_genre).items():
        if value is not None:
            setattr(old_genre, var, value)

    # Lưu thay đổi vào cơ sở dữ liệu
    try:
        db.commit()
        db.refresh(old_genre)
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to update the genre")
    
    return old_genre

# delete data -----------------------------------------------------------------------------------------------------------
async def delete_genre_by_id(db: Session, id: int):
    try:
        delete_genre = db.query(Genre).filter(Genre.id == id).first()
        if delete_genre is None:
            raise HTTPException(status_code=404, detail="Genre not found")
        else:
            db.delete(delete_genre)
            db.commit()
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to delete the genre")