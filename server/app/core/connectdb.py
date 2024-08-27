from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from app.core.config import settings


SQLALCHEMY_DATABASE_URL = (

    # Chuỗi kết nối bao gồm mật khẩu
    # f"mysql+pymysql://{settings.DATABASE_USER}:{settings.DATABASE_PASSWORD}@{settings.DATABASE_HOST}:"
    # f"{settings.DATABASE_PORT}/{settings.DATABASE_NAME}"

    # Chuỗi kết nối không bao gồm mật khẩu
    f"mysql+pymysql://{settings.DATABASE_USER}:@{settings.DATABASE_HOST}:"
    f"{settings.DATABASE_PORT}/{settings.DATABASE_NAME}"
)
################################################################################################################
# Cấu hình của MySQL: MySQL có các cấu hình riêng về số lượng kết nối tối đa mà nó có thể chấp nhận đồng thời. #
# Tham số max_connections trong cấu hình MySQL quyết định điều này.                                            #
# Giá trị mặc định thường là 151, nhưng có thể thay đổi tùy thuộc vào cấu hình của bạn.                        #
################################################################################################################

# Tạo engine kết nối tới cơ sở dữ liệu với cấu hình pool_size và max_overflow tùy chỉnh
engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    pool_size=50,       # Số lượng kết nối duy trì trong pool
    max_overflow=20,    # Số lượng kết nối tạo thêm khi pool đầy
)

# Kiểm tra kết nối
try:
    with engine.connect() as connection:
        print("Kết nối tới cơ sở dữ liệu thành công!")
except Exception as e:
    print(f"Kết nối tới cơ sở dữ liệu thất bại: {e}")

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

# Dependency to get DB session
def  get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()