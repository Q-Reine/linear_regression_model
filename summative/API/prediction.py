import joblib
import numpy as np
from fastapi import HTTPException

# Load the pre-trained model, scaler, and encoders
try:
    model = joblib.load("best_model.pkl")
    scaler = joblib.load("scaler.pkl")
    encoders = joblib.load("encoders.pkl")
except Exception as e:
    raise Exception(f"Error loading model, scaler, or encoders: {str(e)}")

# African country adjustment factors (based on development indicators)
AFRICAN_ADJUSTMENT_FACTORS = {
    'NG': 0.3,  # Nigeria
    'KE': 0.4,  # Kenya
    'ZA': 0.6,  # South Africa
    'GH': 0.5,  # Ghana
    'ET': 0.2,  # Ethiopia
    'EG': 0.4,  # Egypt
    'MA': 0.5,  # Morocco
    'TN': 0.6,  # Tunisia
    'UG': 0.3,  # Uganda
    'TZ': 0.3,  # Tanzania
    'RW': 0.4,  # Rwanda
    'BW': 0.5,  # Botswana
    'NA': 0.4,  # Namibia
    'ZM': 0.3,  # Zambia
    'MW': 0.3,  # Malawi
    'MZ': 0.2,  # Mozambique
    'AO': 0.3,  # Angola
    'CM': 0.3,  # Cameroon
    'CI': 0.4,  # Ivory Coast
    'SN': 0.4,  # Senegal
}

def get_african_adjustment(country_code):
    """Get adjustment factor for African countries based on development level."""
    return AFRICAN_ADJUSTMENT_FACTORS.get(country_code, 0.4)  # Default to 0.4

def get_african_recommendations(data, prediction, is_african_country=False):
    """Generate African-specific recommendations based on European patterns."""
    if not is_african_country:
        return "This is a European reference case. Use these patterns to inform African educational development."
    
    recommendations = []
    
    # Age-based recommendations
    if data.age == 'Y15-24':
        recommendations.append("Focus on vocational training and skills development for young people with disabilities.")
    elif data.age == 'Y25-34':
        recommendations.append("Develop higher education accessibility programs and career transition support.")
    elif data.age in ['Y35-44', 'Y45-54']:
        recommendations.append("Implement adult education programs and workplace accommodation initiatives.")
    
    # Health problem specific recommendations
    if data.hlth_pb == 'PB1040':  # Seeing
        recommendations.append("Invest in Braille materials, screen readers, and visual accessibility technology.")
    elif data.hlth_pb == 'PB1041':  # Hearing
        recommendations.append("Provide sign language interpreters, hearing aids, and audio-visual learning materials.")
    elif data.hlth_pb == 'PB1070':  # Walking
        recommendations.append("Ensure physical accessibility with ramps, elevators, and mobility assistance.")
    elif data.hlth_pb == 'PB1071':  # Remembering
        recommendations.append("Develop cognitive support programs and memory enhancement training.")
    
    # Education level recommendations
    if data.isced97 == 'ED0-2':
        recommendations.append("Establish early intervention programs and inclusive primary education.")
    elif data.isced97 == 'ED3_4':
        recommendations.append("Create accessible secondary education with specialized support services.")
    elif data.isced97 == 'ED5_6':
        recommendations.append("Develop inclusive tertiary education with disability support offices.")
    
    # Access level based recommendations
    if prediction < 100:
        recommendations.append("Urgent need for basic educational infrastructure and teacher training.")
    elif prediction < 200:
        recommendations.append("Requires significant investment in educational resources and accessibility.")
    elif prediction < 500:
        recommendations.append("Moderate investment needed in specialized programs and facilities.")
    else:
        recommendations.append("Focus on maintaining and expanding existing successful programs.")
    
    return " ".join(recommendations)

