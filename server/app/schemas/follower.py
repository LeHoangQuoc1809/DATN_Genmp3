from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional
from app.schemas.artist import ArtistBaseName


class FollowerBase(BaseModel):
    user_email: str  
    artist_id: int
    artist: ArtistBaseName
    
    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class FollowerCreate(BaseModel):
    user_email: str  
    artist_id: int

class FollowerUpdate(BaseModel):
    user_email: str
    artist_id: int
   