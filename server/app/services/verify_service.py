from fastapi import HTTPException, Form
import base64
from app.schemas.user import UserBase
import httpx, random, string, getpass, smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email_validator import validate_email, EmailNotValidError
import httpx

def validate_email_syntax(email: str) -> bool:
    try:
        validate_email(email)
        return True
    except EmailNotValidError:
        return False

async def validate_email_with_hunter(email: str) -> bool:
    api_key = "your_hunter_api_key"
    url = f"https://api.hunter.io/v2/email-verifier?email={email}&api_key={api_key}"
    
    async with httpx.AsyncClient() as client:
        response = await client.get(url)
        if response.status_code == 200:
            data = response.json()
            return data.get("data", {}).get("status") == "valid"
        else:
            return False

async def send_email_for_create_user(user: UserBase, otp: str = Form(...)) -> bool:
    try:
        # # Kiểm tra cú pháp của email
        # if not validate_email_syntax(user.email):
        #     raise HTTPException(status_code=400, detail="Invalid email syntax")

        # # Kiểm tra tính hợp lệ của email sử dụng Hunter.io
        # if not await validate_email_with_hunter(user.email):
        #     raise HTTPException(status_code=400, detail="Invalid email")
        
        # Gửi otp đến gmail của user vừa đựa tạo
        sender_email = "noreply.genmp3@gmail.com" 
        sender_password = "kkvv gybd hcjv rgcy"  
        receiver_email = user.email
        subject = "Mã xác minh tạo tài khoản Genmp3"
        body = f"""
        <html>
        <body>
            <div style="max-width: 600px; margin: 0 auto; font-family: Arial, sans-serif; color: #333;">
                <div style="background-color: #f7f7f7; padding: 20px; border-bottom: 1px solid #ddd;">
                    <h2 style="text-align: center;">Mã xác minh tạo tài khoản Genmp3</h2>
                </div>
                <div style="padding: 20px;">
                    <p>Xin chào {user.name}!</p>
                    <p>Mã xác minh bạn cần dùng để tạo tài khoản Genmp3 của mình ({user.email}) là:</p>
                    <div style="text-align: center; margin: 20px 0;">
                        <h1 style="display: inline-block; padding: 10px 20px; border: 1px solid #ddd; background-color: #f9f9f9;">{otp}</h1>
                    </div>
                    <p>Bạn đang tiến hành tạo tài khoản, mã xác minh này có hiệu lực trong vòng 3p. <b>Tuyệt đối không tiết lộ mã xác minh này cho bất kỳ ai để đảm bảo an toàn cho tài khoản Genmp3 của bạn.</b></p>
                    <p>Trân trọng!</p>
                    <p>Nhóm tài khoản Genmp3</p>
                </div>
                <div style="background-color: #f7f7f7; padding: 10px; text-align: center; border-top: 1px solid #ddd;">
                    <p style="font-size: 12px; color: #999;">© 2024 Genmp3. All rights reserved.</p>
                </div>
            </div>
        </body>
        </html>
        """
        # Tạo đối tượng MIMEMultipart và thiết lập các thông tin cần thiết
        message = MIMEMultipart()
        message["From"] = sender_email
        message["To"] = receiver_email
        message["Subject"] = subject
        message["Reply-To"] = "noreply@genmp3.com"  # Đặt địa chỉ trả lời
        # Thêm nội dung email
        message.attach(MIMEText(body, "html"))
        # Kết nối đến server SMTP
        server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
        server.login(sender_email, sender_password)
        server.sendmail(sender_email, receiver_email, message.as_string())
        server.close()
        return True
    except smtplib.SMTPAuthenticationError:
        raise HTTPException(status_code=500, detail="SMTP Authentication Error: Failed to authenticate with SMTP server.")
    except smtplib.SMTPException as e:
        raise HTTPException(status_code=500, detail=f"SMTP Error: Failed to send email. Error message: {str(e)}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to send email: {str(e)}")
    

async def send_email_for_forgot_password(user: UserBase, otp: str = Form(...)) -> bool:
    try:
        # Gửi otp đến gmail của user
        sender_email = "noreply.genmp3@gmail.com" 
        sender_password = "kkvv gybd hcjv rgcy"  
        receiver_email = user.email
        subject = "Mã xác minh quên mật khẩu Genmp3"
        body = f"""
        <html>
        <body>
            <div style="max-width: 600px; margin: 0 auto; font-family: Arial, sans-serif; color: #333;">
                <div style="background-color: #f7f7f7; padding: 20px; border-bottom: 1px solid #ddd;">
                    <h2 style="text-align: center;">Mã xác minh quên mật khẩu Genmp3</h2>
                </div>
                <div style="padding: 20px;">
                    <p>Xin chào {user.name}!</p>
                    <p>Mã xác minh bạn cần dùng để thay đổi mật khẩu tài khoản Genmp3 của mình ({user.email}) là:</p>
                    <div style="text-align: center; margin: 20px 0;">
                        <h1 style="display: inline-block; padding: 10px 20px; border: 1px solid #ddd; background-color: #f9f9f9;">{otp}</h1>
                    </div>
                    <p>Bạn đang tiến hành thay đổi mật khẩu, mã xác minh này có hiệu lực trong vòng 5p. <b>Tuyệt đối không tiết lộ mã xác minh này cho bất kỳ ai để đảm bảo an toàn cho tài khoản Genmp3 của bạn.</b> Nếu như đây không phải thao tác từ bạn, hãy lập tức thay đổi mật khẩu.</p>
                    <p>Trân trọng!</p>
                    <p>Nhóm tài khoản Genmp3</p>
                </div>
                <div style="background-color: #f7f7f7; padding: 10px; text-align: center; border-top: 1px solid #ddd;">
                    <p style="font-size: 12px; color: #999;">© 2024 Genmp3. All rights reserved.</p>
                </div>
            </div>
        </body>
        </html>
        """
        # Tạo đối tượng MIMEMultipart và thiết lập các thông tin cần thiết
        message = MIMEMultipart()
        message["From"] = sender_email
        message["To"] = receiver_email
        message["Subject"] = subject
        message["Reply-To"] = "noreply@genmp3.com"  # Đặt địa chỉ trả lời
        # Thêm nội dung email
        message.attach(MIMEText(body, "html"))
        # Kết nối đến server SMTP
        server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
        server.login(sender_email, sender_password)
        server.sendmail(sender_email, receiver_email, message.as_string())
        server.close()
        return True
    except smtplib.SMTPAuthenticationError:
        raise HTTPException(status_code=500, detail="SMTP Authentication Error: Failed to authenticate with SMTP server.")
    except smtplib.SMTPException as e:
        raise HTTPException(status_code=500, detail=f"SMTP Error: Failed to send email. Error message: {str(e)}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to send email: {str(e)}")
    


