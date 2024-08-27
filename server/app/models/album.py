from sqlalchemy import Column, Integer, String, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from ..core.connectdb import Base
import datetime
# from app.models.song import Song  

class Album(Base):
    __tablename__ = "album"
    id = Column(Integer, primary_key=True, nullable=False, autoincrement=True, index=True)
    name = Column(String(255), nullable=False, index=True)
    release_date = Column(DateTime, nullable=False, default=datetime.datetime(2000, 1, 1))  # Default value
    picture = Column(String(255), nullable=False)
    description = Column(String(255))

    # Foreign keys
    artist_id = Column(Integer, ForeignKey('artist.id'), nullable=False)

    # ------------------------------------ Relationship ------------------------------------

    # Relationship for artist 
    artist = relationship("Artist", back_populates="albums")

    # Relationship for song 
    songs = relationship("Song", back_populates="album")

    def __repr__(self):
        return f"<Album(id={self.id}, name={self.name}, release_date={self.release_date}, picture={self.picture}, description={self.description}, artist_id={self.artist_id})>"
        # , artist={self.artist}, songs={self.songs}

# Import các model cần thiết để tránh vòng lặp import
from app.models.artist import Artist
from app.models.song import Song

# Khai báo lại các quan hệ sau khi đã import đầy đủ các model liên quan
# Relationship for artist 
Album.artist = relationship("Artist", back_populates="albums")

# Relationship for song 
Album.songs = relationship("Song", back_populates="album")
    
    
