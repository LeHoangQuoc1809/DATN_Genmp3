from sqlalchemy import Column, Integer, TIMESTAMP, ForeignKey
from sqlalchemy.orm import relationship
from app.core.connectdb import Base


class Song_Topic(Base):
    __tablename__ = "song_topic"
    # ForeignKey
    song_id = Column(Integer, ForeignKey('song.id'), primary_key=True, nullable=False)
    topic_id = Column(Integer, ForeignKey('topic.id'), primary_key=True, nullable=False)

    # ------------------------------------ Relationship ------------------------------------

    # Relationship for song 
    song = relationship("Song", back_populates="song_topics")

    # Relationship for topic 
    topic = relationship("Topic", back_populates="song_topics")

    def __repr__(self):
        return f"<Song_Topic(song_id={self.song_id}, topic_id={self.topic_id})>"
        # , song={self.song}, topic={self.topic}
       

# Import các model cần thiết để tránh vòng lặp import
from app.models.song import Song
from app.models.topic import Topic

# Khai báo lại các quan hệ sau khi đã import đầy đủ các model liên quan
# Relationship for song 
Song_Topic.song = relationship("Song", back_populates="song_topics")

# Relationship for topic 
Song_Topic.topic = relationship("Topic", back_populates="song_topics")



