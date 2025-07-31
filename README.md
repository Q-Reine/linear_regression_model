# African Education Access Prediction Project

This repository contains my summative assignment for BSE Mathematics for Machine Learning, deploying a linear regression model to predict and improve education access for disabled people in Africa using European educational infrastructure data as a reference model. The project addresses a specific use case - predicting optimal educational accessibility and resource allocation for African countries based on proven European educational patterns — and avoids generic or housing-related datasets as per instructions. It is structured into four tasks:

- Task 1: Model training
- Task 2: API development
- Task 3: Flutter app creation
- Task 4: Video demo

## File Structure

```text
linear_regression_model/
├── summative/
│   ├── linear_regression/
│   │   ├── multivariate.ipynb  
│   │   ├── Access to Education Disabled People Europe.csv
│   ├── API/
│   │   ├── main.py             
│   │   ├── models.py           
│   │   ├── prediction.py       
│   │   ├── best_model.pkl      
│   │   ├── scaler.pkl          
│   │   ├── encoders.pkl        
│   │   ├── requirements.txt    
│   ├── FlutterApp/             
│   │   ├── lib/
│   │   │   ├── main.dart       
│   │   ├── pubspec.yaml        
├── README.md                   
```

## Mission

Improve educational accessibility for disabled people in Africa by leveraging European educational infrastructure data as a reference model. Our system predicts optimal resource allocation and policy interventions for African countries, using proven European educational approaches to inform African educational development strategies.

**Dataset Description**: We use European education access data as a reference model to predict and improve educational accessibility in African countries. This approach allows us to leverage proven educational infrastructure patterns from developed European systems to inform African educational policy and resource allocation decisions. The dataset contains 13,952 records with 8 features (e.g., Gender, Age Group, Health Problem Type, Education Level, Country, Year) and access value as the target variable. It's rich in volume (thousands of rows) and variety (demographic, health, geographic, and temporal variables). 

**Sourced from**: [Kaggle: Access to Education of Disabled People in Europe](https://www.kaggle.com/datasets/gpreda/access-to-education-of-disabled-people-in-europe)

**Visualizations**:
1. **Correlation Heatmap**: Shows relationships between features like education level, health problem type, and geographic location.
2. **Access Distribution**: Histogram of access values reveals the distribution of educational access across different demographics and regions.

---

## Task 1: Linear Regression Task

### Description
- **File**: `summative/linear_regression/multivariate.ipynb`
- **Objective**: Build and optimize a linear regression model using gradient descent to predict education access for disabled people, comparing it with Decision Trees and Random Forest, with the goal of applying European patterns to African educational contexts.
- **Process**:
  - Loaded the Kaggle "Access to Education of Disabled People in Europe" dataset (non-housing, non-generic).
  - Preprocessed data (encoded categorical variables, normalized using `StandardScaler`).
  - Trained three models using `scikit-learn`:
    1. Linear Regression (SGD)
    2. Decision Trees
    3. Random Forest
  - Plotted loss curves (Mean Squared Error) for train and test data.
  - Compared performance and saved the best model as `best_model.pkl`, scaler as `scaler.pkl`, and encoders as `encoders.pkl`.
  - Included code to predict access for one test data point, with a scatter plot of the fitted linear regression line.

### Artifacts
- `best_model.pkl`: Trained model (Linear Regression, Decision Tree, or Random Forest).
- `scaler.pkl`: Scaler for input normalization.
- `encoders.pkl`: Label encoders for categorical variables.

---

## Task 2: API Development

### Description
- **Directory**: `summative/API/`
- **Objective**: Create a FastAPI endpoint to predict education access using the Task 1 model, with enhanced functionality to provide African-specific recommendations based on European patterns.
- **Endpoint**: `/predict` (POST)
- **Input**: JSON with 6 fields (e.g., `sex`, `age`, `hlth_pb`, `isced97`, `geo`, `time`).
- **Output**: JSON with `predicted_access`, `access_level`, `access_description`, `african_recommendation`, `policy_suggestion`, and `unit`.

### Files
- `main.py`: FastAPI app with CORS middleware.
- `models.py`: Pydantic `BaseModel` enforcing data types and constraints.
- `prediction.py`: Loads model/scaler/encoders, predicts access, and maps to access level with African recommendations.
- `requirements.txt`: Lists dependencies (`fastapi`, `pydantic`, `uvicorn`, `scikit-learn`, `joblib`).

### Deployment
- **Platform**: Render
- **Public URL**: [https://education-access-api.onrender.com/docs](https://education-access-api.onrender.com/docs)
- **API Endpoint**: [https://education-access-api.onrender.com/predict](https://education-access-api.onrender.com/predict)
- **Instructions**:
  1. Push `summative/API/` to GitHub.
  2. Deploy on Render:
     - **Runtime**: Python 3
     - **Build Command**: `pip install -r requirements.txt`
     - **Start Command**: `uvicorn main:app --host 0.0.0.0 --port $PORT`
  3. Verify Swagger UI at `/docs`.

### Example Request

```json
{
  "sex": "F",
  "age": "Y25-34",
  "hlth_pb": "PB1040",
  "isced97": "ED3_4",
  "geo": "NG",
  "time": 2023
}
```

### Response

```json
{
  "predicted_access": 245.67,
  "access_level": "Moderate",
  "access_description": "Moderate access to education",
  "african_recommendation": "Based on European patterns, this demographic needs improved infrastructure and specialized training programs. Consider implementing inclusive education policies similar to successful European models.",
  "policy_suggestion": "Develop specialized teacher training programs and invest in accessible educational infrastructure. Partner with European institutions for knowledge transfer.",
  "unit": "thousands"
}
```

---

## Task 3: Flutter App

### Description
- **Directory**: `summative/FlutterApp/`
- **Objective**: Build a mobile app to interact with the Task 2 API, focused on improving African educational accessibility.
- **Features**:
  - Two pages: Home (welcome screen) and Prediction.
  - 6 input fields (5 dropdowns for categorical variables, 1 text field for year).
  - "Predict Access" button.
  - Output display showing access prediction, level, African recommendations, and policy suggestions.

### Running Locally
1. Navigate to `summative/FlutterApp/`.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Task 4: Video Demo

### Description
- **Demo Link**: [[Demo Video URL](https://docs.google.com/document/d/1_4XNmhD_ZRaUX2q1gh8-YTftpVtZRoGrqxuM0B3cZxo/edit?tab=t.0)] 

---

