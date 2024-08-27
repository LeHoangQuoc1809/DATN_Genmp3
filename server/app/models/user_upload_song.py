from sqlalchemy import Column, Integer, String, Text, Time, TIMESTAMP, ForeignKey
from sqlalchemy.orm import relationship
from app.core.connectdb import Base

class User_Upload_Song(Base):
    __tablename__ = "user_upload_song"
    id = Column(Integer, primary_key=True, nullable=False, autoincrement=True, index=True)
    name = Column(String(255), nullable=False, index=True)
    upload_at = Column(TIMESTAMP, nullable=False)
    lyric = Column(Text)
    duration = Column(Time, nullable=False)
    user_email = Column(String(255), ForeignKey('user.email'), nullable=False)

    # ------------------------------------ Relationship ------------------------------------

    # Relationship for user 
    user = relationship("User", back_populates="uploaded_songs")
    
    def __repr__(self):
        return f"<User_Upload_Song(id={self.id}, name={self.name}, upload_at={self.upload_at}, lyric={self.lyric}, duration={self.duration}, user_email={self.user_email})>"
        # , user={self.user}
        
# Import các model cần thiết để tránh vòng lặp import
from app.models.user import User

# Khai báo lại các quan hệ sau khi đã import đầy đủ các model liên quan
# Relationship for user 
User_Upload_Song.user = relationship("User", back_populates="uploaded_songs")

