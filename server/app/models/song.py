from sqlalchemy import Column, Integer, String, Time, Text, BigInteger, ForeignKey
from sqlalchemy.orm import relationship
from app.core.connectdb import Base
# from app.models import Genre, Topic, Artist_Song, Artist, Album  # Import from __init__.py

class Song(Base):
    __tablename__ = "song"
    id = Column(Integer, primary_key=True, nullable=False, autoincrement=True, index=True)
    name = Column(String(45), nullable=False, index=True)
    duration = Column(Time, nullable=False, index=True)
    picture = Column(String(255), nullable=False, index=True)
    lyric = Column(Text)
    listen_count = Column(BigInteger, nullable=False, index=True, default=0)

    # Foreign keys
    album_id = Column(Integer, ForeignKey('album.id'), nullable=False)

    # ------------------------------------ Relationship ------------------------------------

    # Relationship for song_genre -> genres
    song_genres = relationship('Song_Genre', back_populates='song')
    genres = relationship('Genre', secondary='song_genre', back_populates='songs')

    # Relationship for song_genre -> topics
    song_topics = relationship('Song_Topic', back_populates='song')
    topics = relationship('Topic', secondary='song_topic', back_populates='songs')

    # Relationship for album 
    album = relationship("Album", back_populates="songs")
    
    # Relationship for artist_song -> artists
    artist_songs = relationship('Artist_Song', back_populates='song')
    artists = relationship('Artist', secondary='artist_song', back_populates='songs')

    # # Relationship for vector
    # vector = relationship('Vector', uselist=False, back_populates='song')   

    # Relationship for history -> user
    historys = relationship("History", back_populates="song")
    users = relationship('User', secondary='history', back_populates='songs')

    # Relationship for playlist_song -> playlists
    playlist_songs = relationship('Playlist_Song', back_populates='song')
    playlists = relationship('Playlist', secondary='playlist_song', back_populates='songs')

    def __repr__(self):
        return f"<Song(id={self.id}, name={self.name}, duration={self.duration}, picture={self.picture}, lyric={self.lyric}, listen_count={self.listen_count}, album_id={self.album_id})>"
        # , genres={self.genres}, topics={self.topics}, album={self.album}, artist_songs={self.artist_songs}, artists={self.artists}, vector={self.vector}, historys={self.historys}, users={self.users}, playlist_songs={self.playlist_songs}, playlists={self.playlists}

# Import các model cần thiết để tránh vòng lặp import
from app.models.song_genre import Song_Genre
from app.models.genre import Genre
from app.models.song_topic import Song_Topic
from app.models.topic import Topic
from app.models.album import Album
from app.models.artist import Artist
from app.models.artist_song import Artist_Song
from app.models.vector import Vector
from app.models.history import History
from app.models.user import User
from app.models.playlist_song import Playlist_Song
from app.models.playlist import Playlist

# Khai báo lại các quan hệ sau khi đã import đầy đủ các model liên quan
# Relationship for song_genre -> genres
Song.song_genres = relationship('Song_Genre', back_populates='song')
Song.genres = relationship('Genre', secondary='song_genre', back_populates='songs')

# Relationship for song_genre -> topics
Song.song_topics = relationship('Song_Topic', back_populates='song')
Song.topics = relationship('Topic', secondary='song_topic', back_populates='songs')

# Relationship for album 
Song.album = relationship("Album", back_populates="songs")

# Relationship for artist_song -> artists
Song.artist_songs = relationship('Artist_Song', back_populates='song')
Song.artists = relationship('Artist', secondary='artist_song', back_populates='songs')

# # Relationship for vector
# Song.vector = relationship('Vector', uselist=False, back_populates='song')  

# Relationship for history -> user
Song.historys = relationship("History", back_populates="song")
Song.users = relationship('User', secondary='history', back_populates='songs')

# Relationship for playlist_song -> playlists
Song.playlist_songs = relationship('Playlist_Song', back_populates='song')
Song.playlists = relationship('Playlist', secondary='playlist_song', back_populates='songs')