from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional


class HistoryBase(BaseModel):
    id: int
    time: datetime
    user_email: str  
    song_id: int
    
    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class HistoryCreate(BaseModel):
    time: datetime
    user_email: str  
    song_id: int

class HistoryUpdate(BaseModel):
    time: datetime
    user_email: str  
    song_id: int

   