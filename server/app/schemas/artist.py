from pydantic import BaseModel
import datetime
from typing import List, Optional
from .album import AlbumBase
from .artist_song import ArtistSongBase
from .song import SongBase


class ArtistBase(BaseModel):
    id: int
    name: str
    description: Optional[str]
    picture: Optional[str]
    albums: List[AlbumBase] = []
    artist_songs: List[ArtistSongBase] = []
    songs: List[SongBase]=[]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True  

class ArtistBaseForGetTop5ArtistsSimilarById(BaseModel):
    id: int
    name: str
    description: Optional[str]
    picture: Optional[str]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True  

class ArtistBaseForSearch(BaseModel):
    id: int
    name: str
    picture: Optional[str]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True  

class ArtistCreate(BaseModel):
    name: str
    description: str
    picture: str
    picture_base64: str

class ArtistUpdate(BaseModel):
    name: str
    description: Optional[str] = None
    picture: Optional[str] = None
    picture_base64: str

class ArtistBaseId(BaseModel):
    id: str

class ArtistBaseName(BaseModel):
    name: str

class ArtistBaseDescription(BaseModel):
    description: str

class ArtistBasePicture(BaseModel):
    picture: str

class ArtistBaseAlbums(BaseModel):
    albums: List[AlbumBase] = []

class ArtistBaseArtistSongs(BaseModel):
    artist_songs: List[ArtistSongBase] = []

# class ArtistBasetSongs(BaseModel):
#     songs: List[SongBase]=[]

# class ArtistBase_Id_Name_Description_Picture(BaseModel):
#     id: int
#     name: str
#     description: Optional[str]
#     picture: Optional[str]

#     class Config:
#         from_attributes = True
#         arbitrary_types_allowed = True

