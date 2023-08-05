from fastapi import APIRouter, Header, status, Body, HTTPException, Depends, Request, Response
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse 
from config import settings
from passlib.hash import pbkdf2_sha256
from db import db
from models.post import PostModel
from typing import List, Union
from fastapi_jwt_auth import AuthJWT
from fastapi_jwt_auth.exceptions import AuthJWTException
from models.user import UserModel, UserForgotPassModel
from datetime import datetime
from pydantic import BaseSettings
from random import *
from .helpers import hexCode, passwordCheck


class Settings(BaseSettings):

    authjwt_secret_key: str = "secret"
    # Configure application to store and get JWT from cookies
    authjwt_token_location: set = {"headers"}
    # Only allow JWT cookies to be sent over https
    authjwt_cookie_secure: bool = False
    # Enable csrf double submit protection. default is True
    authjwt_cookie_csrf_protect: bool = True
    
    

router = APIRouter()

@AuthJWT.load_config
def get_config():
    return Settings()

@router.post("/login")

async def login(response: Response, user: UserModel, Authorize: AuthJWT = Depends()):
    userLoggingIn = await db.users.find_one({"username":user.username})
    if userLoggingIn != None:
        print(user.password)
        print(userLoggingIn['password'])
        if pbkdf2_sha256.verify(user.password, userLoggingIn['password']):
            access_token = Authorize.create_access_token(subject=user.username)
            refresh_token = Authorize.create_refresh_token(subject=user.username)
            return {"status_code":status.HTTP_200_OK, "content":"success", "access_token": access_token, "refresh_token": refresh_token}
        else:
            return {"status_code":status.HTTP_401_UNAUTHORIZED, "status":"failure", "content":"Password incorrect"}
    else:
       return {"status_code":status.HTTP_401_UNAUTHORIZED, "status":"failure", "content":"Userame not found."}

    # Create the tokens and passing to set_access_cookies or set_refresh_cookies


@router.delete('/logout')

def logout(Authorize: AuthJWT = Depends()):
    """
    Because the JWT are stored in an httponly cookie now, we cannot
    log the user out by simply deleting the cookies in the frontend.
    We need the backend to send us a response to delete the cookies.
    """
    Authorize.jwt_required()

    Authorize.unset_jwt_cookies()
    response = JSONResponse(status_code=status.HTTP_200_OK, content="success")
    response.delete_cookie("access_token_cookie")
    response.delete_cookie("csrf_access_token")
    response.delete_cookie("csrf_refresh_token")
    response.delete_cookie("refresh_token_cookie")
    return response

@router.get('/access-token')
def access_token(Authorize: AuthJWT = Depends(), user_agent: Union[str, None] = Header(default=None)):
    print(user_agent)
    Authorize.jwt_required()
    return {"status_code": status.HTTP_200_OK, "content":"success"}

@router.get('/refresh-token')
def refresh_token(Authorize: AuthJWT = Depends(), user_agent: Union[str, None] = Header(default=None)):
    """
    The jwt_refresh_token_required() function insures a valid refresh
    token is present in the request before running any code below that function.
    we use the get_jwt_subject() function to get the subject of the refresh
    token, and use create_access_token() function again to make a new access token
    """

    # Authorize.jwt_refresh_token_required()
    current_user = Authorize.get_jwt_subject()
    access_token = Authorize.create_access_token(subject=current_user)
    return {"access_token": access_token}


@router.post("/register")
async def register(response: Response, user: UserModel, Authorize: AuthJWT = Depends()):
    special_characters = "!@#$%^&*()-+?_=,<>/"
    user_check = await db.users.find_one({"username":user.username})
    if user_check == None:
        if len(user.username) > 3:
            if any(c in special_characters for c in user.password):
                secret_key = hexCode()
                db.users.insert_one({
                    "username": user.username,
                    "password": pbkdf2_sha256.hash(user.password),
                    "created_at": datetime.utcnow(),
                    "key": secret_key
                })
                response.status_code = status.HTTP_200_OK
                return {"status_code":status.HTTP_200_OK, "content":"success", "key":secret_key}
            else:
                response.status_code = status.HTTP_422_UNPROCESSABLE_ENTITY
                return {"status_code":status.HTTP_422_UNPROCESSABLE_ENTITY, "status":"failure", "content":"Give your password a special character!"}
        else:
            response.status_code = status.HTTP_411_LENGTH_REQUIRED
            return {"status_code":status.HTTP_411_LENGTH_REQUIRED, "status":"failure", "content":"Make your username more than three digits!"}
    else:
        response.status_code = status.HTTP_422_UNPROCESSABLE_ENTITY
        return {"status_code":status.HTTP_422_UNPROCESSABLE_ENTITY, "status":"failure", "content":"Username already taken"}

@router.post("/forgotpass")

async def forgotpass(response: Response, user: UserForgotPassModel, Authorize: AuthJWT = Depends()):
    user_forgot = await db.users.find_one({"username":user.username})
    if user_forgot != None:
        if user.key == user_forgot['key']:
            if passwordCheck(user.new_password) == True:
                access_token = Authorize.create_access_token(subject=user.username)
                refresh_token = Authorize.create_refresh_token(subject=user.username)
                update_result = await db.users.update_one({"username": user.username}, {"$set": {"password": pbkdf2_sha256.hash(user.new_password)}})
                if update_result.matched_count == 0:
                    return JSONResponse(status_code=status.HTTP_404_NOT_FOUND,content="User not found")
                return JSONResponse(status_code=status.HTTP_200_OK,content="User succesfully updated")
            else:
                return {"status_code":status.HTTP_401_UNAUTHORIZED, "status":"failure", "content":"Make sure your password has special characters and is mroe than 3 characters!"}
        else:
            return {"status_code":status.HTTP_401_UNAUTHORIZED, "status":"failure", "content":"Key incorrect"}
    else:
       return {"status_code":status.HTTP_401_UNAUTHORIZED, "status":"failure", "content":"Userame not found."}
       
     
