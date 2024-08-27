from sqlalchemy.orm import Session
from fastapi import HTTPException
from app.models.user import User
from app.schemas.user import UserCreate, UserUpdate, UserBase
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import func
import httpx, random, string, getpass, smtplib
from firebase_admin import auth
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from app.services import verify_service
from typing import Union
import os
import base64
import asyncio
from datetime import datetime, timedelta

# Thời gian sống của OTP là 1 phút
OTP_EXPIRATION_TIME_FOR_CREATE_USER = timedelta(minutes=3)
OTP_EXPIRATION_TIME_FOR_FORGET_PASSWORD = timedelta(minutes=5)

temp_otp_storage_for_create_user = {}

temp_otp_storage_for_forgot_password = {}

async def delete_otp_after_timeout(email: str, storage: dict, time: timedelta):
    await asyncio.sleep(time.total_seconds())
    if email in storage:
        del storage[email]
        print(f'OTP for {email} in {storage} has been deleted after timeout')
        
# get data -----------------------------------------------------------------------------------------------------------
async def get_all_users(db: Session) -> list:
    return db.query(User).all()

async def get_user_by_email(db: Session, email: str):
    return db.query(User).filter(User.email == email).first()

async def get_user_by_phone(db: Session, phone: str):
    return db.query(User).filter(User.phone == phone).first()

async def get_users_by_name(db: Session, name: str) -> list:
    return db.query(User).filter(func.lower(User.name).ilike(f"%{name.lower()}%")).all()

async def get_user_for_login_with_password(db: Session, email: str, password: str):
    return db.query(User).filter(User.email == email, User.password == password).first()

async def get_password_by_email(db: Session, email: str):
    try:
        password_tuple = db.query(User.password).filter(User.email == email).first()
        if password_tuple:
            password = password_tuple[0]  # Lấy giá trị từ tuple
            return password
        return None
    except Exception as e:
        print(f"Error: {e}")
        return None

# create data -----------------------------------------------------------------------------------------------------------
async def send_email_for_forgot_password(user: UserBase) -> bool:
    try:
        # Kiểm tra trong storage xem đã tồn tại otp của email đó chưa, nếu chưa thì gửi, ngược lại báo lỗi
        if user.email not in temp_otp_storage_for_forgot_password:
            # user đã hợp lệ, tiến hành random otp, lưu trữ lại với email user và gửi đi random otp
            otp = ''.join(random.choices(string.digits, k=6)) 

            # Lưu OTP vào biến tạm thời với key là email user và thời gian tạo
            temp_otp_storage_for_forgot_password[user.email] = {'otp': otp, 'created_at': datetime.now()}
            print(f'temp_otp_storage_for_forgot_password[{user.email}]: {temp_otp_storage_for_forgot_password[user.email]}')

            # Tạo một task để xóa OTP sau 5 phút
            asyncio.create_task(delete_otp_after_timeout(user.email, temp_otp_storage_for_forgot_password, OTP_EXPIRATION_TIME_FOR_FORGET_PASSWORD))

            # Gửi otp đến email của user 
            if await verify_service.send_email_for_forgot_password(user, otp):
                print(f"OTP sent successfully")
                return True  
            else:
                print(f"OTP sent failed")
                return False  
        else: 
            # Nếu OTP đã tồn tại, báo lỗi
            raise HTTPException(status_code=400, detail="OTP has already been sent. Please wait for a while before requesting a new one.")
    except HTTPException as e:
        raise HTTPException(status_code=500, detail="An error occurred while trying to before send_email_for_forgot_password")

