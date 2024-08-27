from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional
from typing import List, Optional
from app.schemas.artist_base import ArtistBase_Id_Name_Description_Picture

class ArtistSongBase(BaseModel):
    artist_id: int
    song_id: int
    create_at: datetime  
    
    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class ArtistSongCreate(BaseModel):
    artist_id: int
    song_id: int
    create_at: datetime 

class ArtistSongUpdate(BaseModel):
    artist_id: int
    song_id: int
    create_at: datetime

class ArtistSongBaseGetArtist(BaseModel):
    artist: ArtistBase_Id_Name_Description_Picture
    
    class Config:
        from_attributes = True
        arbitrary_types_allowed = True


   