from pydantic import BaseModel
from typing import Optional, Any, Dict, Any

class VectorBase(BaseModel):
    song_id: int
    mfcc: Optional[Any] = None
    tf_idf: Optional[Any] = None

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class VectorCreate(BaseModel):
    song_id: int
    mfcc: Optional[Dict[str, Any]] = None
    tf_idf: Optional[Dict[str, Any]] = None
    

class VectorUpdate(BaseModel):
    pass

class Vector(BaseModel):
    pass
