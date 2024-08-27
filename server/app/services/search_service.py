from sqlalchemy.orm import Session
from fastapi import HTTPException
from app.models.song import Song
from app.models.album import Album
from app.models.song_genre import Song_Genre
from app.models.song_topic import Song_Topic
from app.schemas.song import SongCreate, SongUpdate
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import func
import os
import base64
import shutil
import logging
from app.services import song_genre_service, song_topic_service, artist_song_service
from app.schemas.song_genre import SongGenreCreate
from app.schemas.song_topic import SongTopicCreate
from app.schemas.artist_song import ArtistSongCreate
from datetime import datetime

# get data -----------------------------------------------------------------------------------------------------------
async def get_for_search(db: Session, search: str) -> list:
    return ()



