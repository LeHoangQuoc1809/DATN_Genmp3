from sqlalchemy import Column, Integer, String, DateTime, Boolean
from sqlalchemy.orm import relationship
from app.core.connectdb import Base

class Playlist(Base):
    __tablename__ = "playlist"
    id = Column(Integer, primary_key=True, nullable=False, autoincrement=True, index=True)
    name = Column(String(45), nullable=False, index=True)
    description = Column(String(255))
    modify_date = Column(DateTime, nullable=False)
    picture = Column(String(255))
    is_admin = Column(Boolean, default=False)

    # ------------------------------------ Relationship ------------------------------------

    # Relationship for playlist_user -> users_of_playlist_user
    playlist_users = relationship('Playlist_User', back_populates='playlist')
    users_of_playlist_user = relationship('User', secondary='playlist_user', back_populates='playlists_of_playlist_user')

    # Relationship for recommended_playlist -> users_of_recommended_playlist
    recommended_playlists = relationship('Recommended_Playlist', back_populates='playlist')
    users_of_recommended_playlist = relationship('User', secondary='recommended_playlist', back_populates='playlists_of_recommended_playlist')

    # Relationship for playlist_song -> songs
    playlist_songs = relationship('Playlist_Song', back_populates='playlist')
    songs = relationship('Song', secondary='playlist_song', back_populates='playlists')

    def __repr__(self):
        return f"<Playlist(id={self.id}, name={self.name}, description={self.description}, modify_date={self.modify_date}, picture={self.picture})>"
        # , playlist_users={self.playlist_users}, users_of_playlist_user={self.users_of_playlist_user}, recommended_playlists={self.recommended_playlists}, users_of_recommended_playlist={self.users_of_recommended_playlist}, playlist_songs={self.playlist_songs}, songs={self.songs}
    
# Import các model cần thiết để tránh vòng lặp import
from app.models.playlist_user import Playlist_User
from app.models.user import User
from app.models.recommended_playlist import Recommended_Playlist
from app.models.user import User
from app.models.playlist_song import Playlist_Song
from app.models.song import Song

# Khai báo lại các quan hệ sau khi đã import đầy đủ các model liên quan
# Relationship for playlist_user -> users_of_playlist_user
Playlist.playlist_users = relationship('Playlist_User', back_populates='playlist')
Playlist.users_of_playlist_user = relationship('User', secondary='playlist_user', back_populates='playlists_of_playlist_user')

# Relationship for recommended_playlist -> users_of_recommended_playlist
Playlist.recommended_playlists = relationship('Recommended_Playlist', back_populates='playlist')
Playlist.users_of_recommended_playlist = relationship('User', secondary='recommended_playlist', back_populates='playlists_of_recommended_playlist')

# Relationship for playlist_song -> songs
Playlist.playlist_songs = relationship('Playlist_Song', back_populates='playlist')
Playlist.songs = relationship('Song', secondary='playlist_song', back_populates='playlists')
