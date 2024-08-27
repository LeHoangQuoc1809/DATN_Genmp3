from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.schemas import song_topic
from app.core.connectdb import get_db
from app.services import song_topic_service

router = APIRouter()

# get data -----------------------------------------------------------------------------------------------------------
@router.get("/", response_model=list[song_topic.SongTopicBase])
async def get_all_song_topics(db: Session = Depends(get_db)):
    song_topics = await song_topic_service.get_all_song_topics(db)
    return song_topics 
 
@router.get("/get-song-topics-by-song-id/{song_id}", response_model=list[song_topic.SongTopicBase])
async def get_song_topics_by_song_id(song_id: int, db: Session = Depends(get_db)):
    song_topics = await song_topic_service.get_song_topics_by_song_id(db, song_id)
    return song_topics
 
@router.get("/get-song-topics-by-topic-id/{topic_id}", response_model=list[song_topic.SongTopicBase])
async def get_song_topics_by_topic_id(topic_id: int, db: Session = Depends(get_db)):
    song_topics = await song_topic_service.get_song_topics_by_topic_id(db, topic_id)
    return song_topics

@router.get("/get-song-topic-by-song-id-topic-id/{song_id}/{topic_id}", response_model=song_topic.SongTopicBase)
async def get_song_topic_by_song_id_topic_id(song_id: int, topic_id:int, db: Session = Depends(get_db)):
    song_topic = await song_topic_service.get_song_topic_by_song_id_topic_id(db, song_id, topic_id)
    if song_topic is None:
        raise HTTPException(status_code=404, detail="Song_Topic not found")
    return song_topic

# post data -----------------------------------------------------------------------------------------------------------
@router.post("/create-song-topic/", response_model=song_topic.SongTopicBase)
async def create_song_topic(new_song_topic: song_topic.SongTopicCreate, db: Session = Depends(get_db)):
    try:
        create_song_topic = await song_topic_service.create_song_topic(db, new_song_topic)
        if create_song_topic is None:
            raise HTTPException(status_code=500, detail="Failed to create song_topic")
        return create_song_topic
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# put data -----------------------------------------------------------------------------------------------------------
@router.put("/update-song-topic-by-song-id-topic-id/{song_id}/{topic_id}", response_model=song_topic.SongTopicBase)
async def update_song_topic_by_song_id_topic_id(song_id: int, topic_id: int, new_song_topic: song_topic.SongTopicUpdate, db: Session = Depends(get_db)):
    try:
        update_song_topic = await song_topic_service.update_song_topic_by_song_id_topic_id(db, song_id, topic_id, new_song_topic)
        if update_song_topic is None:
            raise HTTPException(status_code=404, detail="Song_Topic not found")
        return update_song_topic
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# delete data -----------------------------------------------------------------------------------------------------------
@router.delete("/delete-song-topic-by-song-id-topic-id/{song_id}/{topic_id}", status_code=200)
async def delete_song_topic_by_song_id_topic_id(song_id: int, topic_id: int, db: Session = Depends(get_db)):
    try:
        await song_topic_service.delete_song_topic_by_song_id_topic_id(db, song_id, topic_id)
        return {"detail": "Song_Topic deleted successfully"}
    except HTTPException as e:
        raise e 
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    