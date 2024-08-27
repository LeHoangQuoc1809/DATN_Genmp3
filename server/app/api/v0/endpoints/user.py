from fastapi import APIRouter, Depends, HTTPException, Body, Request
from sqlalchemy.orm import Session
from typing import List
from app.schemas import user, user_session
from app.models.user import User_Session
from app.core.connectdb import get_db
from app.services import user_service, user_session_service
from app.services.websocket_service import WebSocketManager
from datetime import datetime
import uuid, json

router = APIRouter()
websocket_manager = WebSocketManager()

def generate_unique_session_id():
    return str(uuid.uuid4())

# get data -----------------------------------------------------------------------------------------------------------
@router.get("/", response_model=list[user.UserBase])
async def get_all_users(db: Session = Depends(get_db)):
    users = await user_service.get_all_users(db)
    return users 
 
@router.get("/get-user-by-email/{email}", response_model=user.UserBase)
async def get_user_by_email(email: str, db: Session = Depends(get_db)):
    email = email.strip()  # Loại bỏ khoảng trắng đầu cuối
    user = await user_service.get_user_by_email(db, email)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return user
 
@router.get("/get-user-by-phone/{phone}", response_model=user.UserBase)
async def get_user_by_phone(phone: str, db: Session = Depends(get_db)):
    phone = phone.strip()  # Loại bỏ khoảng trắng đầu cuối
    user = await user_service.get_user_by_phone(db, phone)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.get("/get-users-by-name/{name}", response_model=list[user.UserBase])
async def get_users_by_name(name: str, db: Session = Depends(get_db)):
    name = name.strip()  # Loại bỏ khoảng trắng đầu cuối
    if not name:
        raise HTTPException(status_code=400, detail="Name cannot be empty or whitespace only")
    else:
        users = await user_service.get_users_by_name(db, name)
    return users

@router.get("/get-password-by-email/{email}")
async def get_password_by_email(email: str, db: Session = Depends(get_db)):
    password = await user_service.get_password_by_email(db, email)
    if not password:
        raise HTTPException(status_code=400, detail="Password not found")
    return password

# post data -----------------------------------------------------------------------------------------------------------
@router.post("/send-email-for-forgot-password/")
async def send_email_for_forgot_password(user: user.UserBase):
    try:
        isTrue = await user_service.send_email_for_forgot_password(user)
        print(f'isTrue: {isTrue}')
        if not isTrue:
            raise HTTPException(status_code=500, detail="Failed to send-email-for-forgot-password")
        return isTrue
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    
@router.post("/get-user-for-login-with-password/", response_model=user.UserBase)
async def get_user_for_login_with_password(request: Request, db: Session = Depends(get_db)):
    data = await request.json()
    email = data.get("email")
    password = data.get("password")
    user = await user_service.get_user_for_login_with_password(db, email, password)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.post("/validate-user-for-client/")
async def validate_user_for_client(new_user: user.UserCreate, db: Session = Depends(get_db)):
    try:
        validate_user_for_client = await user_service.validate_user_for_client(db, new_user)
        if not validate_user_for_client:
            raise HTTPException(status_code=500, detail="Failed to validate user")
        return True
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    
@router.post("/create-user-for-login-with-google/", response_model=user.UserBase)
async def create_user_for_login_with_google(new_user: user.UserCreate, db: Session = Depends(get_db)):
    try:
        create_user_for_login_with_google = await user_service.create_user_for_login_with_google(db, new_user)
        if create_user_for_login_with_google is None:
            raise HTTPException(status_code=500, detail="Failed to create user")
        return create_user_for_login_with_google
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    
@router.post("/create-user-for-client/", response_model=user.UserBase)
async def create_user_for_client(new_user: user.UserCreate, db: Session = Depends(get_db)):
    try:
        create_user_for_client = await user_service.create_user_for_client(db, new_user)
        if create_user_for_client is None:
            raise HTTPException(status_code=500, detail="Failed to create user")
        return create_user_for_client
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

@router.post("/login-with-password/")
async def login_with_password(user_login: user.UserBaseLogin, db: Session = Depends(get_db)):
    user_email = user_login.email
    get_user_for_login_with_password = await user_service.get_user_for_login_with_password(db, user_email, user_login.password)
    if get_user_for_login_with_password is None:
        raise HTTPException(status_code=404, detail="User not found")

    # Xóa phiên đăng nhập cũ (nếu có)
    existing_sessions = await user_session_service.get_user_session_by_user_email(db, user_email)
    for session in existing_sessions:
        session.active = False
        db.commit()

    # Tạo phiên đăng nhập mới cho thiết bị hiện tại
    new_session_data = User_Session(
        session_id=generate_unique_session_id(),
        user_email=user_email,
        created_at=datetime.utcnow(),
        last_active_at=datetime.utcnow(),
        active=True
    )
    new_session = await user_session_service.create_user_session(db, new_session_data)

    # Gửi thông báo đăng xuất đến tất cả các thiết bị cũ
    message = {
        "type": "logout",
        "session_id": new_session.session_id
    }
    await websocket_manager.send_message(user_email, json.dumps(message))

    return {"message": "Đăng nhập thành công", "session_id": new_session.session_id}

