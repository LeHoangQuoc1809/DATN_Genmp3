from pydantic import BaseModel, Field
from datetime import date, datetime
from typing import List, Optional


class UserBaseLogin(BaseModel):
    email: str
    password: str

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

# class UserBaseForLoginWithPassword(BaseModel):
#     email : str
#     name : str
#     birthdate : date  # Đổi thành date thay vì datetime vì chỉ cần ngày sinh
#     phone : Optional[str]
#     password: str 
#     user_type_id: int 
#     picture: str
#     session_id: str

#     class Config:
#         from_attributes = True
#         arbitrary_types_allowed = True

class UserBase(BaseModel):
    email : str
    name : str
    birthdate : date  # Đổi thành date thay vì datetime vì chỉ cần ngày sinh
    phone : Optional[str]
    password: str 
    user_type_id: int 
    picture: str

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class UserCreate(BaseModel):
    email : str
    name : str
    birthdate : datetime
    phone : Optional[str]
    password: str 
    picture: str
    user_type_id: int 
    picture_base64:str
    otp: str

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class UserUpdate(BaseModel):
    name : str
    birthdate : datetime
    phone : str
    password: str 
    user_type_id: int 
    picture: str
