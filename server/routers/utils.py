from passlib.context import CryptContext
import os
from dotenv import load_dotenv
from datetime import datetime, timedelta
from typing import Union, Any
from jose import jwt
load_dotenv()
password_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

ACCESS_TOKEN_EXPIRE_MINUTES = 30
REFRESH_TOKEN_EXPIRE_MINUTES = 60 * 24 * 7 # 7 days
ALGORITHM = "HS256"
JWT_SECRET_KEY = os.environ['JWT_SECRET_KEY']   # should be kept secret
JWT_REFRESH_SECRET_KEY = os.environ['JWT_REFRESH_SECRET_KEY']


def get_hashed_password(password: str) -> str:
    return password_context.hash(password)


def verify_password(password: str, hashed_pass: str) -> bool:
    return password_context.verify(password, hashed_pass)

def create_access_tokens(subject: Union[str, Any], expires: int = None):
    if expires is not None:
        expires_delta = datetime.utcnow() + expires
    else:
        expires = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)

    payload = {"exp": expires, "sub": str(subject)}
    encoded_jwt = jwt.encode(payload, JWT_SECRET_KEY, ALGORITHM)
    return encoded_jwt

def create_refresh_token(subject: Union[str, Any], expires_delta: int = None) -> str:
    if expires_delta is not None:
        expires_delta = datetime.utcnow() + expires_delta
    else:
        expires_delta = datetime.utcnow() + timedelta(minutes=REFRESH_TOKEN_EXPIRE_MINUTES)

    to_encode = {"exp": expires_delta, "sub": str(subject)}
    encoded_jwt = jwt.encode(to_encode, JWT_REFRESH_SECRET_KEY, ALGORITHM)
    return encoded_jwt