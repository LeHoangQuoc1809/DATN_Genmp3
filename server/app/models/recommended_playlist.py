from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from app.core.connectdb import Base

class Recommended_Playlist(Base):
    __tablename__ = "recommended_playlist"
    id = Column(Integer, primary_key=True, nullable=False, autoincrement=True, index=True)
    user_email = Column(String(255), ForeignKey('user.email'), nullable=False)
    playlist_id = Column(Integer, ForeignKey('playlist.id'), nullable=False)

    # ------------------------------------ Relationship ------------------------------------

    # Relationship for user
    user = relationship("User", back_populates="recommended_playlists")

    # Relationship for playlist
    playlist = relationship("Playlist", back_populates="recommended_playlists")

    def __repr__(self):
        return f"<Recommended_Playlist(id={self.id}, user_email={self.user_email}, playlist_id={self.playlist_id})>"
        # , user={self.user}, playlist={self.playlist}
    
# Import các model cần thiết để tránh vòng lặp import
from app.models.user import User
from app.models.playlist import Playlist

# Khai báo lại các quan hệ sau khi đã import đầy đủ các model liên quan
# Relationship for user
Recommended_Playlist.user = relationship("User", back_populates="recommended_playlists")

# Relationship for playlist
Recommended_Playlist.playlist = relationship("Playlist", back_populates="recommended_playlists")
