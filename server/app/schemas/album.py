from pydantic import BaseModel, validator
from datetime import datetime
from typing import List, Optional
from .artist_base import ArtistBase_Name

class AlbumBase(BaseModel):
    id: int
    name: str
    release_date: str  # for model view
    picture: str
    artist_id: int
    description: Optional[str]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

    @validator('release_date', pre=True)
    def datetime_to_string(cls, value):
        if isinstance(value, datetime):
            return value.isoformat()
        return value
    
class AlbumBase_release_date(BaseModel):
    release_date: str  # for model view

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

    @validator('release_date', pre=True)
    def datetime_to_string(cls, value):
        if isinstance(value, datetime):
            return value.isoformat()
        return value
    
class AlbumBaseForSearch(BaseModel):
    id: int
    name: str
    picture: str
    artist: ArtistBase_Name

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class AlbumCreate(BaseModel):
    name: str
    release_date: datetime
    picture: str
    artist_id: int
    description: str
    picture_base64: str

class AlbumUpdate(BaseModel):
    name: str
    release_date: datetime
    picture: str
    artist_id: int
    description: Optional[str] = None
    picture_base64: str

class AlbumGetAllByAritstId(BaseModel):
    id: int
    name: str
    release_date: datetime
    picture: str
    artist_id: int
    description: Optional[str] = None


