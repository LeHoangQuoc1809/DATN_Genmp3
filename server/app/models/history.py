from sqlalchemy import Column, Integer, TIMESTAMP, String, ForeignKey
from sqlalchemy.orm import relationship
from app.core.connectdb import Base


class History(Base):
    __tablename__ = "history"
    id = Column(Integer, primary_key=True, nullable=False, autoincrement=True, index=True)
    time = Column(TIMESTAMP, nullable=False, unique=True, index=True)

    # ForeignKey
    user_email = Column(String(255), ForeignKey('user.email'), nullable=False)
    song_id = Column(Integer, ForeignKey('song.id'), nullable=False)

    # ------------------------------------ Relationship ------------------------------------

    # Relationship for user 
    user = relationship("User", back_populates="historys")

    # Relationship for song 
    song = relationship("Song", back_populates="historys")
    
    def __repr__(self):
        return f"<History(id={self.id}, time={self.time}, user_email={self.user_email}, song_id={self.song_id})>"
        # , user={self.user}, song={self.song}
    
# Import các model cần thiết để tránh vòng lặp import
from app.models.user import User
from app.models.song import Song

# Khai báo lại các quan hệ sau khi đã import đầy đủ các model liên quan
# Relationship for user 
History.user = relationship("User", back_populates="historys")

# Relationship for song 
History.song = relationship("Song", back_populates="historys")



