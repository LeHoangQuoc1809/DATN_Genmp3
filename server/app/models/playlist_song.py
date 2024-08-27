from sqlalchemy import Column, Integer, ForeignKey
from sqlalchemy.orm import relationship
from app.core.connectdb import Base

class Playlist_Song(Base):
    __tablename__ = "playlist_song"
    id = Column(Integer, primary_key=True, nullable=False, autoincrement=True, index=True)
    playlist_id = Column(Integer, ForeignKey('playlist.id'), nullable=False)
    song_id = Column(Integer, ForeignKey('song.id'), nullable=False)

    # ------------------------------------ Relationship ------------------------------------

    # Relationship for song
    song = relationship("Song", back_populates="playlist_songs")

    # Relationship for playlist
    playlist = relationship("Playlist", back_populates="playlist_songs")

    def __repr__(self):
        return f"<Playlist_Song(id={self.id}, playlist_id={self.playlist_id}, song_id={self.song_id})>"
        # , song={self.song}, playlist={self.playlist}
    
# Import các model cần thiết để tránh vòng lặp import
from app.models.song import Song
from app.models.playlist import Playlist

# Khai báo lại các quan hệ sau khi đã import đầy đủ các model liên quan
# Relationship for song
Playlist_Song.song = relationship("Song", back_populates="playlist_songs")

# Relationship for playlist
Playlist_Song.playlist = relationship("Playlist", back_populates="playlist_songs")
