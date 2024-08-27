from sqlalchemy import Column, Integer, TIMESTAMP, ForeignKey
from sqlalchemy.orm import relationship
from app.core.connectdb import Base


class Song_Genre(Base):
    __tablename__ = "song_genre"
    # ForeignKey
    song_id = Column(Integer, ForeignKey('song.id'), primary_key=True, nullable=False)
    genre_id = Column(Integer, ForeignKey('genre.id'), primary_key=True, nullable=False)

    # ------------------------------------ Relationship ------------------------------------

    # Relationship for song 
    song = relationship("Song", back_populates="song_genres")

    # Relationship for genre 
    genre = relationship("Genre", back_populates="song_genres")

    def __repr__(self):
        return f"<Song_Genre(song_id={self.song_id}, genre_id={self.genre_id})>"
        # , song={self.song}, genre={self.genre}
       

# Import các model cần thiết để tránh vòng lặp import
from app.models.song import Song
from app.models.genre import Genre

# Khai báo lại các quan hệ sau khi đã import đầy đủ các model liên quan
# Relationship for song 
Song_Genre.song = relationship("Song", back_populates="song_genres")

# Relationship for genre 
Song_Genre.genre = relationship("Genre", back_populates="song_genres")



