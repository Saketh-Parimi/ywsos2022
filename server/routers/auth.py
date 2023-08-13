from datetime import datetime

from fastapi import APIRouter, Header, status, Body, HTTPException, Depends, Request, Response
from fastapi.responses import RedirectResponse
from fastapi.security import OAuth2PasswordRequestForm
from db import db
from uuid import uuid4
from models.user import UserModel
from .utils import create_access_tokens, verify_password, create_refresh_token, get_hashed_password


router = APIRouter()


@router.post("/login")
# async def login(form_data: OAuth2PasswordRequestForm = Depends()):
#     userLoggingIn = await db.users.find_one({"username":user.username})
#     if userLoggingIn != None:
#         print(user.password)
#         print(userLoggingIn['password'])
#         if pbkdf2_sha256.verify(user.password, userLoggingIn['password']):
#             access_token = Authorize.create_access_token(subject=user.username)
#             refresh_token = Authorize.create_refresh_token(subject=user.username)
#             return {"status_code":status.HTTP_200_OK, "content":"success", "access_token": access_token, "refresh_token": refresh_token}
#         else:
#             return {"status_code":status.HTTP_401_UNAUTHORIZED, "status":"failure", "content":"Password incorrect"}
#     else:
#        return {"status_code":status.HTTP_401_UNAUTHORIZED, "status":"failure", "content":"Userame not found."}

# Create the tokens and passing to set_access_cookies or set_refresh_cookies
async def login(response: Response, form_data: OAuth2PasswordRequestForm = Depends()):
    user = await db.users.find_one({"username": form_data.username})
    if user is None:
        response.status_code = status.HTTP_400_BAD_REQUEST
        return {"content": "Incorrect email or password"}
    hash_pass = user['password']
    if not verify_password(form_data.password, hash_pass):
        response.status_code = status.HTTP_400_BAD_REQUEST
        return {"status": "failure", "content": "Incorrect email or password"}

    return {"status": "success", "access_token": create_access_tokens(user['username']),
            "refresh_token": create_refresh_token(user['username'])}


# @router.delete('/logout')
#
# def logout(Authorize: AuthJWT = Depends()):
#     """
#     Because the JWT are stored in an httponly cookie now, we cannot
#     log the user out by simply deleting the cookies in the frontend.
#     We need the backend to send us a response to delete the cookies.
#     """
#     Authorize.jwt_required()
#
#     Authorize.unset_jwt_cookies()
#     response = JSONResponse(status_code=status.HTTP_200_OK, content="success")
#     response.delete_cookie("access_token_cookie")
#     response.delete_cookie("csrf_access_token")
#     response.delete_cookie("csrf_refresh_token")
#     response.delete_cookie("refresh_token_cookie")
#     return response

# @router.get('/access-token')
# def access_token(Authorize: AuthJWT = Depends(), user_agent: Union[str, None] = Header(default=None)):
#     print(user_agent)
#     Authorize.jwt_required()
#     return {"status_code": status.HTTP_200_OK, "content":"success"}

# @router.get('/refresh-token')
# def refresh_token():
#     """
#     The jwt_refresh_token_required() function insures a valid refresh
#     token is present in the request before running any code below that function.
#     we use the get_jwt_subject() function to get the subject of the refresh
#     token, and use create_access_token() function again to make a new access token
#     """

#     # Authorize.jwt_refresh_token_required()
#     access_token = create_access_tokens()
#     return {"access_token": access_token}


@router.post("/register")
async def register(response: Response, user: UserModel):
    special_characters = "!@#$%^&*()-+?_=,<>/"
    user_check = await db.users.find_one({"username": user.username})
    if user_check == None:
        if len(user.username) > 3:
            if any(c in special_characters for c in user.password):

                db.users.insert_one({
                    "username": user.username,
                    "password": get_hashed_password(user.password),
                    "created_at": datetime.utcnow(),
                })
                response.status_code = status.HTTP_200_OK
                return {"status_code": status.HTTP_200_OK, "content": "success"}
            else:
                response.status_code = status.HTTP_422_UNPROCESSABLE_ENTITY
                return {"status_code": status.HTTP_422_UNPROCESSABLE_ENTITY, "status": "failure",
                        "content": "Give your password a special character!"}
        else:
            response.status_code = status.HTTP_411_LENGTH_REQUIRED
            return {"status_code": status.HTTP_411_LENGTH_REQUIRED, "status": "failure",
                    "content": "Make your username more than three digits!"}
    else:
        response.status_code = status.HTTP_422_UNPROCESSABLE_ENTITY
        return {"status_code": status.HTTP_422_UNPROCESSABLE_ENTITY, "status": "failure",
                "content": "Username already taken"}


# @router.post("/forgotpass")
# async def forgotpass(response: Response, user: UserForgotPassModel, Authorize: AuthJWT = Depends()):
#     user_forgot = await db.users.find_one({"username": user.username})
#     if user_forgot != None:
#         if user.key == user_forgot['key']:
#             if passwordCheck(user.new_password) == True:
#                 access_token = Authorize.create_access_token(subject=user.username)
#                 refresh_token = Authorize.create_refresh_token(subject=user.username)
#                 update_result = await db.users.update_one({"username": user.username},
#                                                           {"$set": {"password": pbkdf2_sha256.hash(user.new_password)}})
#                 if update_result.matched_count == 0:
#                     return Response(status_code=status.HTTP_404_NOT_FOUND, content="User not found")
#                 return Response(status_code=status.HTTP_200_OK, content="User succesfully updated")
#             else:
#                 return {"status_code": status.HTTP_401_UNAUTHORIZED, "status": "failure",
#                         "content": "Make sure your password has special characters and is mroe than 3 characters!"}
#         else:
#             return {"status_code": status.HTTP_401_UNAUTHORIZED, "status": "failure", "content": "Key incorrect"}
#     else:
#         return {"status_code": status.HTTP_401_UNAUTHORIZED, "status": "failure", "content": "Userame not found."}