def get_policy_suggestions(country_code, prediction):
    """Generate policy suggestions for African countries."""
    if country_code not in AFRICAN_ADJUSTMENT_FACTORS:
        return "Use European educational policies as reference for development."
    
    suggestions = []
    
    # Infrastructure policies
    suggestions.append("Develop inclusive education infrastructure with universal design principles.")
    
    # Training policies
    suggestions.append("Implement comprehensive teacher training programs for inclusive education.")
    
    # Partnership policies
    suggestions.append("Establish partnerships with European institutions for knowledge transfer and capacity building.")
    
    # Technology policies
    suggestions.append("Invest in assistive technologies and digital accessibility solutions.")
    
    # Funding policies
    if prediction < 200:
        suggestions.append("Prioritize funding for basic educational accessibility and infrastructure.")
    else:
        suggestions.append("Allocate resources for advanced educational programs and specialized services.")
    
    # Monitoring policies
    suggestions.append("Establish monitoring and evaluation systems to track educational access improvements.")
    
    return " ".join(suggestions)

def predict_education_access(data):
    try:
        # Check if this is an African country
        is_african_country = data.geo in AFRICAN_ADJUSTMENT_FACTORS
        
        # For African countries, we need to handle them differently since they're not in the training data
        if is_african_country:
            # Use a reference European country for encoding
            reference_geo = 'BE '  # Belgium as reference
            sex_encoded = encoders['sex_encoder'].transform([data.sex])[0]
            age_encoded = encoders['age_encoder'].transform([data.age])[0]
            hlth_pb_encoded = encoders['hlth_pb_encoder'].transform([data.hlth_pb])[0]
            isced97_encoded = encoders['isced97_encoder'].transform([data.isced97])[0]
            geo_encoded = encoders['geo_encoder'].transform([reference_geo])[0]
        else:
            # For European countries, use normal encoding
            sex_encoded = encoders['sex_encoder'].transform([data.sex])[0]
            age_encoded = encoders['age_encoder'].transform([data.age])[0]
            hlth_pb_encoded = encoders['hlth_pb_encoder'].transform([data.hlth_pb])[0]
            isced97_encoded = encoders['isced97_encoder'].transform([data.isced97])[0]
            geo_encoded = encoders['geo_encoder'].transform([data.geo])[0]
        
        # Create input array in the same order as training
        input_data = np.array([
            sex_encoded, age_encoded, hlth_pb_encoded, 
            isced97_encoded, geo_encoded, data.time
        ]).reshape(1, -1)

        # Scale the input data
        input_data_scaled = scaler.transform(input_data)

        # Make prediction
        european_prediction = float(model.predict(input_data_scaled)[0])
        
        # Apply African adjustment if it's an African country
        if is_african_country:
            african_adjustment = get_african_adjustment(data.geo)
            prediction = european_prediction * african_adjustment
        else:
            prediction = european_prediction

        # Determine access level category
        access_level = get_access_level(prediction)
        
        # Generate African recommendations
        african_recommendation = get_african_recommendations(data, prediction, is_african_country)
        
        # Generate policy suggestions
        policy_suggestion = get_policy_suggestions(data.geo, prediction)

        return {
            "predicted_access": prediction,
            "european_baseline": european_prediction if is_african_country else None,
            "african_adjustment_factor": get_african_adjustment(data.geo) if is_african_country else None,
            "access_level": access_level["level"],
            "access_description": access_level["description"],
            "african_recommendation": african_recommendation,
            "policy_suggestion": policy_suggestion,
            "unit": "thousands"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction error: {str(e)}")

def get_access_level(value):
    """Map predicted value to access level category."""
    if value >= 1000:
        return {"level": "Very High", "description": "Excellent access to education"}
    elif value >= 500:
        return {"level": "High", "description": "Good access to education"}
    elif value >= 200:
        return {"level": "Moderate", "description": "Moderate access to education"}
    elif value >= 100:
        return {"level": "Low", "description": "Limited access to education"}
    else:
        return {"level": "Very Low", "description": "Very limited access to education"}