from pydantic import BaseModel
from datetime import date, datetime
from typing import List, Optional
from .playlist_song import PlaylistSongBase
from .song import SongBase

class PlaylistBase(BaseModel):
    id: int
    name: str
    description: Optional[str]
    modify_date: datetime  # Đổi thành date thay vì datetime vì chỉ cần ngày sinh
    picture: Optional[str]
    playlist_songs: List[PlaylistSongBase] = []
    songs: List[SongBase]=[]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class PlaylistBaseForCreatePlaylistForClient(BaseModel):
    id: int
    name: str
    description: Optional[str]
    modify_date: datetime  # Đổi thành date thay vì datetime vì chỉ cần ngày sinh
    picture: Optional[str]
    is_admin: Optional[bool]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class PlaylistBaseForGetAllPlaylistsByUserEmail(BaseModel):
    id: int
    name: str
    description: Optional[str]
    modify_date: datetime  # Đổi thành date thay vì datetime vì chỉ cần ngày sinh
    picture: Optional[str]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class PlaylistBaseForSearch(BaseModel):
    id: int
    name: str
    picture: Optional[str]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class PlaylistCreate(BaseModel):
    name: str
    description: Optional[str]
    modify_date: datetime
    picture: Optional[str]
    picture_base64: Optional[str]
    song_ids: Optional[List[int]]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True
    
class PlaylistCreateForClient(BaseModel):
    user_email: str
    name: str
    description: Optional[str]
    modify_date: datetime
    picture: Optional[str]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class PlaylistUpdate(BaseModel):
    name: str
    description: Optional[str] = None
    modify_date: datetime
    picture: Optional[str] = None
    picture_base64: Optional[str]
    song_ids: Optional[List[int]]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True
        
class PlaylistBaseId(BaseModel):
    id: str

class PlaylistBaseName(BaseModel):
    name: str

class PlaylistBaseDescription(BaseModel):
    description: str

class PlaylistBaseModifyDate(BaseModel):
    modify_date: date  # Đổi thành date thay vì datetime vì chỉ cần ngày sinh

class PlaylistBasePicture(BaseModel):
    picture: str

class PlaylistBasePlaylistSongs(BaseModel):
    playlist_songs: List[PlaylistSongBase] = []

class PlaylistBasetSongs(BaseModel):
    songs: List[SongBase]=[]