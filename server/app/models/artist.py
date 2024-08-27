from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from app.core.connectdb import Base
# from app.models import Album, Artist_Song, Song  # Import from __init__.py

class Artist(Base):
    __tablename__ = "artist"
    id = Column(Integer, primary_key=True, nullable=False, autoincrement=True, index=True)
    name = Column(String(45), nullable=False, index=True)
    description = Column(String(255))
    picture = Column(String(255))

    # ------------------------------------ Relationship ------------------------------------

    # Relationship for album 
    albums = relationship("Album", back_populates="artist")

    # Relationship for artist_song -> songs
    artist_songs = relationship('Artist_Song', back_populates='artist')
    songs = relationship('Song', secondary='artist_song', back_populates='artists')

    # Relationship for follower -> users
    followers = relationship('Follower', back_populates='artist')
    users = relationship('User', secondary='follower', back_populates='artists')

    def __repr__(self):
        return f"<Artist(id={self.id}, name={self.name}, description={self.description}, picture={self.picture})>"
        # , albums={self.albums}, artist_songs={self.artist_songs}, songs={self.songs}, followers={self.followers}, users={self.users}

# Import các model cần thiết để tránh vòng lặp import
from app.models.album import Album
from app.models.artist_song import Artist_Song
from app.models.song import Song
from app.models.follower import Follower
from app.models.user import User

# Khai báo lại các quan hệ sau khi đã import đầy đủ các model liên quan
# Relationship for album 
Artist.albums = relationship("Album", back_populates="artist")

# Relationship for artist_song -> songs
Artist.artist_songs = relationship('Artist_Song', back_populates='artist')
Artist.songs = relationship('Song', secondary='artist_song', back_populates='artists')

# Relationship for follower -> users
Artist.followers = relationship('Follower', back_populates='artist')
Artist.users = relationship('User', secondary='follower', back_populates='artists')
