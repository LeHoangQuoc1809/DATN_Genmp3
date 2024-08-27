from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from app.core.connectdb import Base

class Genre(Base):
    __tablename__ = "genre"
    id = Column(Integer, primary_key=True, nullable=False, autoincrement=True, index=True)
    name = Column(String(45), nullable=False, unique=True, index=True)
    description = Column(String(255))

    # ------------------------------------ Relationship ------------------------------------

    # Relationship for song_genre -> songs
    song_genres = relationship('Song_Genre', back_populates='genre')
    songs = relationship('Song', secondary='song_genre', back_populates='genres')
    
    def __repr__(self):
        return f"<Genre(id={self.id}, name={self.name}, description={self.description})>"
        # , songs={self.songs}
    
# Import các model cần thiết để tránh vòng lặp import
from app.models.song_genre import Song_Genre
from app.models.song import Song

# Khai báo lại các quan hệ sau khi đã import đầy đủ các model liên quan
# Relationship for song_genre -> songs
Genre.song_genres = relationship('Song_Genre', back_populates='genre')
Genre.songs = relationship('Song', secondary='song_genre', back_populates='genres')