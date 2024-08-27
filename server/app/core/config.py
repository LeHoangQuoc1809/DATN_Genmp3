from pydantic_settings import BaseSettings
import os


class Settings(BaseSettings):
    DATABASE_HOST: str
    DATABASE_PORT: int
    DATABASE_USER: str
    DATABASE_PASSWORD: str
    DATABASE_NAME: str

    class Config:
        env_file = ".env"

settings = Settings()

# Debug: In ra các biến môi trường để kiểm tra
print(f"DATABASE_HOST: {settings.DATABASE_HOST}")
print(f"DATABASE_PORT: {settings.DATABASE_PORT}")
print(f"DATABASE_USER: {settings.DATABASE_USER}")
print(f"DATABASE_PASSWORD: {settings.DATABASE_PASSWORD}") 
print(f"DATABASE_NAME: {settings.DATABASE_NAME}")
print("---------------------------------------------")
print(f"DATABASE_HOST: {os.getenv('DATABASE_HOST')}")
print(f"DATABASE_PORT: {os.getenv('DATABASE_PORT')}")
print(f"DATABASE_USER: {os.getenv('DATABASE_USER')}")
print(f"DATABASE_PASSWORD: {os.getenv('DATABASE_PASSWORD')}") 
print(f"DATABASE_NAME: {os.getenv('DATABASE_NAME')}")
