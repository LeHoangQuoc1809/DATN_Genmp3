from sqlalchemy.orm import Session
from fastapi import HTTPException
from app.models.song_topic import Song_Topic
from app.schemas.song_topic import SongTopicCreate, SongTopicUpdate
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import func 

# get data -----------------------------------------------------------------------------------------------------------
async def get_all_song_topics(db: Session) -> list:
    return db.query(Song_Topic).all()

async def get_song_topics_by_song_id(db: Session, song_id: int) -> list:
    return db.query(Song_Topic).filter(Song_Topic.song_id == song_id).all()

async def get_song_topics_by_topic_id(db: Session, topic_id: int) -> list:
    return db.query(Song_Topic).filter(Song_Topic.topic_id == topic_id).all()

async def get_song_topic_by_song_id_topic_id(db: Session, song_id: int, topic_id: int):
    return db.query(Song_Topic).filter(Song_Topic.song_id == song_id, Song_Topic.topic_id == topic_id).first()

# create data -----------------------------------------------------------------------------------------------------------
async def create_song_topic(db: Session, new_song_topic: SongTopicCreate) -> Song_Topic:
    # Kiểm tra nếu new_song_topic là None
    if not new_song_topic:
        raise HTTPException(status_code=400, detail="Invalid new_song_topic data")
    
    # Kiểm tra nếu new_song_topic.song_id là None
    if not new_song_topic.song_id:
        raise HTTPException(status_code=400, detail="Invalid new_song_topic.song_id data")
    
    # Kiểm tra nếu new_song_topic.topic_id là None
    if not new_song_topic.topic_id:
        raise HTTPException(status_code=400, detail="Invalid new_song_topic.topic_id data")

    # Tạo Song_Topic mới và thêm vào cơ sở dữ liệu
    try:
        create_song_topic = Song_Topic(
        song_id=new_song_topic.song_id,
        topic_id=new_song_topic.topic_id,
        )
        db.add(create_song_topic)
        db.commit()
        db.refresh(create_song_topic)
        return create_song_topic
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to create the song_topic")
    
# update data -----------------------------------------------------------------------------------------------------------
async def update_song_topic_by_song_id_topic_id(db: Session, song_id: int, topic_id: int, new_song_topic: SongTopicUpdate) -> Song_Topic:
    # Lấy dữ liệu old_song_topic từ cơ sở dữ liệu
    old_song_topic = db.query(Song_Topic).filter(Song_Topic.song_id == song_id, Song_Topic.topic_id == topic_id).first()
    if not old_song_topic:
        raise HTTPException(status_code=404, detail="Song_Topic not found")

    # Kiểm tra nếu new_song_topic là None
    if not new_song_topic:
        raise HTTPException(status_code=400, detail="Invalid song_topic update data")
    
    # Kiểm tra nếu new_song_topic.song_id là None
    if not new_song_topic.song_id:
        raise HTTPException(status_code=400, detail="Invalid song_topic.song_id update data")
    
    # Kiểm tra nếu new_song_topic.topic_id là None
    if not new_song_topic.topic_id:
        raise HTTPException(status_code=400, detail="Invalid song_topic.topic_id update data")
    
    # Cập nhật các trường được chỉ định trong new_song_topic
    for var, value in vars(new_song_topic).items():
        if value is not None:
            setattr(old_song_topic, var, value)

    # Lưu thay đổi vào cơ sở dữ liệu
    try:
        db.commit()
        db.refresh(old_song_topic)
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to update the song_topic")
    
    return old_song_topic

# delete data -----------------------------------------------------------------------------------------------------------
async def delete_song_topic_by_song_id_topic_id(db: Session, song_id: int, topic_id: int):
    try:
        delete_song_topic = db.query(Song_Topic).filter(Song_Topic.song_id == song_id, Song_Topic.topic_id == topic_id).first()
        if delete_song_topic is None:
            raise HTTPException(status_code=404, detail="Song_Topic not found")
        else:
            db.delete(delete_song_topic)
            db.commit()
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to delete the song_topic")
    
async def delete_song_topic_by_song_id(db: Session, song_id: int):
    try:
        delete_song_topics = db.query(Song_Topic).filter(Song_Topic.song_id == song_id).all()
        if not delete_song_topics:
            raise HTTPException(status_code=404, detail="Song_Topic not found")
        else:
            print(f"Deleting Song_Topic records with song_id: {song_id}")
            for record in delete_song_topics:
                print(f"Deleting record: {record}")
            db.query(Song_Topic).filter(Song_Topic.song_id == song_id).delete()
            db.commit()
            print("Delete successful")
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        print(f"SQLAlchemyError: {e}")  # Print lỗi SQLAlchemyError
        raise HTTPException(status_code=500, detail="An error occurred while trying to delete the song_topic")
    