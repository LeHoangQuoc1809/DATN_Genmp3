from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional
from .song import SongBase

class PlaylistSongBase(BaseModel):
    id: int
    playlist_id: int
    song_id: int

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class PlaylistSongCreate(BaseModel):
    playlist_id: int
    song_id: int

class PlaylistSongUpdate(BaseModel):
    playlist_id: int
    song_id: int