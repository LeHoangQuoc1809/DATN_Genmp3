from pydantic import BaseModel, Field
from datetime import time
import datetime
from typing import List, Optional
from .artist_song import ArtistSongBase
from .artist_base import GenreBaseNoSongs, TopicBaseNoSongs, ArtistBase_Id_Name_Description_Picture, ArtistBase_Name
from .album import AlbumBase_release_date

class SongBase_No_Artists(BaseModel):
    id : int
    name : str
    duration : time
    picture : str
    lyric: Optional[str] = Field(None, description="Text field for storing lyrics, can be None")  # Allow None
    listen_count: int = Field(..., description="BigInteger field for storing listen count")  # Use int with description for clarity
    album_id: int

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class SongBase(SongBase_No_Artists):
    # id : int
    # name : str
    # duration : time
    # picture : str
    # lyric: Optional[str] = Field(None, description="Text field for storing lyrics, can be None")  # Allow None
    # listen_count: int = Field(..., description="BigInteger field for storing listen count")  # Use int with description for clarity
    # album_id: int
    artist_songs: List[ArtistSongBase]=[]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class SongBaseForGetTop5SongsListenCountMax(BaseModel):
    id : int
    name : str
    picture : str
    artists: List[ArtistBase_Name]=[]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class SongBaseForGetTop100SongsListenCountMax(BaseModel):
    id : int
    name : str
    picture : str
    artists: List[ArtistBase_Name]=[]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class SongBaseForGetTop12RecentSongs(BaseModel):
    id : int
    name : str
    picture : str
    album : AlbumBase_release_date
    artists: List[ArtistBase_Name]=[]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class SongBaseForSearch(BaseModel):
    id : int
    name : str
    picture : str
    artists: List[ArtistBase_Name]=[]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class SongBaseForGetAllSongsByArtistId(BaseModel):
    id : int
    name : str
    picture : str
    artists: List[ArtistBase_Name]=[]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class SongBaseForGetAllSongsByPlaylistId(BaseModel):
    id : int
    name : str
    duration : time
    picture : str
    artists: List[ArtistBase_Name]=[]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class SongBaseForGetTopSongsListenCountMaxByArtistId(BaseModel):
    id : int
    name : str
    picture : str
    artists: List[ArtistBase_Name]=[]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class SongBaseForGetTopSongsListenCountMaxByAlbumId(BaseModel):
    id : int
    name : str
    picture : str
    artists: List[ArtistBase_Name]=[]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class SongCreate(BaseModel):
    name: str
    duration: time
    picture: str
    lyric: Optional[str] = None
    album_id: int
    picture_base64: str
    lyric_base64: str
    mp3_base64: str
    genre_ids: List[int]
    topic_ids: List[int]
    artist_ids: List[int]

class SongUpdate(BaseModel):
    name: str
    duration: time
    picture: str
    lyric: Optional[str] = None
    album_id: int
    picture_base64: str
    lyric_base64: str
    mp3_base64: str
    genre_ids: List[int]
    topic_ids: List[int]
    artist_ids: List[int]

class SongBase_ArtistBase_Id_Name_Description_Picture(BaseModel):
    id : int
    name : str
    duration : time
    picture : str
    lyric: Optional[str] = Field(None, description="Text field for storing lyrics, can be None")  # Allow None
    listen_count: int = Field(..., description="BigInteger field for storing listen count")  # Use int with description for clarity
    album_id: int
    genres: List[GenreBaseNoSongs]=[]
    topics: List[TopicBaseNoSongs]=[]
    artists: List[ArtistBase_Id_Name_Description_Picture]=[]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True
