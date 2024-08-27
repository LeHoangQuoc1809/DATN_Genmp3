from pydantic import BaseModel
from typing import List, Optional
from .user import UserBase

class UserTypeBase(BaseModel):
    id: int
    name: str
    description: Optional[str]
    users: List[UserBase]=[]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True



class UserTypeCreate(BaseModel):
    name: str
    description: str

class UserTypeUpdate(BaseModel):
    name: str
    description: Optional[str] = None