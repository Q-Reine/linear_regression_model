import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "African Education Access Predictor",
      theme: ThemeData(
        primaryColor: Color(0xFF2E7D32),
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black54),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 3,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 80, color: Color(0xFF2E7D32)),
            SizedBox(height: 20),
            Text(
              "African Education Access Predictor",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Using European data to improve education access for disabled people in Africa",
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFFE8F5E8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF2E7D32), width: 1),
              ),
              child: Text(
                "Our Mission: Improve educational accessibility for disabled people in Africa by leveraging European educational infrastructure patterns as a reference model.",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2E7D32),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PredictionPage()),
                );
              },
              child: Text("Start Predicting", style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PredictionPage extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final _yearController = TextEditingController();

  Map<String, String?> _dropdownValues = {
    "sex": null,
    "age": null,
    "hlth_pb": null,
    "isced97": null,
    "geo": null,
  };

  String _result = "";
  Color _resultColor = Colors.black87;

  final Map<String, List<Map<String, dynamic>>> _dropdownOptions = {
    "sex": [
      {"display": "Female", "value": "F"},
      {"display": "Male", "value": "M"},
    ],
    "age": [
      {"display": "15-24 years", "value": "Y15-24"},
      {"display": "25-34 years", "value": "Y25-34"},
      {"display": "35-44 years", "value": "Y35-44"},
      {"display": "45-54 years", "value": "Y45-54"},
      {"display": "55-64 years", "value": "Y55-64"},
    ],
    "hlth_pb": [
      {"display": "Seeing difficulties", "value": "PB1040"},
      {"display": "Hearing difficulties", "value": "PB1041"},
      {"display": "Walking difficulties", "value": "PB1070"},
      {"display": "Remembering difficulties", "value": "PB1071"},
    ],
    "isced97": [
      {"display": "Pre-primary to lower secondary", "value": "ED0-2"},
      {"display": "Upper secondary and post-secondary", "value": "ED3_4"},
      {"display": "Tertiary education", "value": "ED5_6"},
      {"display": "Not reported", "value": "NRP"},
    ],
    "geo": [
      // African Countries (Primary Focus)
      {"display": "🇳🇬 Nigeria", "value": "NG"},
      {"display": "🇰🇪 Kenya", "value": "KE"},
      {"display": "🇿🇦 South Africa", "value": "ZA"},
      {"display": "🇬🇭 Ghana", "value": "GH"},
      {"display": "🇪🇹 Ethiopia", "value": "ET"},
      {"display": "🇪🇬 Egypt", "value": "EG"},
      {"display": "🇲🇦 Morocco", "value": "MA"},
      {"display": "🇹🇳 Tunisia", "value": "TN"},
      {"display": "🇺🇬 Uganda", "value": "UG"},
      {"display": "🇹🇿 Tanzania", "value": "TZ"},
      {"display": "🇷🇼 Rwanda", "value": "RW"},
      {"display": "🇧🇼 Botswana", "value": "BW"},
      {"display": "🇳🇦 Namibia", "value": "NA"},
      {"display": "🇿🇲 Zambia", "value": "ZM"},
      {"display": "🇲🇼 Malawi", "value": "MW"},
      {"display": "🇲🇿 Mozambique", "value": "MZ"},
      {"display": "🇦🇴 Angola", "value": "AO"},
      {"display": "🇨🇲 Cameroon", "value": "CM"},
      {"display": "🇨🇮 Ivory Coast", "value": "CI"},
      {"display": "🇸🇳 Senegal", "value": "SN"},
      // European Countries (Reference)
      {"display": "🇧🇪 Belgium (Reference)", "value": "BE "},
      {"display": "🇩🇪 Germany (Reference)", "value": "DE "},
      {"display": "🇫🇷 France (Reference)", "value": "FR "},
      {"display": "🇮🇹 Italy (Reference)", "value": "IT "},
      {"display": "🇪🇸 Spain (Reference)", "value": "ES "},
      {"display": "🇳🇱 Netherlands (Reference)", "value": "NL "},
      {"display": "🇵🇱 Poland (Reference)", "value": "PL "},
      {"display": "🇷🇴 Romania (Reference)", "value": "RO "},
      {"display": "🇸🇪 Sweden (Reference)", "value": "SE "},
      {"display": "🇦🇹 Austria (Reference)", "value": "AT "},
    ],
  };

  Future<void> _predict() async {
    // Update this URL to your deployed API endpoint
    final url = Uri.parse("https://education-access-api.onrender.com/predict");
    List<String> errors = [];

    if (_dropdownValues.values.any((value) => value == null)) {
      setState(() {
        _result = "Please select all dropdown options.";
        _resultColor = Colors.red;
      });
      return;
    }

    int? year;
    try {
      year = int.parse(_yearController.text);
      if (year < 2011 || year > 2030) {
        errors.add("Year must be between 2011 and 2030.");
      }
    } catch (e) {
      errors.add("Invalid Year: Enter a number between 2011 and 2030.");
    }

    if (errors.isNotEmpty) {
      setState(() {
        _result = errors.join("\n• ");
        _resultColor = Colors.red;
      });
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "sex": _dropdownValues["sex"],
          "age": _dropdownValues["age"],
          "hlth_pb": _dropdownValues["hlth_pb"],
          "isced97": _dropdownValues["isced97"],
          "geo": _dropdownValues["geo"],
          "time": year,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String accessLevel = data['access_level'];

        // Build result string with all information
        String resultText =
            "Predicted Access: ${data['predicted_access'].toStringAsFixed(1)} thousands\n";
        resultText += "Access Level: $accessLevel\n";
        resultText += "Description: ${data['access_description']}\n\n";

        // Add African-specific information if available
        if (data['african_recommendation'] != null) {
          resultText +=
              "📋 African Recommendation:\n${data['african_recommendation']}\n\n";
        }

        if (data['policy_suggestion'] != null) {
          resultText +=
              "🏛️ Policy Suggestion:\n${data['policy_suggestion']}\n\n";
        }

        // Add European baseline for African countries
        if (data['european_baseline'] != null) {
          resultText +=
              "🇪🇺 European Baseline: ${data['european_baseline'].toStringAsFixed(1)} thousands\n";
          resultText +=
              "📊 Adjustment Factor: ${(data['african_adjustment_factor'] * 100).toStringAsFixed(0)}%\n";
        }

        setState(() {
          _result = resultText;

          // Assign color based on access level
          switch (accessLevel) {
            case 'Very High':
              _resultColor = Colors.green[700]!;
              break;
            case 'High':
              _resultColor = Colors.green[400]!;
              break;
            case 'Moderate':
              _resultColor = Colors.yellow[700]!;
              break;
            case 'Low':
              _resultColor = Colors.orange[700]!;
              break;
            case 'Very Low':
              _resultColor = Colors.red[900]!;
              break;
            default:
              _resultColor = Colors.black87;
          }
        });
      } else {
        setState(() {
          _result = "API Error: ${response.body}";
          _resultColor = Colors.red;
        });
      }
    } catch (e) {
      setState(() {
        _result = "Network Error: $e";
        _resultColor = Colors.red;
      });
    }
  }

  Widget _buildDropdown(String key, String label) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black54),
          border: InputBorder.none,
        ),
        dropdownColor: Colors.white,
        style: TextStyle(color: Colors.black87),
        value: _dropdownValues[key],
        items:
            _dropdownOptions[key]!.map((option) {
              return DropdownMenuItem<String>(
                value: option["value"],
                child: Text(option["display"]),
              );
            }).toList(),
        onChanged: (value) {
          setState(() {
            _dropdownValues[key] = value;
          });
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black54),
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.black87),
        keyboardType: TextInputType.number,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Predict African Education Access"),
        backgroundColor: Colors.white,
        elevation: 2,
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Color(0xFF2E7D32)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Enter Education Access Parameters",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFE8F5E8),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFF2E7D32), width: 1),
              ),
              child: Text(
                "Select an African country to get predictions and recommendations, or a European country for reference data.",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2E7D32),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            _buildDropdown("sex", "Gender"),
            _buildDropdown("age", "Age Group"),
            _buildDropdown("hlth_pb", "Health Problem Type"),
            _buildDropdown("isced97", "Education Level"),
            _buildDropdown("geo", "Country"),
            _buildTextField(_yearController, "Year (2011-2030)"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _predict,
              child: Text("Predict Access", style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                _result,
                style: TextStyle(fontSize: 16, color: _resultColor),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
