# Genmp3

## Giới thiệu

Genmp3 là một ứng dụng nghe nhạc trên Android, sử dụng trí tuệ nhân tạo (AI) để gợi ý các bài hát phù hợp với sở thích của bạn. Ứng dụng được phát triển với công nghệ Flutter cho cả phần giao diện di động và giao diện Admin-Dashboard trên web. 

Genmp3 sử dụng MySQL 8.3.11 làm hệ quản trị cơ sở dữ liệu để lưu trữ và quản lý dữ liệu người dùng, bài hát, và các thông tin khác. MySQL 8.3.11 cung cấp hiệu suất và tính ổn định cao cho ứng dụng của bạn.

Phần back-end của Genmp3 được xây dựng bằng FastAPI, giúp tạo ra một server API nhanh và hiệu quả. Đồng thời, chúng tôi sử dụng Python để huấn luyện mô hình AI và triển khai các thuật toán một cách dễ dàng và chính xác.

## Hướng dẫn cài đặt

### Bước 1: Cài đặt Flutter

1. Truy cập trang chủ Flutter: [flutter.dev](https://flutter.dev)
2. Làm theo hướng dẫn để tải và cài đặt Flutter SDK.
3. Thêm Flutter vào PATH của bạn.

### Bước 2: Cài đặt FastAPI

1. Mở terminal (hoặc command prompt) và tạo môi trường ảo:
    ```bash
    python -m venv venv
    source venv/bin/activate  # Trên Windows: venv\Scripts\activate
    ```
2. Lưu ý nên sử dụng Window thì hãy bật cho phép thực thi các script mà bạn đã tải xuống từ internet, miễn là chúng được ký số.
   
    
    

### Bước 3: Cài đặt Fastapi các phụ thuộc Python

1. Cài đặt các phụ thuộc cần thiết bằng cách sử dụng file `requirements.txt`:
    ```bash
    pip install -r requirements.txt
    ```
Bằng cách này tất cả thư viện sẽ tự động được cài đặt.

2. Đặt file model (svm_genre_model.joblib) vào trong thư mục ai (server\app\ai)

### Bước 4: Cài đặt MySQL

1. Tải và cài đặt MySQL 8.3.11 từ trang chính thức: [MySQL Downloads](https://dev.mysql.com/downloads/mysql/)
2. Trong quá trình cài đặt, hãy chọn các tùy chọn phù hợp với nhu cầu của bạn.
3. Sau khi cài đặt xong, khởi động MySQL và tạo một cơ sở dữ liệu mới cho ứng dụng của bạn.

### Bước 5: Cấu hình cơ sở dữ liệu

1. Cập nhật thông tin kết nối cơ sở dữ liệu trong file cấu hình của ứng dụng với thông tin của MySQL 8.3.11.
2. import file data.sql để creat Database cũng như các tables và records cần thiết cho việc chạy ứng dụng.
3. Có thể sử dụng terminal của mysql sau khi đã cài đặt:
    ```bash
    mysql -u yourusername -p yourdatabase < data.sql
    ```
   (Thay `yourusername`, `yourdatabase` bằng thông tin thực tế của bạn)

### Bước 6: Chạy ứng dụng

1. **Chạy back-end:**
    ```bash
    uvicorn app.main:app --reload --host `yourIP` --port `yourPort`
    ```
    #### Excample
   ```bash
    uvicorn app.main:app --reload --host 192.168.0.113 --port 6969
    ```
   (Điều chỉnh đường dẫn `app.main` nếu cần thiết để phù hợp với cấu trúc thư mục của bạn)

3. **Chạy ứng dụng Flutter Android:**
    ```bash
    flutter run
    ```
   (Đảm bảo thiết bị Android của bạn đã kết nối và được nhận diện bởi ADB)

4. **Chạy ứng dụng Flutter Web:**
    ```bash
    flutter build web
    flutter serve
    ```
   (Hoặc sử dụng `flutter run -d chrome` để chạy trực tiếp trên trình duyệt)

## Một số lưu ý quan trọng phải thực hiện

### Cấu hình môi trường

1. Mở file `.env` lên và thay thế các giá trị của từng biến tương ứng với cấu hình Database trong máy

### Cấu hình ở file connectdb.py (server\app\core\connectdb.py)
SQLALCHEMY_DATABASE_URL = (

    #Chuỗi kết nối bao gồm mật khẩu
    f"mysql+pymysql://{settings.DATABASE_USER}:{settings.DATABASE_PASSWORD}@{settings.DATABASE_HOST}:"
    f"{settings.DATABASE_PORT}/{settings.DATABASE_NAME}"

    # Chuỗi kết nối không bao gồm mật khẩu
    f"mysql+pymysql://{settings.DATABASE_USER}:@{settings.DATABASE_HOST}:"
    f"{settings.DATABASE_PORT}/{settings.DATABASE_NAME}"
)

thay đổi Chuỗi kết nối bao gồm mật khẩu hay Chuỗi kết nối không bao gồm mật khẩu tùy thuộc vào cấu hình trên DB của bạn.

### Thay đổi Ip cho Enpoint được gọi lại (endpoint\ai.py)
```bash
interaction_data_url = "http://192.168.0.106:8000/api/v0/ais/get-interaction-user-for-train-ai-model/"
song_data_url = "http://192.168.0.106:8000/api/v0/ais/get-feature-song-for-train-ai-model/"
```
Thay đổi http://192.168.0.106:8000 thành Ip và port khi chạy server

### Cấu hình IP ở Client
```bash
    class IpConfig {
      static const String ip = "http://192.168.0.106:8000";
    
      static String get frontUrl => "$ip/api/v0/";
    }
```
Thay đổi "http://192.168.0.106:8000" thành IP máy của bạn

### Cấu hình IP ở Admin-Dashboard Web (admin-dashboard\app\lib\services\service_mng.dart)

```bash
    String ip = "http://192.168.0.106:8000";
```
Thay đổi thành IP máy của bạn

## Sử dụng ứng dụng

1. Mở ứng dụng và đăng ký tài khoản mới.
2. Tìm kiếm và phát nhạc yêu thích của bạn.


