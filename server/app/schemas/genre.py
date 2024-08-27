from pydantic import BaseModel
from typing import List, Optional
from .song import SongBase

class GenreBase(BaseModel):
    id: int
    name: str
    description: Optional[str]
    songs: List[SongBase]=[]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class GenreBaseForGetAllGenresForClient(BaseModel):
    id: int
    name: str
    description: Optional[str]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class GenreBaseForGetTop3Genres(BaseModel):
    id: int
    name: str
    description: Optional[str]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class GenreCreate(BaseModel):
    name: str
    description: str

class GenreUpdate(BaseModel):
    name: str
    description: Optional[str] = None