async def validate_user_for_client(db: Session, new_user: UserCreate) -> bool:
    # Kiểm tra nếu new_user là None
    if not new_user:
        raise HTTPException(status_code=400, detail="Invalid new_user data")
    
    # Kiểm tra nếu new_user.email là None
    if not new_user.email.strip():
        raise HTTPException(status_code=400, detail="Invalid new_user.email data")
    
    # Kiểm tra nếu new_user.name là None
    if not new_user.name.strip():
        raise HTTPException(status_code=400, detail="Invalid new_user.name data")
    
    # Kiểm tra nếu new_user.birthdate là None
    if not new_user.birthdate:
        raise HTTPException(status_code=400, detail="Invalid new_user.birthdate data")
    
    # Kiểm tra nếu new_user.password là None
    if not new_user.password.strip():
        raise HTTPException(status_code=400, detail="Invalid new_user.password data")
    
    # Kiểm tra nếu new_user.user_type_id là None
    if not new_user.user_type_id:
        raise HTTPException(status_code=400, detail="Invalid new_user.user_type_id data")
    
    # Kiểm tra nếu new_user.picture là None
    if not new_user.picture.strip():
        raise HTTPException(status_code=400, detail="Invalid new_user.picture data")
    
    # Kiểm tra xem new_user.email có tồn tại trong cơ sở dữ liệu hay không
    existing_user = db.query(User).filter(User.email == new_user.email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="User with this email already exists")
    
    # # Kiểm tra xem new_user.phone có tồn tại trong cơ sở dữ liệu hay không
    # existing_user = db.query(User).filter(User.phone == new_user.phone).first()
    # if existing_user:
    #     raise HTTPException(status_code=400, detail="User with this phone already exists")

    # Tạo User mới và thêm vào cơ sở dữ liệu
    try:
        create_user = User(
        email=new_user.email,
        name=new_user.name,
        birthdate=new_user.birthdate,
        phone=new_user.phone,
        password=new_user.password,
        user_type_id=new_user.user_type_id,
        picture=new_user.picture
        )
        # Kiểm tra trong storage xem đã tồn tại otp của email đó chưa, nếu chưa thì gửi, ngược lại báo lỗi
        if create_user.email not in temp_otp_storage_for_create_user:
            # user đã hợp lệ, tiến hành random otp, lưu trữ lại với email user và gửi đi random otp
            otp = ''.join(random.choices(string.digits, k=6)) 

            # Lưu OTP vào biến tạm thời với key là email user và thời gian tạo
            temp_otp_storage_for_create_user[create_user.email] = {'otp': otp, 'created_at': datetime.now()}
            print(f'temp_otp_storage_for_create_user[{create_user.email}]: {temp_otp_storage_for_create_user[create_user.email]}')

            # Tạo một task để xóa OTP sau 3 phút
            asyncio.create_task(delete_otp_after_timeout(create_user.email, temp_otp_storage_for_create_user, OTP_EXPIRATION_TIME_FOR_CREATE_USER))

            # Gửi otp đến email của user vừa đựa tạo
            if await verify_service.send_email_for_create_user(new_user, otp):
                print(f"OTP sent successfully")
                return True  
            else:
                print(f"OTP sent failed")
                return False  
        else: 
            # Nếu OTP đã tồn tại, báo lỗi
            raise HTTPException(status_code=400, detail="OTP has already been sent. Please wait for a while before requesting a new one.")
    except HTTPException as e:
        raise HTTPException(status_code=500, detail="An error occurred while trying to before create the user")

async def create_user_for_login_with_google(db: Session, new_user: UserCreate) -> Union[User, None]:
    # Kiểm tra nếu new_user là None
    if not new_user:
        raise HTTPException(status_code=400, detail="Invalid new_user data")
    
    # Kiểm tra nếu new_user.email là None
    if not new_user.email.strip():
        raise HTTPException(status_code=400, detail="Invalid new_user.email data")
    
    # Kiểm tra nếu new_user.name là None
    if not new_user.name.strip():
        raise HTTPException(status_code=400, detail="Invalid new_user.name data")
    
    # Kiểm tra nếu new_user.birthdate là None
    if not new_user.birthdate:
        raise HTTPException(status_code=400, detail="Invalid new_user.birthdate data")
    
    # Kiểm tra nếu new_user.password là None
    if not new_user.password.strip():
        raise HTTPException(status_code=400, detail="Invalid new_user.password data")
    
    # Kiểm tra nếu new_user.user_type_id là None
    if not new_user.user_type_id:
        raise HTTPException(status_code=400, detail="Invalid new_user.user_type_id data")
    
    # Kiểm tra nếu new_user.picture là None
    if not new_user.picture.strip():
        raise HTTPException(status_code=400, detail="Invalid new_user.picture data")
    
    # Kiểm tra xem new_user.email có tồn tại trong cơ sở dữ liệu hay không
    existing_user = db.query(User).filter(User.email == new_user.email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="User with this email already exists")
    
    # Nếu phone khác null thì kiểm tra xem new_user.phone có tồn tại trong cơ sở dữ liệu hay không
    if new_user.phone:
        existing_user = db.query(User).filter(User.phone == new_user.phone).first()
        if existing_user:
            raise HTTPException(status_code=400, detail="User with this phone already exists")

    # Tạo User mới và thêm vào cơ sở dữ liệu
    try:
        create_user = User(
        email=new_user.email,
        name=new_user.name,
        birthdate=new_user.birthdate,
        phone=new_user.phone,
        password=new_user.password,
        user_type_id=new_user.user_type_id,
        picture=new_user.picture
        )
        db.add(create_user)
        db.commit()
        db.refresh(create_user)
        # Vì User đăng nhập bằng google mà account google đó không có imageUrl thì picture_base64 = '' 
        # nên phải kiểm tra new_user.picture_base64 
        if new_user.picture_base64:
            # Giải mã base64 và lưu file hình ảnh
            picture_data = base64.b64decode(new_user.picture_base64)
            picture_path = f"app/uploads/images/user/{create_user.picture}.png"
            with open(picture_path, "wb") as picture:
                picture.write(picture_data)
                print(f"Đã thêm user.picture : {picture_path}")

        return create_user
    
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to create the user")
    
