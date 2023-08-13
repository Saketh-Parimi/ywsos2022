from pydantic import ConfigDict, Field, BaseModel, EmailStr 
from bson import ObjectId
from models.PyObjectId import PyObjectId
from datetime import datetime

class UserModel(BaseModel):
    username: str = Field(...)
    password: str = Field(...)
    id: PyObjectId = Field(default_factory=PyObjectId, alias="_id")
    # TODO[pydantic]: The following keys were removed: `json_encoders`.
    # Check https://docs.pydantic.dev/dev-v2/migration/#changes-to-config for more information.
    model_config = ConfigDict(populate_by_name=True, arbitrary_types_allowed=True, json_encoders={ObjectId: str}, json_schema_extra={
        "example": {
            "username":"test",
            "password":"test"
        }
    })

class UserForgotPassModel(BaseModel):
    username: str = Field(...)
    key: str = Field(...)
    new_password: str = Field(...)
    id: PyObjectId = Field(default_factory=PyObjectId, alias="_id")
    # TODO[pydantic]: The following keys were removed: `json_encoders`.
    # Check https://docs.pydantic.dev/dev-v2/migration/#changes-to-config for more information.
    model_config = ConfigDict(populate_by_name=True, arbitrary_types_allowed=True, json_encoders={ObjectId: str}, json_schema_extra={
        "example": {
            "username":"test",
            "key":"test",
            "new_password":"test"
        }
    })