from pydantic import BaseModel, Field
from datetime import datetime, time
from typing import Optional

class UserUploadSongBase(BaseModel):
    id: int
    name: str
    upload_at: datetime
    lyric: Optional[str] = Field(None, description="Text field for storing lyrics, can be None")  # Allow None
    duration: time
    user_email: str

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class UserUploadSongCreate(BaseModel):
    name: str
    upload_at: datetime
    lyric: Optional[str]
    duration: time
    user_email: str



