from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional


class RecommendedPlaylistBase(BaseModel):
    id: int  
    user_email: str
    playlist_id: int
    
    class Config:
        from_attributes = True
        arbitrary_types_allowed = True



class RecommendedPlaylistCreate(BaseModel):
    user_email: str
    playlist_id: int

class RecommendedPlaylistUpdate(BaseModel):
    user_email: str
    playlist_id: int

   