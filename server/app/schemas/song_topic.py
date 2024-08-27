from pydantic import BaseModel
from typing import List, Optional
from typing import List, Optional

class SongTopicBase(BaseModel):
    song_id: int
    topic_id: int
    
    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class SongTopicCreate(BaseModel):
    song_id: int
    topic_id: int

class SongTopicUpdate(BaseModel):
    song_id: int
    topic_id: int


   