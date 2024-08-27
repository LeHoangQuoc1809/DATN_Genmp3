from fastapi import APIRouter, Depends, HTTPException, Form, Body
from sqlalchemy.orm import Session
from typing import List
from app.schemas import user
from app.core.connectdb import get_db
from app.services import user_service
import base64
from app.services.user_service import temp_otp_storage_for_create_user, temp_otp_storage_for_forgot_password 

router = APIRouter()


@router.post("/otp-resend-for-create-user/")
async def otp_resend_for_create_user(user: user.UserCreate, db: Session = Depends(get_db)):
    try:
        stored_otp = temp_otp_storage_for_create_user.get(user.email)
        otp = stored_otp['otp']
        print(f'temp_otp_storage_for_create_user:{otp}')
        if otp and otp == user.otp:
            print(f'==============================otp-resend-for-create-user đã đúng=====================================')
            del temp_otp_storage_for_create_user[user.email]
            print(f'============================đã xóa temp_otp_storage_for_create_user==================================')
            create_user_for_client = await user_service.create_user_for_client(db,user)
            if create_user_for_client is None:
                raise HTTPException(status_code=500, detail="Failed to create user")
            return create_user_for_client
        else:
            raise HTTPException(status_code=400, detail="Invalid OTP")
    except Exception as e:
        # Handle exceptions
        raise HTTPException(status_code=500, detail=f"Failed to resend OTP: {str(e)}")
    
@router.post("/otp-resend-for-forgot-password/")
async def otp_resend_for_forgot_password(user: user.UserCreate, db: Session = Depends(get_db)):
    try:
        stored_otp = temp_otp_storage_for_forgot_password.get(user.email)
        otp = stored_otp['otp']
        print(f'temp_otp_storage_for_forgot_password:{otp}')
        if otp and otp == user.otp:
            print(f'==============================otp-resend-for-forgot-password đã đúng=====================================')
            del temp_otp_storage_for_forgot_password[user.email]
            print(f'============================đã xóa temp_otp_storage_for_forgot_password==================================')
            return True
        else:
            raise HTTPException(status_code=400, detail="Invalid OTP")
    except Exception as e:
        # Handle exceptions
        raise HTTPException(status_code=500, detail=f"Failed to resend OTP: {str(e)}")
    
