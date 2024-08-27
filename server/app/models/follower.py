from sqlalchemy import Column, Integer, ForeignKey, String
from sqlalchemy.orm import relationship
from app.core.connectdb import Base

class Follower(Base):
    __tablename__ = "follower"
    user_email = Column(String(255), ForeignKey('user.email'), primary_key=True, nullable=False)
    artist_id = Column(Integer, ForeignKey('artist.id'), primary_key=True, nullable=False)

    # ------------------------------------ Relationship ------------------------------------

    # Relationship for artist 
    artist = relationship("Artist", back_populates="followers")

    # Relationship for user 
    user = relationship("User", back_populates="followers")

    def __repr__(self):
        return f"<Follower(user_email={self.user_email}, artist_id={self.artist_id})>"
        # , artist={self.artist}, user={self.user}

# Import các model cần thiết để tránh vòng lặp import
from app.models.user import User
from app.models.artist import Artist

# Khai báo lại các quan hệ sau khi đã import đầy đủ các model liên quan
# Relationship for artist 
Follower.artist = relationship("Artist", back_populates="followers")

# Relationship for user 
Follower.user = relationship("User", back_populates="followers")
