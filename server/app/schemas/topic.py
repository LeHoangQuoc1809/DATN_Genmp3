from pydantic import BaseModel
from typing import List, Optional
from .song import SongBase

class TopicBase(BaseModel):
    id: int
    name: str
    description: Optional[str]
    songs: List[SongBase]=[]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True
        
class TopicBaseForGetAllTopicsForClient(BaseModel):
    id: int
    name: str
    description: Optional[str]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class TopicBaseForGetTop3Topics(BaseModel):
    id: int
    name: str
    description: Optional[str]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class TopicCreate(BaseModel):
    name: str
    description: str

class TopicUpdate(BaseModel):
    name: str
    description: Optional[str] = None