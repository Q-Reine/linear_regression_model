from pydantic import BaseModel, Field

class EducationAccessInput(BaseModel):
    sex: str = Field(..., description="Gender: F for Female, M for Male")
    age: str = Field(..., description="Age group: Y15-24, Y25-34, Y35-44, Y45-54, Y55-64")
    hlth_pb: str = Field(..., description="Health problem: PB1040 (seeing), PB1041 (hearing), PB1070 (walking), PB1071 (remembering)")
    isced97: str = Field(..., description="Education level: ED0-2, ED3_4, ED5_6, NRP")
    geo: str = Field(..., description="Country code (European countries for reference, African countries for prediction)")
    time: int = Field(..., ge=2011, le=2030, description="Year between 2011 and 2030")