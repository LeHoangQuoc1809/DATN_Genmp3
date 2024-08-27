from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional

class UserSessionBase(BaseModel):
    user_email: str = Field(..., example="user@example.com")
    session_id: str = Field(..., example="unique-session-id")
    created_at: Optional[datetime] = Field(None, example="2024-07-24T12:00:00Z")
    last_active_at: Optional[datetime] = Field(None, example="2024-07-24T12:00:00Z")
    active: Optional[bool] = Field(True, example=True)

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class UserSessionCreate(UserSessionBase):
    pass

class UserSessionUpdate(BaseModel):
    last_active_at: Optional[datetime] = Field(None, example="2024-07-24T12:00:00Z")
    active: Optional[bool] = Field(True, example=True)

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class UserSession(UserSessionBase):
    id: int = Field(..., example=1)

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True