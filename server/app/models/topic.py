from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from app.core.connectdb import Base

class Topic(Base):
    __tablename__ = "topic"
    id = Column(Integer, primary_key=True, nullable=False, autoincrement=True, index=True)
    name = Column(String(45), nullable=False, unique=True, index=True)
    description = Column(String(255))

    # ------------------------------------ Relationship ------------------------------------

    # Relationship for song_topic -> songs
    song_topics = relationship('Song_Topic', back_populates='topic')
    songs = relationship('Song', secondary='song_topic', back_populates='topics')
    
    def __repr__(self):
        return f"<Topic(id={self.id}, name={self.name}, description={self.description})>"
        # , songs={self.songs}
    
# Import các model cần thiết để tránh vòng lặp import
from app.models.song_topic import Song_Topic
from app.models.song import Song

# Khai báo lại các quan hệ sau khi đã import đầy đủ các model liên quan
# Relationship for song_topic -> songs
Topic.song_topics = relationship('Song_Topic', back_populates='topic')
Topic.songs = relationship('Song', secondary='song_topic', back_populates='topics')