from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
from sqlalchemy.orm import Session
from typing import List
from app.schemas.search import SearchBase
from app.schemas.song import SongBaseForSearch
from app.schemas.album import AlbumBaseForSearch
from app.schemas.artist import ArtistBaseForSearch
from app.schemas.playlist import PlaylistBaseForSearch
from app.core.connectdb import get_db
from app.services import song_service, album_service, artist_service, playlist_service
from unidecode import unidecode

router = APIRouter()

@router.get("/search/{key_word}", response_model=SearchBase)
async def search(key_word: str, db: Session = Depends(get_db)):
    key_word = f"%{(key_word).lower()}%"
    
    # Search in songs
    songs = await song_service.get_top_5_songs_for_search(db, key_word)

    # Search in albums
    albums = await album_service.get_top_5_albums_for_search(db, key_word)

    # Search in artists
    artists = await artist_service.get_top_5_artists_for_search(db, key_word)

    # Search in playlists
    playlists = await playlist_service.get_top_5_playlists_for_search(db, key_word)

    return SearchBase(
        songs=[SongBaseForSearch.from_orm(song) for song in songs],
        albums=[AlbumBaseForSearch.from_orm(album) for album in albums],
        artists=[ArtistBaseForSearch.from_orm(artist) for artist in artists],
        playlists=[PlaylistBaseForSearch.from_orm(playlist) for playlist in playlists]
    )