from pydantic_settings import SettingsConfigDict, BaseSettings
class Settings (BaseSettings):
    MONGODB_URI: str
    JWT_SECRET_KEY: str
    JWT_REFRESH_SECRET_KEY: str
    model_config = SettingsConfigDict(env_file='./.env', total=False)

settings = Settings()
