from sqlalchemy.orm import Session
from fastapi import HTTPException
from app.models.history import History
from app.schemas.history import HistoryCreate, HistoryUpdate
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import func

# get data -----------------------------------------------------------------------------------------------------------
async def get_all_historys(db: Session) -> list:
    return db.query(History).all()

async def get_history_by_id(db: Session, id: int):
    return db.query(History).filter(History.id == id).first()

async def get_historys_by_user_email(db: Session, user_email: str) -> list:
    return db.query(History).filter(History.user_email == user_email).all()

async def get_historys_by_song_id(db: Session, song_id: int) -> list:
    return db.query(History).filter(History.song_id == song_id).all()

async def get_history_by_user_email_song_id(db: Session, user_email: str, song_id: int):
    return db.query(History).filter(History.user_email == user_email, History.song_id == song_id).first()

# create data -----------------------------------------------------------------------------------------------------------
async def create_history(db: Session, new_history: HistoryCreate) -> History:
    # Kiểm tra nếu new_history là None
    if not new_history:
        raise HTTPException(status_code=400, detail="Invalid new_history data")
    
    # Kiểm tra nếu new_history.user_email là None
    if not new_history.user_email:
        raise HTTPException(status_code=400, detail="Invalid new_history.user_email data")
    
    # Kiểm tra nếu new_history.song_id là None
    if not new_history.song_id:
        raise HTTPException(status_code=400, detail="Invalid new_history.song_id data")
    
    # Kiểm tra nếu new_history.time là None
    if not new_history.time:
        raise HTTPException(status_code=400, detail="Invalid new_history.time data")
    
    # Tạo History mới và thêm vào cơ sở dữ liệu
    try:
        create_history = History(
        user_email=new_history.user_email,
        song_id=new_history.song_id,
        time=new_history.time
        )
        db.add(create_history)
        db.commit()
        db.refresh(create_history)
        return create_history
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to create the history")
    
# update data -----------------------------------------------------------------------------------------------------------
async def update_history_by_user_email_song_id(db: Session, user_email: str, song_id: int, new_history: HistoryUpdate) -> History:
    # Lấy dữ liệu old_history từ cơ sở dữ liệu
    old_history = db.query(History).filter(History.user_email == user_email, History.song_id == song_id).first()
    if not old_history:
        raise HTTPException(status_code=404, detail="History not found")

    # Kiểm tra nếu new_history là None
    if not new_history:
        raise HTTPException(status_code=400, detail="Invalid history update data")
    
    # Kiểm tra nếu new_history.user_email là None
    if not new_history.user_email.strip():
        raise HTTPException(status_code=400, detail="Invalid history.user_email update data")
    
    # Kiểm tra nếu new_history.song_id là None
    if not new_history.song_id:
        raise HTTPException(status_code=400, detail="Invalid history.song_id update data")
    
    # Kiểm tra nếu new_history.time là None
    if not new_history.time:
        raise HTTPException(status_code=400, detail="Invalid history.time update data")
    
    # Nếu như có update time
    if old_history.time != new_history.time:
        # Kiểm tra xem new_history.time có tồn tại trong cơ sở dữ liệu hay không
        existing_history = db.query(History).filter(History.time == new_history.time).first()
        if existing_history:
            raise HTTPException(status_code=400, detail="History with this time already exists")
    
    # Cập nhật các trường được chỉ định trong new_history
    for var, value in vars(new_history).items():
        if value is not None:
            setattr(old_history, var, value)

    # Lưu thay đổi vào cơ sở dữ liệu
    try:
        db.commit()
        db.refresh(old_history)
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to update the history")
    
    return old_history

# delete data -----------------------------------------------------------------------------------------------------------
async def delete_history_by_user_email_song_id(db: Session, user_email: str, song_id: int):
    try:
        delete_history = db.query(History).filter(History.user_email == user_email, History.song_id == song_id).first()
        if delete_history is None:
            raise HTTPException(status_code=404, detail="History not found")
        else:
            db.delete(delete_history)
            db.commit()
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to delete the history")
    