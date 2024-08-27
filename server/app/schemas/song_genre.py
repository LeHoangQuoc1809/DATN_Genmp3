from pydantic import BaseModel
from typing import List, Optional
from typing import List, Optional

class SongGenreBase(BaseModel):
    song_id: int
    genre_id: int
    
    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class SongGenreCreate(BaseModel):
    song_id: int
    genre_id: int

class SongGenreUpdate(BaseModel):
    song_id: int
    genre_id: int


   