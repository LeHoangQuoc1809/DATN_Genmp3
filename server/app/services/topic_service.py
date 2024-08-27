from sqlalchemy.orm import Session
from fastapi import HTTPException
from app.models.topic import Topic
from app.schemas.topic import TopicCreate,TopicUpdate
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import func

# get data -----------------------------------------------------------------------------------------------------------
async def get_all_topics(db: Session) -> list:
    return db.query(Topic).all()

async def get_topic_by_id(db: Session, id: int):
    return db.query(Topic).filter(Topic.id == id).first()

async def get_topics_by_name(db: Session, name: str) -> list:
    return db.query(Topic).filter(func.lower(Topic.name).ilike(f"%{name.lower()}%")).all()

async def get_top_3_topics(db: Session) -> list:
    return db.query(Topic).limit(3).all()

# create data -----------------------------------------------------------------------------------------------------------
async def create_topic(db: Session, new_topic: TopicCreate) -> Topic:
    # Kiểm tra nếu new_topic là None
    if not new_topic:
        raise HTTPException(status_code=400, detail="Invalid new_topic data")
    
    # Kiểm tra nếu new_topic.name là None
    if not new_topic.name.strip():
        raise HTTPException(status_code=400, detail="Invalid new_topic.name data")
    
    # Kiểm tra xem new_topic.name có tồn tại trong cơ sở dữ liệu hay không
    existing_topic = db.query(Topic).filter(Topic.name == new_topic.name).first()
    if existing_topic:
        raise HTTPException(status_code=400, detail="Topic with this name already exists")

    # Tạo Topic mới và thêm vào cơ sở dữ liệu
    try:
        create_topic = Topic(
        name=new_topic.name,
        description=new_topic.description,
        )
        db.add(create_topic)
        db.commit()
        db.refresh(create_topic)
        return create_topic
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to create the topic")

# update data -----------------------------------------------------------------------------------------------------------
async def update_topic_by_id(db: Session, id: int, new_topic: TopicUpdate) -> Topic:
    # Lấy dữ liệu old_topic từ cơ sở dữ liệu
    old_topic = db.query(Topic).filter(Topic.id == id).first()
    if not old_topic:
        raise HTTPException(status_code=404, detail="Topic not found")

    # Kiểm tra nếu new_topic là None
    if not new_topic:
        raise HTTPException(status_code=400, detail="Invalid topic update data")
    
    # Kiểm tra nếu new_topic.name là None
    if not new_topic.name.strip():
        raise HTTPException(status_code=400, detail="Invalid topic.name update data")
    
    # Nếu như có update name
    if old_topic.name != new_topic.name:
        # Kiểm tra xem new_topic.name có tồn tại trong cơ sở dữ liệu hay không
        existing_topic = db.query(Topic).filter(Topic.name == new_topic.name).first()
        if existing_topic:
            raise HTTPException(status_code=400, detail="Topic with this name already exists")
   
    # Cập nhật các trường được chỉ định trong new_topic
    for var, value in vars(new_topic).items():
        if value is not None:
            setattr(old_topic, var, value)

    # Lưu thay đổi vào cơ sở dữ liệu
    try:
        db.commit()
        db.refresh(old_topic)
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to update the topic")
                            
    return old_topic

# delete data -----------------------------------------------------------------------------------------------------------
async def delete_topic_by_id(db: Session, id: int):
    try:
        delete_topic = db.query(Topic).filter(Topic.id == id).first()
        if delete_topic is None:
            raise HTTPException(status_code=404, detail="Topic not found")
        else:
            db.delete(delete_topic)
            db.commit()
    except SQLAlchemyError as e:
        db.rollback()  # Rollback the transaction in case of error
        raise HTTPException(status_code=500, detail="An error occurred while trying to delete the topic")

