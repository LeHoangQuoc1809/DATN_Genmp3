from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from app.core.connectdb import Base

class Playlist_User(Base):
    __tablename__ = "playlist_user"
    id = Column(Integer, primary_key=True, nullable=False, autoincrement=True, index=True)
    user_email = Column(String(255), ForeignKey('user.email'), nullable=False)
    playlist_id = Column(Integer, ForeignKey('playlist.id'), nullable=False)

    # ------------------------------------ Relationship ------------------------------------

    # Relationship for user
    user = relationship("User", back_populates="playlist_users")

    # Relationship for playlist
    playlist = relationship("Playlist", back_populates="playlist_users")

    def __repr__(self):
        return f"<Playlist_User(id={self.id}, user_email={self.user_email}, playlist_id={self.playlist_id})>"
        # , user={self.user}, playlist={self.playlist}
    
# Import các model cần thiết để tránh vòng lặp import
from app.models.user import User
from app.models.playlist import Playlist

# Khai báo lại các quan hệ sau khi đã import đầy đủ các model liên quan
# Relationship for user
Playlist_User.user = relationship("User", back_populates="playlist_users")

# Relationship for playlist
Playlist_User.playlist = relationship("Playlist", back_populates="playlist_users")
