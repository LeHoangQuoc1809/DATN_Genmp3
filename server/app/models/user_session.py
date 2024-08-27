from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, Boolean
from sqlalchemy.orm import relationship
from app.core.connectdb import Base
from sqlalchemy.sql import func
import datetime

class User_Session(Base):
    __tablename__ = "user_session"
    id = Column(Integer, primary_key=True, nullable=False, autoincrement=True, index=True)
    session_id = Column(String, unique=True, index=True, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    last_active_at = Column(DateTime(timezone=True), onupdate=func.now())
    user_email = Column(String(255), ForeignKey('user.email'), index=True, nullable=False)
    active = Column(Boolean, default=True)  # Thêm cột active để quản lý trạng thái của phiên đăng nhập

    # Relationship for user 
    user = relationship("User", back_populates="sessions")
    
    def __repr__(self):
        return f"<User_Session(user_email={self.user_email}, session_id={self.session_id}), created_at={self.created_at}), last_active_at={self.last_active_at}), active={self.active})>"
    
# Import các model cần thiết để tránh vòng lặp import
from app.models.user import User

# Khai báo lại các quan hệ sau khi đã import đầy đủ các model liên quan
# Relationship for user 
User_Session.user = relationship("User", back_populates="sessions")
