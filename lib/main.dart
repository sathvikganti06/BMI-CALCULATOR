import 'package:flutter/material.dart';

void main() {
  runApp(const BMIApp());
}

class BMIApp extends StatelessWidget {
  const BMIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Calculator',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const BMIHomePage(),
    );
  }
}

class BMIHomePage extends StatefulWidget {
  const BMIHomePage({super.key});

  @override
  State<BMIHomePage> createState() => _BMIHomePageState();
}

class _BMIHomePageState extends State<BMIHomePage> {
  final heightController = TextEditingController();
  final heightFeetController = TextEditingController();
  final heightInchesController = TextEditingController();
  final weightController = TextEditingController();

  String heightUnit = 'CM';
  String weightUnit = 'KG';

  double? bmi;
  String category = '';

  // =========================
  // BMI CALCULATION
  // =========================

  void calculateBMI() {
    double? heightInMeters;
    double? weightKg;

    // HEIGHT
    if (heightUnit == 'CM') {
      final heightCm = double.tryParse(heightController.text);

      if (heightCm == null || heightCm <= 0) {
        showError('Please enter a valid height');
        return;
      }

      heightInMeters = heightCm / 100;
    } else {
      final feet = double.tryParse(heightFeetController.text);
      final inches = double.tryParse(heightInchesController.text);

      if (feet == null || inches == null || feet < 0 || inches < 0) {
        showError('Please enter a valid height');
        return;
      }

      final totalInches = (feet * 12) + inches;

      heightInMeters = totalInches * 0.0254;
    }

    // WEIGHT
    final weight = double.tryParse(weightController.text);

    if (weight == null || weight <= 0) {
      showError('Please enter a valid weight');
      return;
    }

    if (weightUnit == 'KG') {
      weightKg = weight;
    } else {
      // Pounds → kilograms
      weightKg = weight * 0.45359237;
    }

    // BMI
    final calculatedBMI =
        weightKg / (heightInMeters * heightInMeters);

    String newCategory;

    if (calculatedBMI < 18.5) {
      newCategory = 'Underweight';
    } else if (calculatedBMI < 25) {
      newCategory = 'Normal';
    } else if (calculatedBMI < 30) {
      newCategory = 'Overweight';
    } else {
      newCategory = 'Obesity';
    }

    setState(() {
      bmi = calculatedBMI;
      category = newCategory;
    });
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // =========================
  // CLEAR
  // =========================

  void clearData() {
    heightController.clear();
    heightFeetController.clear();
    heightInchesController.clear();
    weightController.clear();

    setState(() {
      bmi = null;
      category = '';
    });
  }

  @override
  void dispose() {
    heightController.dispose();
    heightFeetController.dispose();
    heightInchesController.dispose();
    weightController.dispose();

    super.dispose();
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              // HEADER
              const Text(
                'BMI Calculator',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172033),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Track your body health',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF7A8499),
                ),
              ),

              const SizedBox(height: 28),

              // HEIGHT
              buildHeightCard(),

              const SizedBox(height: 16),

              // WEIGHT
              buildWeightCard(),

              const SizedBox(height: 22),

              // CALCULATE
              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton(
                  onPressed: calculateBMI,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  child: const Text(
                    'Calculate BMI',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // CLEAR
              SizedBox(
                width: double.infinity,
                height: 50,

                child: OutlinedButton(
                  onPressed: clearData,

                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  child: const Text('Clear'),
                ),
              ),

              const SizedBox(height: 25),

              // RESULT
              buildResultCard(),

              const SizedBox(height: 25),

              // INFO
              buildInfoCard(),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // HEIGHT CARD
  // =========================

  Widget buildHeightCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        border: Border.all(
          color: const Color(0xFFE6EAF0),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Row(
            children: [
              const Icon(
                Icons.height_rounded,
                color: Color(0xFF2563EB),
              ),

              const SizedBox(width: 10),

              const Text(
                'Height',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              buildUnitSelector(
                value: heightUnit,
                items: const ['CM', 'FT'],
                onChanged: (value) {
                  setState(() {
                    heightUnit = value!;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 18),

          if (heightUnit == 'CM')

            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,

              decoration: const InputDecoration(
                hintText: '175',
                suffixText: 'cm',
                border: OutlineInputBorder(),
              ),
            )

          else

            Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: heightFeetController,
                    keyboardType: TextInputType.number,

                    decoration: const InputDecoration(
                      hintText: '5',
                      suffixText: 'ft',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: TextField(
                    controller: heightInchesController,
                    keyboardType: TextInputType.number,

                    decoration: const InputDecoration(
                      hintText: '9',
                      suffixText: 'in',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // =========================
  // WEIGHT CARD
  // =========================

  Widget buildWeightCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        border: Border.all(
          color: const Color(0xFFE6EAF0),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Row(
            children: [
              const Icon(
                Icons.monitor_weight_outlined,
                color: Color(0xFF2563EB),
              ),

              const SizedBox(width: 10),

              const Text(
                'Weight',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              buildUnitSelector(
                value: weightUnit,
                items: const ['KG', 'LBS'],
                onChanged: (value) {
                  setState(() {
                    weightUnit = value!;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 18),

          TextField(
            controller: weightController,
            keyboardType: TextInputType.number,

            decoration: InputDecoration(
              hintText: weightUnit == 'KG'
                  ? '70'
                  : '154',

              suffixText: weightUnit == 'KG'
                  ? 'kg'
                  : 'lbs',

              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // UNIT SELECTOR
  // =========================

  Widget buildUnitSelector({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),

      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),

      child: DropdownButton<String>(
        value: value,

        underline: const SizedBox(),

        icon: const Icon(
          Icons.keyboard_arrow_down,
          size: 20,
        ),

        items: items.map(
          (item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          },
        ).toList(),

        onChanged: onChanged,
      ),
    );
  }

  // =========================
  // RESULT CARD
  // =========================

  Widget buildResultCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(25),

      decoration: BoxDecoration(
        color: const Color(0xFF172033),
        borderRadius: BorderRadius.circular(28),
      ),

      child: Column(
        children: [

          const Text(
            'YOUR BMI',
            style: TextStyle(
              color: Color(0xFF9AA5BA),
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            bmi == null
                ? '--'
                : bmi!.toStringAsFixed(1),

            style: const TextStyle(
              color: Colors.white,
              fontSize: 58,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            bmi == null
                ? 'Enter your details'
                : category,

            style: const TextStyle(
              color: Color(0xFF60A5FA),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 25),

          Row(
            children: [
              buildScaleItem('Under', '<18.5'),
              buildScaleItem('Normal', '18.5–24.9'),
              buildScaleItem('Over', '25–29.9'),
              buildScaleItem('Obese', '30+'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildScaleItem(
    String title,
    String value,
  ) {
    return Expanded(
      child: Column(
        children: [

          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFCBD2DF),
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // INFO CARD
  // =========================

  Widget buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        border: Border.all(
          color: const Color(0xFFE6EAF0),
        ),
      ),

      child: Row(
        children: [

          Container(
            width: 48,
            height: 48,

            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(14),
            ),

            child: const Icon(
              Icons.info_outline_rounded,
              color: Color(0xFF2563EB),
            ),
          ),

          const SizedBox(width: 15),

          const Expanded(
            child: Text(
              'BMI is a general screening measure. '
              'It does not directly measure body fat.',
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Color(0xFF697386),
              ),
            ),
          ),
        ],
      ),
    );
  }
}