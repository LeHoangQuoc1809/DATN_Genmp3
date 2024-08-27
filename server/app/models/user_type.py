from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from app.core.connectdb import Base

class User_Type(Base):
    __tablename__ = "user_type"
    id = Column(Integer, primary_key=True, nullable=False, autoincrement=True, index=True)
    name = Column(String(45), nullable=False, unique=True, index=True)
    description = Column(String(255))

    # ------------------------------------ Relationship ------------------------------------

    # Relationship for user 
    users = relationship("User", back_populates="user_type")
    
    def __repr__(self):
        return f"<User_Type(id={self.id}, name={self.name}, description={self.description})>"
        # , users={self.users}
    
# Import các model cần thiết để tránh vòng lặp import
from app.models.user import User

# Khai báo lại các quan hệ sau khi đã import đầy đủ các model liên quan
# Relationship for user 
User_Type.users = relationship("User", back_populates="user_type")