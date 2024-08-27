from pydantic import BaseModel, Field
from typing import List, Optional
from .song import SongBaseForSearch
from .album import AlbumBaseForSearch
from .artist import ArtistBaseForSearch
from .playlist import PlaylistBaseForSearch

class SearchBase(BaseModel):
    songs:  List[SongBaseForSearch]=[]
    albums:  List[AlbumBaseForSearch]=[]
    artists:  List[ArtistBaseForSearch]=[]
    playlists:  List[PlaylistBaseForSearch]=[]

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True


