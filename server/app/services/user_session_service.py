from sqlalchemy.orm import Session
from fastapi import HTTPException
from app.models.user_session import User_Session
from app.schemas.user_session import UserSessionCreate
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import func
from datetime import datetime

# get data -----------------------------------------------------------------------------------------------------------
async def get_all_user_sessions(db: Session) -> list:
    return db.query(User_Session).all()

async def get_user_session_by_id(db: Session, id: int):
    return db.query(User_Session).filter(User_Session.id == id).first()

async def get_user_session_by_user_email(db: Session, user_email: str) -> list:
    return db.query(User_Session).filter(User_Session.user_email == user_email).all()

async def get_active_session_by_user_email(db: Session, user_email: str):
    return db.query(User_Session).filter_by(user_email=user_email, active=True).first()

# create data -----------------------------------------------------------------------------------------------------------
async def create_user_session(db: Session, new_user_session: UserSessionCreate) -> User_Session:
    # Kiểm tra nếu new_user_session là None
    if not new_user_session:
        raise HTTPException(status_code=400, detail="Invalid new_user_session data")
    
    # Kiểm tra nếu new_user_session.session_id là None
    if not new_user_session.session_id.strip():
        raise HTTPException(status_code=400, detail="Invalid new_user_session.session_id data")
    
    # Kiểm tra nếu new_user_session.created_at là None
    if not new_user_session.created_at:
        raise HTTPException(status_code=400, detail="Invalid new_user_session.created_at data")
    
    # Kiểm tra nếu new_user_session.last_active_at là None
    if not new_user_session.last_active_at:
        raise HTTPException(status_code=400, detail="Invalid new_user_session.last_active_at data")
    
    # Kiểm tra nếu new_user_session.user_email là None
    if not new_user_session.user_email.strip():
        raise HTTPException(status_code=400, detail="Invalid new_user_session.user_email data")
    
    # Tạo user_upload_song mới và thêm vào cơ sở dữ liệu
    try:
        create_user_session = User_Session(
        session_id=new_user_session.session_id,
        created_at=new_user_session.created_at,
        last_active_at=new_user_session.last_active_at,
        user_email=new_user_session.user_email,
        )
        db.add(create_user_session)
        db.commit()
        db.refresh(create_user_session)
        return create_user_session
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to create the User_Session")

# update data -----------------------------------------------------------------------------------------------------------
async def update_user_session_last_active_by_session_id(db: Session, session_id: str):
    try:
        user_session = db.query(User_Session).filter(User_Session.session_id == session_id).first()
        if not user_session:
            raise HTTPException(status_code=404, detail="User_Session not found")
        user_session.last_active_at = datetime.utcnow()
        db.commit()
        db.refresh(user_session)
        return user_session
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to update the User_Session")

# delete data -----------------------------------------------------------------------------------------------------------
async def delete_user_session_by_id_user_email(db: Session, id: int, user_email: str):
    try:
        delete_user_session = db.query(User_Session).filter(User_Session.id == id, User_Session.user_email == user_email).first()
        if delete_user_session is None:
            raise HTTPException(status_code=404, detail="User_Session not found")
        else:
            db.delete(delete_user_session)
            db.commit()
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to delete the user_session")