@router.post("/logout/")
async def logout(email: str, db: Session = Depends(get_db)):
    try:
        # Cập nhật trạng thái phiên đăng nhập hiện tại
        active_session = await user_session_service.get_active_session_by_user_email(db, email)
        if active_session is None:
            raise HTTPException(status_code=404, detail="No active session found")

        # Đánh dấu phiên đăng nhập hiện tại là không còn hoạt động
        active_session.active = False
        db.commit()

        # Gửi thông báo đăng xuất đến tất cả các thiết bị cũ
        message = "Tài khoản của bạn đã được đăng xuất khỏi thiết bị này."
        await websocket_manager.send_message(email, message)

        return {"message": "Đăng xuất thành công"}

    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    
# put data -----------------------------------------------------------------------------------------------------------
@router.put("/update-user-by-email/{email}", response_model=user.UserBase)
async def update_user_by_email(email: str, new_user: user.UserUpdate, db: Session = Depends(get_db)):
    try:
        update_user = await user_service.update_user_by_email(db, email, new_user)
        if update_user is None:
            raise HTTPException(status_code=404, detail="User not found")
        return update_user
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    
@router.put("/update-user-picture-by-email/{email}", response_model=user.UserBase)
async def update_user_picture_by_email(email: str, request: Request, db: Session = Depends(get_db)):
    try:
        data = await request.json()
        new_picture_base64 = data.get("new_picture_base64")
        update_user = await user_service.update_user_picture_by_email(db, email, new_picture_base64)
        if update_user is None:
            raise HTTPException(status_code=404, detail="User not found")
        return update_user
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")  
    
@router.put("/update-user-name-by-email/{email}", response_model=user.UserBase)
async def update_user_name_by_email(email: str, request: Request, db: Session = Depends(get_db)):
    try:
        data = await request.json()
        new_name = data.get("new_name")
        print(f'data: {data}')
        print(f'new_name: {new_name}')
        update_user = await user_service.update_user_name_by_email(db, email, new_name)
        if update_user is None:
            raise HTTPException(status_code=404, detail="User not found")
        return update_user
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

@router.put("/update-user-phone-by-email/{email}", response_model=user.UserBase)
async def update_user_name_by_email(email: str, request: Request, db: Session = Depends(get_db)):
    try:
        data = await request.json()
        new_phone = data.get("new_phone")
        print(f'data: {data}')
        print(f'new_phone: {new_phone}')
        update_user = await user_service.update_user_phone_by_email(db, email, new_phone)
        if update_user is None:
            raise HTTPException(status_code=404, detail="User not found")
        return update_user
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    
@router.put("/update-user-birthdate-by-email/{email}", response_model=user.UserBase)
async def update_user_birthdate_by_email(email: str, request: Request, db: Session = Depends(get_db)):
    try:
        data = await request.json()
        new_birthdate_str  = data.get("new_birthdate")
        new_birthdate = datetime.fromisoformat(new_birthdate_str)  # Convert string to datetime
        print(f'data: {data}')
        print(f'new_birthdate: {new_birthdate}')
        update_user = await user_service.update_user_birthdate_by_email(db, email, new_birthdate)
        if update_user is None:
            raise HTTPException(status_code=404, detail="User not found")
        return update_user
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    
@router.put("/update-user-password-by-email/{email}", response_model=user.UserBase)
async def update_user_password_by_email(email: str, request: Request, db: Session = Depends(get_db)):
    try:
        data = await request.json()
        new_password = data.get("new_password")
        print(f'data: {data}')
        print(f'new_password: {new_password}')
        update_user = await user_service.update_user_password_by_email(db, email, new_password)
        if update_user is None:
            raise HTTPException(status_code=404, detail="User not found")
        return update_user
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    
# delete data -----------------------------------------------------------------------------------------------------------
@router.delete("/delete-user-by-email/{email}", status_code=200)
async def delete_user_by_email(email: str, db: Session = Depends(get_db)):
    try:
        await user_service.delete_user_by_email(db, email)
        return {"detail": "User deleted successfully"}
    except HTTPException as e:
        raise e 
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    