from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional


class PlaylistUserBase(BaseModel):
    id: int  
    user_email: str
    playlist_id: int
    
    class Config:
        from_attributes = True
        arbitrary_types_allowed = True



class PlaylistUserCreate(BaseModel):
    user_email: str
    playlist_id: int

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class PlaylistUserUpdate(BaseModel):
    user_email: str
    playlist_id: int
    
    class Config:
        from_attributes = True
        arbitrary_types_allowed = True
   