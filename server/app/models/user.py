from sqlalchemy import Column, Integer, String, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from app.core.connectdb import Base
import datetime

class User(Base):
    __tablename__ = "user"
    email = Column(String(255), primary_key=True, nullable=False, index=True)
    name = Column(String(255), nullable=False, index=True)
    birthdate = Column(DateTime, nullable=False, default=datetime.datetime(2000, 1, 1))  # Default value
    phone = Column(String(10),nullable=True, unique=True, index=True)
    password = Column(String(255), nullable=False, index=True)
    picture = Column(String(255), nullable=False, index=True)

    # Foreign keys
    user_type_id = Column(Integer, ForeignKey('user_type.id'), nullable=False)
    

    # ------------------------------------ Relationship ------------------------------------

   # Relationship for user_type
    user_type = relationship("User_Type", back_populates="users")

    # Relationship for follower -> artists
    followers = relationship('Follower', back_populates='user')
    artists = relationship("Artist", secondary="follower", back_populates="users")

    # Relationship for user_upload_song
    uploaded_songs = relationship("User_Upload_Song", back_populates="user")

    # Relationship for user_session
    sessions = relationship("User_Session", back_populates="user")

    # Relationship for history -> songs
    historys = relationship('History', back_populates='user')
    songs = relationship('Song', secondary='history', back_populates='users')

    # Relationship for playlist_user -> playlists_of_playlist_user
    playlist_users = relationship('Playlist_User', back_populates='user')
    playlists_of_playlist_user = relationship('Playlist', secondary='playlist_user', back_populates='users_of_playlist_user')

    # Relationship for recommended_playlist -> playlists_of_recommended_playlist
    recommended_playlists = relationship('Recommended_Playlist', back_populates='user')
    playlists_of_recommended_playlist = relationship('Playlist', secondary='recommended_playlist', back_populates='users_of_recommended_playlist')

    def __repr__(self):
        return f"<User(email={self.email}, name={self.name}, birthdate={self.birthdate}, phone={self.phone}, password={self.password}, picture={self.picture}, user_type_id={self.user_type_id})>"
        # , user_type={self.user_type}, followers={self.followers}, artists={self.artists}, uploaded_songs={self.uploaded_songs}, historys={self.historys}, songs={self.songs}, playlist_users={self.playlist_users}, playlists_of_playlist_user={self.playlists_of_playlist_user}, recommended_playlists={self.recommended_playlists}, playlists_of_recommended_playlist={self.playlists_of_recommended_playlist}
        
# Import các model cần thiết để tránh vòng lặp import
from app.models.user_type import User_Type
from app.models.follower import Follower
from app.models.artist import Artist
from app.models.user_upload_song import User_Upload_Song
from app.models.user_session import User_Session
from app.models.history import History
from app.models.song import Song
from app.models.playlist_user import Playlist_User
from app.models.playlist import Playlist
from app.models.recommended_playlist import Recommended_Playlist
from app.models.playlist import Playlist

# Khai báo lại các quan hệ sau khi đã import đầy đủ các model liên quan
# Relationship for user_type
User.user_type = relationship("User_Type", back_populates="users")

# Relationship for follower -> artists
User.followers = relationship('Follower', back_populates='user')
User.artists = relationship("Artist", secondary="follower", back_populates="users")

# Relationship for user_upload_song
User.uploaded_songs = relationship("User_Upload_Song", back_populates="user")

# Relationship for user_session
User.sessions = relationship("User_Session", back_populates="user")

# Relationship for history -> songs
User.historys = relationship('History', back_populates='user')
User.songs = relationship('Song', secondary='history', back_populates='users')

# Relationship for playlist_user -> playlists_of_playlist_user
User.playlist_users = relationship('Playlist_User', back_populates='user')
User.playlists_of_playlist_user = relationship('Playlist', secondary='playlist_user', back_populates='users_of_playlist_user')

# Relationship for recommended_playlist -> playlists_of_recommended_playlist
User.recommended_playlists = relationship('Recommended_Playlist', back_populates='user')
User.playlists_of_recommended_playlist = relationship('Playlist', secondary='recommended_playlist', back_populates='users_of_recommended_playlist')
