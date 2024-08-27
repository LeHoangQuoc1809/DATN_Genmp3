from fastapi import APIRouter

from app.api.v0.endpoints import ai
from app.api.v0.endpoints import album
from app.api.v0.endpoints import artist_song
from app.api.v0.endpoints import artist
# from app.api.v0.endpoints import comment
from app.api.v0.endpoints import follower
from app.api.v0.endpoints import genre
from app.api.v0.endpoints import history
from app.api.v0.endpoints import verify
# from app.api.v0.endpoints import like_comment
# from app.api.v0.endpoints import like_reply
from app.api.v0.endpoints import playlist_song
from app.api.v0.endpoints import playlist_user
from app.api.v0.endpoints import playlist
from app.api.v0.endpoints import recommended_playlist
from app.api.v0.endpoints import search
from app.api.v0.endpoints import song_genre
from app.api.v0.endpoints import song_topic
# from app.api.v0.endpoints import reply
from app.api.v0.endpoints import song
from app.api.v0.endpoints import topic
from app.api.v0.endpoints import user_type
from app.api.v0.endpoints import user_upload_song
from app.api.v0.endpoints import user
from app.api.v0.endpoints import vector
from app.api.v0.endpoints import websocket

api_router = APIRouter()
api_router.include_router(ai.router, prefix="/ais", tags=["ais"])
api_router.include_router(album.router, prefix="/albums", tags=["albums"])
api_router.include_router(artist_song.router, prefix="/artist_songs", tags=["artist_songs"])
api_router.include_router(artist.router, prefix="/artists", tags=["artists"])
# api_router.include_router(comment.router, prefix="/comments", tags=["comments"])
api_router.include_router(follower.router, prefix="/followers", tags=["followers"])
api_router.include_router(genre.router, prefix="/genres", tags=["genres"])
api_router.include_router(history.router, prefix="/historys", tags=["historys"])
api_router.include_router(verify.router, prefix="/verifys", tags=["verifys"])
# api_router.include_router(like_comment.router, prefix="/like_comments", tags=["like_comments"])
# api_router.include_router(like_reply.router, prefix="/like_replys", tags=["like_replys"])
api_router.include_router(playlist_song.router, prefix="/playlist_songs", tags=["playlist_songs"])
api_router.include_router(playlist_user.router, prefix="/playlist_users", tags=["playlist_users"])
api_router.include_router(playlist.router, prefix="/playlists", tags=["playlists"])
api_router.include_router(recommended_playlist.router, prefix="/recommended_playlists", tags=["recommended_playlists"])
api_router.include_router(search.router, prefix="/searchs", tags=["searchs"])
api_router.include_router(song_genre.router, prefix="/song_genres", tags=["song_genres"])
api_router.include_router(song_topic.router, prefix="/song_topics", tags=["song_topics"])
# api_router.include_router(reply.router, prefix="/replys", tags=["replys"])
api_router.include_router(song.router, prefix="/songs", tags=["songs"])
api_router.include_router(topic.router, prefix="/topics", tags=["topics"])
api_router.include_router(user_type.router, prefix="/user_types", tags=["user_types"])
api_router.include_router(user_upload_song.router, prefix="/user_upload_songs", tags=["user_upload_songs"])
api_router.include_router(user.router, prefix="/users", tags=["users"])
api_router.include_router(vector.router, prefix="/vectors", tags=["vectors"])
api_router.include_router(websocket.router, prefix="/websockets", tags=["websockets"])
