from sqlalchemy import Column, Integer, TIMESTAMP, ForeignKey
from sqlalchemy.orm import relationship
from app.core.connectdb import Base


class Artist_Song(Base):
    __tablename__ = "artist_song"
    create_at = Column(TIMESTAMP, nullable=False, index=True)

    # ForeignKey
    artist_id = Column(Integer, ForeignKey('artist.id'), primary_key=True, nullable=False)
    song_id = Column(Integer, ForeignKey('song.id'), primary_key=True, nullable=False)

    # ------------------------------------ Relationship ------------------------------------

    # Relationship for artist 
    artist = relationship("Artist", back_populates="artist_songs")

    # Relationship for song 
    song = relationship("Song", back_populates="artist_songs")

    def __repr__(self):
        return f"<Artist_Song(artist_id={self.artist_id}, song_id={self.song_id}, create_at={self.create_at})>"
        # , artist={self.artist}, song={self.song}

# Import các model cần thiết để tránh vòng lặp import
from app.models.song import Song
from app.models.artist import Artist

# Khai báo lại các quan hệ sau khi đã import đầy đủ các model liên quan
# Relationship for artist 
Artist_Song.artist = relationship("Artist", back_populates="artist_songs")

# Relationship for artist 
Artist_Song.song = relationship("Song", back_populates="artist_songs")



