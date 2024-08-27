from sqlalchemy.orm import Session
from fastapi import HTTPException
from app.models.user_type import User_Type
from app.schemas.user_type import UserTypeCreate,UserTypeUpdate
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import func

# get data -----------------------------------------------------------------------------------------------------------
async def get_all_user_types(db: Session) -> list:
    return db.query(User_Type).all()

async def get_user_type_by_id(db: Session, id: int):
    return db.query(User_Type).filter(User_Type.id == id).first()

# create data -----------------------------------------------------------------------------------------------------------
async def create_user_type(db: Session, new_user_type: UserTypeCreate) -> User_Type:
    # Kiểm tra nếu new_user_type là None
    if not new_user_type:
        raise HTTPException(status_code=400, detail="Invalid new_user_type data")
    
    # Kiểm tra nếu new_user_type.name là None
    if not new_user_type.name.strip():
        raise HTTPException(status_code=400, detail="Invalid new_user_type.name data")
    
    # Kiểm tra xem new_user_type.name có tồn tại trong cơ sở dữ liệu hay không
    existing_user_type = db.query(User_Type).filter(User_Type.name == new_user_type.name).first()
    if existing_user_type:
        raise HTTPException(status_code=400, detail="User_Type with this name already exists")

    # Tạo User_Type mới và thêm vào cơ sở dữ liệu
    try:
        create_topic = User_Type(
        name=new_user_type.name,
        description=new_user_type.description,
        )
        db.add(create_topic)
        db.commit()
        db.refresh(create_topic)
        return create_topic
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to create the User_Type")

# update data -----------------------------------------------------------------------------------------------------------
async def update_user_type_by_id(db: Session, id: int, new_user_type: UserTypeUpdate) -> User_Type:
    # Lấy dữ liệu old_user_type từ cơ sở dữ liệu
    old_user_type = db.query(User_Type).filter(User_Type.id == id).first()
    if not old_user_type:
        raise HTTPException(status_code=404, detail="User_Type not found")

    # Kiểm tra nếu new_user_type là None
    if not new_user_type:
        raise HTTPException(status_code=400, detail="Invalid user_type update data")
    
    # Kiểm tra nếu new_user_type.name là None
    if not new_user_type.name.strip():
        raise HTTPException(status_code=400, detail="Invalid user_type.name update data")
    
    # Nếu như có update name
    if old_user_type.name != new_user_type.name:
        # Kiểm tra xem new_user_type.name có tồn tại trong cơ sở dữ liệu hay không
        existing_user_type = db.query(User_Type).filter(User_Type.name == new_user_type.name).first()
        if existing_user_type:
            raise HTTPException(status_code=400, detail="User_Type with this name already exists")
   
    # Cập nhật các trường được chỉ định trong new_user_type
    for var, value in vars(new_user_type).items():
        if value is not None:
            setattr(old_user_type, var, value)

    # Lưu thay đổi vào cơ sở dữ liệu
    try:
        db.commit()
        db.refresh(old_user_type)
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to update the user_type")
                            
    return old_user_type

# delete data -----------------------------------------------------------------------------------------------------------
async def delete_user_type_by_id(db: Session, id: int):
    try:
        delete_user_type = db.query(User_Type).filter(User_Type.id == id).first()
        if delete_user_type is None:
            raise HTTPException(status_code=404, detail="User_Type not found")
        else:
            db.delete(delete_user_type)
            db.commit()
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to delete the user_type")