async def create_user_for_client(db: Session, new_user: UserCreate) -> Union[User, None]:
    # Kiểm tra nếu new_user là None
    if not new_user:
        raise HTTPException(status_code=400, detail="Invalid new_user data")
    
    # Kiểm tra nếu new_user.email là None
    if not new_user.email.strip():
        raise HTTPException(status_code=400, detail="Invalid new_user.email data")
    
    # Kiểm tra nếu new_user.name là None
    if not new_user.name.strip():
        raise HTTPException(status_code=400, detail="Invalid new_user.name data")
    
    # Kiểm tra nếu new_user.birthdate là None
    if not new_user.birthdate:
        raise HTTPException(status_code=400, detail="Invalid new_user.birthdate data")
    
    # Kiểm tra nếu new_user.password là None
    if not new_user.password.strip():
        raise HTTPException(status_code=400, detail="Invalid new_user.password data")
    
    # Kiểm tra nếu new_user.user_type_id là None
    if not new_user.user_type_id:
        raise HTTPException(status_code=400, detail="Invalid new_user.user_type_id data")
    
    # Kiểm tra nếu new_user.picture là None
    if not new_user.picture.strip():
        raise HTTPException(status_code=400, detail="Invalid new_user.picture data")
    
    # Kiểm tra xem new_user.email có tồn tại trong cơ sở dữ liệu hay không
    existing_user = db.query(User).filter(User.email == new_user.email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="User with this email already exists")
    
    # Nếu phone khác null thì kiểm tra xem new_user.phone có tồn tại trong cơ sở dữ liệu hay không
    if new_user.phone:
        existing_user = db.query(User).filter(User.phone == new_user.phone).first()
        if existing_user:
            raise HTTPException(status_code=400, detail="User with this phone already exists")

    # Tạo User mới và thêm vào cơ sở dữ liệu
    try:
        create_user = User(
        email=new_user.email,
        name=new_user.name,
        birthdate=new_user.birthdate,
        phone=new_user.phone,
        password=new_user.password,
        user_type_id=new_user.user_type_id,
        picture=new_user.picture
        )
        db.add(create_user)
        db.commit()
        db.refresh(create_user)
        # Vì User đăng nhập bằng google mà account google đó không có imageUrl thì picture_base64 = '' 
        # nên phải kiểm tra new_user.picture_base64 
        if new_user.picture_base64:
            # Giải mã base64 và lưu file hình ảnh
            picture_data = base64.b64decode(new_user.picture_base64)
            picture_path = f"app/uploads/images/user/{create_user.picture}.png"
            with open(picture_path, "wb") as picture:
                picture.write(picture_data)
                print(f"Đã thêm user.picture : {picture_path}")

        return create_user
    
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to create the user")
    
# update data -----------------------------------------------------------------------------------------------------------
async def update_user_by_email(db: Session, email: str, new_user: UserUpdate) -> User:
    # Lấy dữ liệu old_user từ cơ sở dữ liệu
    old_user = db.query(User).filter(User.email == email).first()
    if not old_user:
        raise HTTPException(status_code=404, detail="User not found")

    # Kiểm tra nếu new_user là None
    if not new_user:
        raise HTTPException(status_code=400, detail="Invalid user update data")
    
    # Kiểm tra nếu new_user.name là None
    if not new_user.name.strip():
        raise HTTPException(status_code=400, detail="Invalid user.name update data")
    
    # Kiểm tra nếu new_user.birthdate là None
    if not new_user.birthdate:
        raise HTTPException(status_code=400, detail="Invalid user.birthdate update data")
    
    # Kiểm tra nếu new_user.phone là None
    if not new_user.phone.strip():
        raise HTTPException(status_code=400, detail="Invalid user.phone update data")
    
    # Kiểm tra nếu new_user.password là None
    if not new_user.password.strip():
        raise HTTPException(status_code=400, detail="Invalid user.password update data")
    
    # Kiểm tra nếu new_user.user_type_id là None
    if not new_user.user_type_id:
        raise HTTPException(status_code=400, detail="Invalid user.user_type_id update data")
    
    # Kiểm tra nếu new_user.picture là None
    if not new_user.picture.strip():
        raise HTTPException(status_code=400, detail="Invalid user.picture update data")
    
    # Nếu như có update phone
    if old_user.phone != new_user.phone:
        # Kiểm tra xem new_user.phone có tồn tại trong cơ sở dữ liệu hay không
        existing_user = db.query(User).filter(User.phone == new_user.phone).first()
        print(existing_user)
        if existing_user:
            raise HTTPException(status_code=400, detail="User with this phone already exists")

    # Cập nhật các trường được chỉ định trong new_user
    for var, value in vars(new_user).items():
        if value is not None:
            setattr(old_user, var, value)

    # Lưu thay đổi vào cơ sở dữ liệu
    try:
        db.commit()
        db.refresh(old_user)
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to update the user")
    
    return old_user

