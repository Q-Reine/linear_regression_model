from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from models import EducationAccessInput
from prediction import predict_education_access

app = FastAPI(
    title="African Education Access Prediction API", 
    description="API for predicting and improving education access for disabled people in Africa using European educational infrastructure data as a reference model",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],  
    allow_headers=["*"],  
)

@app.post("/predict")
def predict(education_data: EducationAccessInput):
    """
    Predict education access for disabled people in Africa using European patterns as reference.
    
    This endpoint uses European educational infrastructure data to predict optimal resource allocation
    and provide policy recommendations for African countries.
    
    Returns:
    - predicted_access: Number of people with access (in thousands)
    - european_baseline: Reference prediction from European model (for African countries)
    - african_adjustment_factor: Adjustment factor applied (for African countries)
    - access_level: Categorical level (Very Low, Low, Moderate, High, Very High)
    - access_description: Description of the access level
    - african_recommendation: Specific recommendations for African educational improvement
    - policy_suggestion: Policy suggestions based on European patterns
    - unit: Unit of measurement (thousands)
    """
    prediction = predict_education_access(education_data)
    return prediction

@app.get("/")
def read_root():
    return {
        "message": "African Education Access Prediction API", 
        "description": "Using European educational infrastructure data to improve African education access",
        "docs": "/docs",
        "mission": "Improve educational accessibility for disabled people in Africa using European patterns as reference"
    }

@app.get("/countries")
def get_supported_countries():
    """
    Get list of supported countries (European reference countries and African target countries).
    """
    european_countries = [
        "AT ", "BE ", "BG ", "CH ", "CY ", "CZ ", "DE ", "DK ", "EE ", "EL ", 
        "ES ", "FI ", "FR ", "HR ", "HU ", "IE ", "IS ", "IT ", "LT ", "LU ", 
        "LV ", "MT ", "NL ", "PL ", "PT ", "RO ", "SE ", "SI ", "SK ", "TR ", "UK "
    ]
    
    african_countries = [
        "NG", "KE", "ZA", "GH", "ET", "EG", "MA", "TN", "UG", "TZ", 
        "RW", "BW", "NA", "ZM", "MW", "MZ", "AO", "CM", "CI", "SN"
    ]
    
    return {
        "european_reference_countries": european_countries,
        "african_target_countries": african_countries,
        "note": "European countries provide reference data, African countries receive predictions and recommendations"
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)