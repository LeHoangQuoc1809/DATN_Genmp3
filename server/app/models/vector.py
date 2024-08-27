from sqlalchemy import Column, Integer, String, JSON, ForeignKey
from sqlalchemy.orm import relationship
from app.core.connectdb import Base

class Vector(Base):
    __tablename__ = "vector"
    song_id = Column(Integer, ForeignKey('song.id'), primary_key=True, nullable=False, index=True)
    mfcc = Column(JSON, nullable=True)
    tf_idf = Column(JSON, nullable=True)

    # ------------------------------------ Relationship ------------------------------------

    # # Relationship for song 
    # song = relationship("Song", back_populates="vector")
    
    def __repr__(self):
        return f"<Vector(song_id={self.song_id}, mfcc={self.mfcc}, tf_idf={self.tf_idf})>"
        # , song={self.song}

# Import các model cần thiết để tránh vòng lặp import
from app.models.song import Song

# Khai báo lại các quan hệ sau khi đã import đầy đủ các model liên quan
# # Relationship for song 
# Vector.song = relationship("Song", back_populates="vector")