async def update_user_picture_by_email(db: Session, email: str, new_picture_base64: str) -> User:
    # Lấy dữ liệu old_user từ cơ sở dữ liệu
    old_user = db.query(User).filter(User.email == email).first()
    if not old_user:
        raise HTTPException(status_code=404, detail="User not found")

    # Kiểm tra nếu new_picture_base64 là None
    if not new_picture_base64:
        raise HTTPException(status_code=400, detail="Invalid user.picture update data")

    # Lưu thay đổi vào cơ sở dữ liệu
    try:
        old_user.picture = email
        db.commit()
        db.refresh(old_user)

        # Giải mã base64 và lưu file hình ảnh
        picture_data = base64.b64decode(new_picture_base64)
        picture_path = f"app/uploads/images/user/{email}.png"
        with open(picture_path, "wb") as picture:
            picture.write(picture_data)
            print(f"Đã thêm user.picture : {picture_path}")

    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to update picture the user")
    
    return old_user

async def update_user_name_by_email(db: Session, email: str, new_name: str) -> User:
    # Lấy dữ liệu old_user từ cơ sở dữ liệu
    old_user = db.query(User).filter(User.email == email).first()
    if not old_user:
        raise HTTPException(status_code=404, detail="User not found")

    # Kiểm tra nếu new_name là None
    if not new_name.strip():
        raise HTTPException(status_code=400, detail="Invalid user.name update data")

    # Lưu thay đổi vào cơ sở dữ liệu
    try:
        old_user.name = new_name
        db.commit()
        db.refresh(old_user)
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to update name the user")
    
    return old_user

async def update_user_phone_by_email(db: Session, email: str, new_phone: str) -> User:
    # Lấy dữ liệu old_user từ cơ sở dữ liệu
    old_user = db.query(User).filter(User.email == email).first()
    if not old_user:
        raise HTTPException(status_code=404, detail="User not found")

    # # Kiểm tra nếu new_phone là None
    # if not new_phone.strip():
    #     raise HTTPException(status_code=400, detail="Invalid user.phone update data")

    # Lưu thay đổi vào cơ sở dữ liệu
    try:
        old_user.phone = new_phone
        db.commit()
        db.refresh(old_user)
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to update phone the user")
    
    return old_user

async def update_user_password_by_email(db: Session, email: str, new_password: str) -> User:
    # Lấy dữ liệu old_user từ cơ sở dữ liệu
    old_user = db.query(User).filter(User.email == email).first()
    if not old_user:
        raise HTTPException(status_code=404, detail="User not found")

    # Kiểm tra nếu new_password là None
    if not new_password.strip():
        raise HTTPException(status_code=400, detail="Invalid user.password update data")

    # Lưu thay đổi vào cơ sở dữ liệu
    try:
        old_user.password = new_password
        db.commit()
        db.refresh(old_user)
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to update password the user")
    
    return old_user

async def update_user_birthdate_by_email(db: Session, email: str, new_birthdate: datetime) -> User:
    # Lấy dữ liệu old_user từ cơ sở dữ liệu
    old_user = db.query(User).filter(User.email == email).first()
    if not old_user:
        raise HTTPException(status_code=404, detail="User not found")

    # Kiểm tra nếu new_birthdate là None
    if not new_birthdate:
        raise HTTPException(status_code=400, detail="Invalid user.birthdate update data")

    # Lưu thay đổi vào cơ sở dữ liệu
    try:
        old_user.birthdate = new_birthdate
        db.commit()
        db.refresh(old_user)
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to update phone the user")
    
    return old_user

# delete data -----------------------------------------------------------------------------------------------------------
async def delete_user_by_email(db: Session, email: str):
    try:
        delete_user = db.query(User).filter(User.email == email).first()
        if delete_user is None:
            raise HTTPException(status_code=404, detail="User not found")
        else:
            db.delete(delete_user)
            db.commit()
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to delete the user")
 