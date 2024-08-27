from pydantic import BaseModel
from typing import List, Optional

class GenreBaseNoSongs(BaseModel):
    id: int
    name: str
    description: Optional[str]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class TopicBaseNoSongs(BaseModel):
    id: int
    name: str
    description: Optional[str]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class ArtistBase_Id_Name_Description_Picture(BaseModel):
    id: int
    name: str
    description: Optional[str]
    picture: Optional[str]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True


class ArtistBase_Name(BaseModel):
    name: str

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

