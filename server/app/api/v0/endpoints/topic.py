from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.schemas import topic
from app.core.connectdb import get_db
from app.services import topic_service

router = APIRouter()

# get data -----------------------------------------------------------------------------------------------------------
@router.get("/get-all-topics-for-admin-dashboard", response_model=list[topic.TopicBase])
async def get_all_topics(db: Session = Depends(get_db)):
    topics = await topic_service.get_all_topics(db)
    return topics  

@router.get("/get-topic-by-id/{id}", response_model=topic.TopicBase)
async def get_topic_by_id(id: int, db: Session = Depends(get_db)):
    topic = await topic_service.get_topic_by_id(db, id)
    if topic is None:
        raise HTTPException(status_code=404, detail="Topic not found")
    return topic

@router.get("/get-topics-by-name/{name}", response_model=list[topic.TopicBase])
async def get_topics_by_name(name: str, db: Session = Depends(get_db)):
    name = name.strip()  # Loại bỏ khoảng trắng đầu cuối
    if not name:
        raise HTTPException(status_code=400, detail="Name cannot be empty or whitespace only")
    else:
        topics = await topic_service.get_topics_by_name(db, name)
    return topics

@router.get("/get-top-3-topics", response_model=list[topic.TopicBaseForGetTop3Topics])
async def get_top_3_topics(db: Session = Depends(get_db)):
    topics = await topic_service.get_top_3_topics(db)
    return topics 

@router.get("/get-all-topics-for-client", response_model=list[topic.TopicBaseForGetAllTopicsForClient])
async def get_all_topics(db: Session = Depends(get_db)):
    topics = await topic_service.get_all_topics(db)
    return topics  

# post data -----------------------------------------------------------------------------------------------------------
@router.post("/create-topic/", response_model=topic.TopicBase)
async def create_topic(new_topic: topic.TopicCreate, db: Session = Depends(get_db)):
    try:
        create_topic = await topic_service.create_topic(db, new_topic)
        if create_topic is None:
            raise HTTPException(status_code=500, detail="Failed to create topic")
        return create_topic
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# put data -----------------------------------------------------------------------------------------------------------
@router.put("/update-topic-by-id/{id}", response_model=topic.TopicBase)
async def update_topic_by_id(id: int, new_topic: topic.TopicUpdate, db: Session = Depends(get_db)):
    try:
        update_topic = await topic_service.update_topic_by_id(db, id, new_topic)
        if update_topic is None:
            raise HTTPException(status_code=404, detail="Topic not found")
        return update_topic
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")

# delete data -----------------------------------------------------------------------------------------------------------
@router.delete("/delete-topic-by-id/{id}", status_code=200)
async def delete_topic_by_id(id: int, db: Session = Depends(get_db)):
    try:
        await topic_service.delete_topic_by_id(db, id)
        return {"detail": "Topic deleted successfully"}
    except HTTPException as e:
        raise e 
    except Exception as e:
        raise HTTPException(status_code=500, detail="An unexpected error occurred")
    
    
    