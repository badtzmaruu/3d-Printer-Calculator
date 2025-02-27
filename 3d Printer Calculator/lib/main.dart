import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3D Printer Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class CalculatedCostType {
  String totalCostString = '';
  String materialCostSubtotalString = '';
  String printCostSubtotalString = '';
  String electricityCostSubtotalString = '';
  String labourCostSubtotalString = '';
  String equipmentCostSubtotalString = '';
  String wasteCostSubtotalString = '';
  String failedPrintCostSubtotalString = '';
  String processingCostSubtotalString = '';

  void updateCostStrings(Map<String, double> costs) {
    totalCostString = 'R ${costs['totalCost']?.toStringAsFixed(2) ?? '0.00'}';
    materialCostSubtotalString =
        'R ${costs['materialCost']?.toStringAsFixed(2) ?? '0.00'}';
    printCostSubtotalString =
        'R ${costs['printCost']?.toStringAsFixed(2) ?? '0.00'}';
    electricityCostSubtotalString =
        'R ${costs['electricityCost']?.toStringAsFixed(2) ?? '0.00'}';
    labourCostSubtotalString =
        'R ${costs['labourCost']?.toStringAsFixed(2) ?? '0.00'}';
    equipmentCostSubtotalString =
        'R ${costs['equipmentCost']?.toStringAsFixed(2) ?? '0.00'}';
    wasteCostSubtotalString =
        'R ${costs['wasteCost']?.toStringAsFixed(2) ?? '0.00'}';
    failedPrintCostSubtotalString =
        'R ${costs['failedPrintCost']?.toStringAsFixed(2) ?? '0.00'}';
    processingCostSubtotalString =
        'R ${costs['processingCost']?.toStringAsFixed(2) ?? '0.00'}';
  }
}

class MyCustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;

  MyCustomTextField({required this.controller, required this.labelText});

  @override
  _MyCustomTextFieldState createState() => _MyCustomTextFieldState();
}

class _MyCustomTextFieldState extends State<MyCustomTextField> {
  bool _isRequiredFilled = false;
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _isRequiredFilled = widget.controller.text.isNotEmpty;
    _listener = () {
      setState(() {
        _isRequiredFilled = widget.controller.text.isNotEmpty;
      });
    };
    widget.controller.addListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        LengthLimitingTextInputFormatter(8)
      ],
      decoration: InputDecoration(
        labelText: _isRequiredFilled
            ? '${widget.labelText}'
            : '${widget.labelText} *Required',
        labelStyle: TextStyle(
          color: _isRequiredFilled ? Colors.black : Colors.red,
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }
}


class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController filamentCostController = TextEditingController();
  final TextEditingController filamentWeightController =
      TextEditingController();
  final TextEditingController filamentUsedController = TextEditingController();
  final TextEditingController costPerGramController = TextEditingController();
  final TextEditingController printPricePerHourController =
      TextEditingController();
  final TextEditingController printTimeDaysController = TextEditingController();
  final TextEditingController printTimeHoursController =
      TextEditingController();
  final TextEditingController printTimeMinutesController =
      TextEditingController();
  final TextEditingController powerConsumptionController =
      TextEditingController();
  final TextEditingController costPerKWhController = TextEditingController();
  final TextEditingController labourTimeDaysController =
      TextEditingController();
  final TextEditingController labourTimeHoursController =
      TextEditingController();
  final TextEditingController labourTimeMinutesController =
      TextEditingController();
  final TextEditingController labourRateController = TextEditingController();
  final TextEditingController purchasePriceController = TextEditingController();
  final TextEditingController upgradesPriceController = TextEditingController();
  final TextEditingController annualRepairCostsController =
      TextEditingController();
  final TextEditingController lifespanYearsController = TextEditingController();
  final TextEditingController lifespanMonthsController =
      TextEditingController();
  final TextEditingController lifespanDaysController = TextEditingController();
  final TextEditingController postProcessingController =
      TextEditingController();
  final TextEditingController wasteWeightController = TextEditingController();
  final TextEditingController failedPrintPercentageController =
      TextEditingController();
  final TextEditingController taxPercentageController = TextEditingController();
  final TextEditingController materialProfitMarginController =
      TextEditingController();
  final TextEditingController electricityProfitMarginController =
      TextEditingController();

  CalculatedCostType costType = CalculatedCostType();

  bool addMaterialProfitMargin = false;
  bool addElectricityCost = false;
  bool countElectricity = false;
  bool addElectricityProfitMargin = false;

  bool _countEquipment = false;

  bool get countEquipment => _countEquipment;

  set countEquipment(bool value) {
    setState(() {
      _countEquipment = value;
    });
  }

  String dropDownCurrency = 'ZAR'; // Default
  Map<String, double> exchangeRates = {
    'ZAR': 1.0, // Default
    'USD': 19.08, // US Dollar
    'CAD': 13.90, // Canadian Dollar
    'GBP': 23.79, // British Pound
    'EUR': 20.39, // Euro
    'INR': 4.47, //Indian rubble
    'AUD': 0.082, // Australian Dollar
    'SGD': 0.073, // Singaporean Dollar
    'CHF': 0.049, // Swiss Francs
    'MYR': 0.253809, // Malaysian ringgits
    'JPY': 8.31, //Japanese Yen
  };

  Map<String, String> currencyLabels = {
    'ZAR': ' in Rands',
    'USD': ' in US Dollars',
    'CAD': ' in Canadian Dollars',
    'GBP': ' in British Pounds',
    'EUR': ' in Euros',
    'INR': ' in Indian Rupee',
    'AUD': ' in Australian Dollar',
    'SGD': ' in Singapore Dollar',
    'CHF': ' in Swiss Franc',
    'MYR': ' in Malaysian Ringgit',
    'JPY': ' in Japanese Yen',
  };

  Map<String, double> calculateTotalCost() {
    // Parse input values
    double filamentCost = double.parse(filamentCostController.text);
    double filamentWeight = double.parse(filamentWeightController.text);
    double filamentUsed = double.parse(filamentUsedController.text);
    double costPerGram = filamentCost / filamentWeight;
    double printPricePerHour = double.parse(printPricePerHourController.text);
    double powerConsumption = double.parse(powerConsumptionController.text);
    double costPerKWh = double.parse(costPerKWhController.text);
    double labourTimeDays = double.parse(labourTimeDaysController.text);
    double labourTimeHours = double.parse(labourTimeHoursController.text);
    double labourTimeMinutes = double.parse(labourTimeMinutesController.text);
    double labourRate = double.parse(labourRateController.text);
    double purchasePrice = double.parse(purchasePriceController.text);
    double upgradesPrice = double.parse(upgradesPriceController.text);
    double annualRepairCosts = double.parse(annualRepairCostsController.text);
    double postProcessing = double.parse(postProcessingController.text);
    double wasteWeight = double.parse(wasteWeightController.text);
    double failedPrintPercentage =
        double.parse(failedPrintPercentageController.text);
    double taxPercentage = double.parse(taxPercentageController.text);
    double materialProfitMargin =
        double.parse(materialProfitMarginController.text);
    double electricityProfitMargin =
        double.parse(electricityProfitMarginController.text);
    double printTimeDays = double.parse(printTimeDaysController.text);
    double printTimeHours = double.parse(printTimeHoursController.text);
    double printTimeMinutes = double.parse(printTimeMinutesController.text);
    double lifespanYears = double.parse(lifespanYearsController.text);
    double lifespanMonths = double.parse(lifespanMonthsController.text);
    double lifespanDays = double.parse(lifespanDaysController.text);

    // Calculate total cost
    double materialCost = filamentUsed * costPerGram;
    if (addMaterialProfitMargin && materialCost > 0) {
      materialCost = (filamentUsed * (filamentCost / filamentWeight)) +
          ((filamentUsed * (filamentCost / filamentWeight)) *
              materialProfitMargin /
              100);
    }

    double printTimeInHours =
        (printTimeDays * 24) + (printTimeHours) + (printTimeMinutes / 60);
    double printCost = printTimeInHours * printPricePerHour;

    double electricityCost = 0.0;
    if (addElectricityProfitMargin && electricityCost > 0) {
      electricityCost =
          ((powerConsumption / 1000) * printTimeInHours * costPerKWh) +
              (((powerConsumption / 1000) * printTimeInHours * costPerKWh) *
                  electricityProfitMargin /
                  100);
    }

    double labourTimeInHours =
        (labourTimeDays * 24) + (labourTimeHours) + (labourTimeMinutes / 60);
    double labourCost = labourTimeInHours * labourRate;

    double printerLifespanInYears =
        (lifespanYears) + (lifespanMonths / 12) + (lifespanDays / 365);
    double equipmentCost = (purchasePrice + upgradesPrice + annualRepairCosts) /
        (printerLifespanInYears * 24 * 365);
    double wasteCost = (materialCost / filamentWeight) * wasteWeight;

    double failedPrintCost = (failedPrintPercentage /
            100 *
            (materialCost + printCost + electricityCost)) +
        (materialCost + printCost + electricityCost);
    double processingCost = postProcessing;
    double taxCost = materialCost +
        printCost +
        electricityCost +
        labourCost +
        equipmentCost +
        processingCost +
        wasteCost +
        failedPrintCost;

    double exchangeRate = exchangeRates[dropDownCurrency] ?? 1.0;
    double totalCost = 0;
    totalCost = materialCost +
        printCost +
        electricityCost +
        labourCost +
        equipmentCost +
        processingCost +
        wasteCost +
        failedPrintCost +
        (taxCost + (taxCost * taxPercentage / 100));

    return {
      'totalCost': totalCost * exchangeRate,
      'materialCost': materialCost,
      'printCost': printCost,
      'electricityCost': electricityCost,
      'labourCost': labourCost,
      'equipmentCost': equipmentCost,
      'wasteCost': wasteCost,
      'failedPrintCost': failedPrintCost,
      'processingCost': processingCost,
    };
  }

  void updateCostStrings() {
    Map<String, double> costs = calculateTotalCost();
    costType.updateCostStrings(costs);
  }

  // Define the generateInvoice function here
  Future<void> generateInvoice() async {
    updateCostStrings();

    final Uint8List fontData =
        File('fonts/Roboto-Regular.ttf').readAsBytesSync();
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    final pw.Document pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: <pw.Widget>[
            pw.Header(
              level: 0,
              child: pw.Text('3D Printer Calculator Invoice',
                  style: pw.TextStyle(fontSize: 24, font: ttf)),
            ),
            pw.Text('Total Cost: ${costType.totalCostString}'),
            pw.Text(
                'Material Cost Subtotal: ${costType.materialCostSubtotalString}'),
            pw.Text('Print Cost Subtotal: ${costType.printCostSubtotalString}'),
            pw.Text(
                'Electricity Cost Subtotal: ${costType.electricityCostSubtotalString}'),
            pw.Text(
                'Labour Cost Subtotal: ${costType.labourCostSubtotalString}'),
            pw.Text(
                'Equipment Cost Subtotal: ${costType.equipmentCostSubtotalString}'),
            pw.Text('Waste Cost Subtotal: ${costType.wasteCostSubtotalString}'),
            pw.Text(
                'Failed Print Cost Subtotal: ${costType.failedPrintCostSubtotalString}'),
            pw.Text(
                'Processing Cost Subtotal: ${costType.processingCostSubtotalString}'),
          ],
        ),
      ),
    );

    // Save the PDF file
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/invoice.pdf';
    final File file = File(path);
    await file.writeAsBytes(await pdf.save());
    Printing.sharePdf(bytes: await pdf.save(), filename: 'invoice.pdf');
  }

  // Define the generateCSV function
  Future<void> generateCSV() async {
    updateCostStrings();

    // Create a CSV string
    String csvString = 'Total Cost,${costType.totalCostString}\n';
    csvString +=
        'Material Cost Subtotal,${costType.materialCostSubtotalString}\n';
    csvString += 'Print Cost Subtotal,${costType.printCostSubtotalString}\n';
    csvString +=
        'Electricity Cost Subtotal,${costType.electricityCostSubtotalString}\n';
    csvString += 'Labour Cost Subtotal,${costType.labourCostSubtotalString}\n';
    csvString +=
        'Equipment Cost Subtotal,${costType.equipmentCostSubtotalString}\n';
    csvString += 'Waste Cost Subtotal,${costType.wasteCostSubtotalString}\n';
    csvString +=
        'Failed Print Cost Subtotal,${costType.failedPrintCostSubtotalString}\n';
    csvString +=
        'Processing Cost Subtotal,${costType.processingCostSubtotalString}\n';

    // Save the CSV file
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/calculated_values.csv';
    final File file = File(path);
    await file.writeAsString(csvString);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CSV file saved successfully!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('3D Printer Calculator'),
        actions: [
          //Adding the drop down button to the ribbon
          DropdownButton(
            value: dropDownCurrency,
            onChanged: (String? newValue) {
              setState(() {
                dropDownCurrency = newValue!;
              });
            },
            items: exchangeRates.keys
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Material Costs:'),
              MyCustomTextField(
                controller: filamentCostController,
                labelText:
                    'Filament Cost per Reel${currencyLabels[dropDownCurrency]}',
              ),
              MyCustomTextField(
                controller: filamentWeightController,
                labelText: 'Filament Weight (grams)',
              ),
              MyCustomTextField(
                controller: filamentUsedController,
                labelText: 'Filament Used (grams)',
              ),
              Row(
                children: [
                  const Text('Add Material Profit Margin?'),
                  Checkbox(
                    value: addMaterialProfitMargin,
                    onChanged: (value) {
                      setState(() {
                        addMaterialProfitMargin = value!;
                      });
                    },
                  ),
                ],
              ),
              if (addMaterialProfitMargin) ...[
                MyCustomTextField(
                  controller: materialProfitMarginController,
                  labelText: 'Material Profit Margin (%)',
                ),
              ],
              const Text('Print Costs:'),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: MyCustomTextField(
                      controller: printTimeDaysController,
                      labelText: 'Print Time Days',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: MyCustomTextField(
                      controller: printTimeHoursController,
                      labelText: 'Print Time Hours',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: MyCustomTextField(
                      controller: printTimeMinutesController,
                      labelText: 'Print Time Minutes',
                    ),
                  ),
                ],
              ),
              MyCustomTextField(
                controller: printPricePerHourController,
                labelText:
                    'Print Price per Hour${currencyLabels[dropDownCurrency]}',
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Electricity Costs:'),
                  Row(
                    children: [
                      const Text('Count Electricity?'),
                      Checkbox(
                        value: countElectricity,
                        onChanged: (value) {
                          setState(() {
                            countElectricity = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  if (countElectricity) ...[
                    MyCustomTextField(
                      controller: powerConsumptionController,
                      labelText: 'Wattage of Printer (W)',
                    ),
                    MyCustomTextField(
                      controller: costPerKWhController,
                      labelText:
                          'Cost per kWh${currencyLabels[dropDownCurrency]}',
                    ),
                    Row(
                      children: [
                        const Text('Add Electricity Profit Margin?'),
                        Checkbox(
                          value: addElectricityProfitMargin,
                          onChanged: (value) {
                            setState(() {
                              addElectricityProfitMargin = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    if (addElectricityProfitMargin) ...[
                      MyCustomTextField(
                        controller: electricityProfitMarginController,
                        labelText: 'Electricity Profit Percentage (%)',
                      ),
                    ],
                  ],
                ],
              ),
              const Text('Labour Costs'),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: MyCustomTextField(
                      controller: labourTimeDaysController,
                      labelText: 'Labour Time Days',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: MyCustomTextField(
                      controller: labourTimeHoursController,
                      labelText: 'Labour Time Hours',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: MyCustomTextField(
                      controller: labourTimeMinutesController,
                      labelText: 'Labour Time Minutes',
                    ),
                  ),
                ],
              ),
              MyCustomTextField(
                controller: labourRateController,
                labelText:
                    'Labour Rate per Hour${currencyLabels[dropDownCurrency]}',
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Equipment Costs${currencyLabels[dropDownCurrency]}'),
                  Row(
                    children: [
                      const Text('Count Equipment?'),
                      Checkbox(
                        value: countEquipment,
                        onChanged: (value) {
                          setState(() {
                            countEquipment = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  if (countEquipment) ...[
                    MyCustomTextField(
                      controller: purchasePriceController,
                      labelText:
                          'Printer Purchase Price${currencyLabels[dropDownCurrency]}',
                    ),
                    MyCustomTextField(
                      controller: upgradesPriceController,
                      labelText:
                          'Printer Upgrades Price${currencyLabels[dropDownCurrency]}',
                    ),
                    MyCustomTextField(
                      controller: annualRepairCostsController,
                      labelText:
                          'Annual Repair Costs${currencyLabels[dropDownCurrency]}',
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: MyCustomTextField(
                            controller: lifespanYearsController,
                            labelText: 'Printer Lifespan Years',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: MyCustomTextField(
                            controller: lifespanMonthsController,
                            labelText: 'Printer Lifespan Months',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: MyCustomTextField(
                            controller: lifespanDaysController,
                            labelText: 'Printer Lifespan Days',
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              const Text('Post-Processing Costs:'),
              MyCustomTextField(
                controller: postProcessingController,
                labelText:
                    'Post Processing (Painting, Sanding, etc.)${currencyLabels[dropDownCurrency]}',
              ),
              Text('Waste Costs${currencyLabels[dropDownCurrency]}'),
              MyCustomTextField(
                controller: wasteWeightController,
                labelText: 'Weight of Waste Material (grams)',
              ),
              Text('Failed Print Costs,${currencyLabels[dropDownCurrency]}'),
              MyCustomTextField(
                controller: failedPrintPercentageController,
                labelText: 'Percentage to Charge for Failed Print (%)',
              ),
              const Text('Tax/VAT/GST:'),
              MyCustomTextField(
                controller: taxPercentageController,
                labelText: 'Tax/VAT/GST Percentage (%)',
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Check the checkbox fields
                    if ((addMaterialProfitMargin &&
                            materialProfitMarginController.text.isEmpty) ||
                        (countElectricity &&
                            (powerConsumptionController.text.isEmpty ||
                                costPerKWhController.text.isEmpty)) ||
                        (countEquipment &&
                            (purchasePriceController.text.isEmpty ||
                                upgradesPriceController.text.isEmpty ||
                                annualRepairCostsController.text.isEmpty ||
                                lifespanYearsController.text.isEmpty ||
                                lifespanMonthsController.text.isEmpty ||
                                lifespanDaysController.text.isEmpty)) ||
                        (addElectricityProfitMargin &&
                            electricityProfitMarginController.text.isEmpty)) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Warning'),
                            content: const Text(
                                'Please either un-tick the box or fill in the required values.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }
                    // Check the normal fields
                    if (filamentCostController.text.isEmpty ||
                        filamentWeightController.text.isEmpty ||
                        filamentUsedController.text.isEmpty ||
                        printTimeHoursController.text.isEmpty ||
                        printTimeDaysController.text.isEmpty ||
                        printTimeMinutesController.text.isEmpty ||
                        printPricePerHourController.text.isEmpty ||
                        labourTimeHoursController.text.isEmpty ||
                        labourTimeDaysController.text.isEmpty ||
                        labourTimeMinutesController.text.isEmpty ||
                        labourRateController.text.isEmpty ||
                        postProcessingController.text.isEmpty ||
                        wasteWeightController.text.isEmpty ||
                        failedPrintPercentageController.text.isEmpty ||
                        taxPercentageController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Warning'),
                            content: const Text(
                                'Please fill in all required field values.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }
                    double filamentCost =
                        double.tryParse(filamentCostController.text) ?? 0;
                    double filamentWeight =
                        double.tryParse(filamentWeightController.text) ?? 0;
                    double filamentUsed =
                        double.tryParse(filamentUsedController.text) ?? 0;
                    double printTimeHours =
                        double.tryParse(printTimeHoursController.text) ?? 0;
                    double printTimeDays =
                        double.tryParse(printTimeDaysController.text) ?? 0;
                    double printTimeMinutes =
                        double.tryParse(printTimeMinutesController.text) ?? 0;
                    double printPricePerHour =
                        double.tryParse(printPricePerHourController.text) ?? 0;
                    double powerConsumption =
                        double.tryParse(powerConsumptionController.text) ?? 0;
                    double costPerKWh =
                        double.tryParse(costPerKWhController.text) ?? 0;
                    double labourTimeHours =
                        double.tryParse(labourTimeHoursController.text) ?? 0;
                    double labourTimeDays =
                        double.tryParse(labourTimeDaysController.text) ?? 0;
                    double labourTimeMinutes =
                        double.tryParse(labourTimeMinutesController.text) ?? 0;
                    double labourRate =
                        double.tryParse(labourRateController.text) ?? 0;
                    double purchasePrice =
                        double.tryParse(purchasePriceController.text) ?? 0;
                    double upgradesPrice =
                        double.tryParse(upgradesPriceController.text) ?? 0;
                    double annualRepairCosts =
                        double.tryParse(annualRepairCostsController.text) ?? 0;
                    double postProcessing =
                        double.tryParse(postProcessingController.text) ?? 0;
                    double wasteWeight =
                        double.tryParse(wasteWeightController.text) ?? 0;
                    double failedPrintPercentage =
                        double.tryParse(failedPrintPercentageController.text) ??
                            0;
                    double taxPercentage =
                        double.tryParse(taxPercentageController.text) ?? 0;
                    double materialProfitMargin = addMaterialProfitMargin
                        ? (double.tryParse(
                                materialProfitMarginController.text) ??
                            0)
                        : 0;
                    double electricityProfitMargin = addElectricityProfitMargin
                        ? (double.tryParse(
                                electricityProfitMarginController.text) ??
                            0)
                        : 0;
                    double lifespanYears =
                        double.tryParse(lifespanYearsController.text) ?? 0;
                    double lifespanMonths =
                        double.tryParse(lifespanMonthsController.text) ?? 0;
                    double lifespanDays =
                        double.tryParse(lifespanDaysController.text) ?? 0;

                    double materialCostSubtotal =
                        (filamentUsed * (filamentCost / filamentWeight)) +
                            ((filamentUsed * (filamentCost / filamentWeight)) *
                                materialProfitMargin /
                                100);
                    String materialCostSubtotalString =
                        materialCostSubtotal.toStringAsFixed(3);

                    double printTime = ((printTimeDays * 24) +
                        printTimeHours +
                        (printTimeMinutes / 60));
                    double printCostSubtotal = printTime * printPricePerHour;
                    String printCostSubtotalString =
                        printCostSubtotal.toStringAsFixed(3);

                    double electricityCostSubtotal =
                        ((powerConsumption / 1000) * printTime * costPerKWh) +
                            (((powerConsumption / 1000) *
                                    printTime *
                                    costPerKWh) *
                                electricityProfitMargin /
                                100);
                    String electricityCostSubtotalString =
                        electricityCostSubtotal.toStringAsFixed(3);

                    double labourTime = (labourTimeDays * 24) +
                        (labourTimeHours) +
                        (labourTimeMinutes / 60);
                    double labourCostSubtotal = labourTime * labourRate;
                    String labourCostSubtotalString =
                        labourCostSubtotal.toStringAsFixed(3);

                    double printerLifespan = (lifespanYears) +
                        (lifespanMonths / 12) +
                        (lifespanDays / 365);
                    double equipmentCostSubtotal =
                        (purchasePrice + upgradesPrice + annualRepairCosts) /
                            (printerLifespan * 24 * 365);
                    String equipmentCostSubtotalString =
                        equipmentCostSubtotal.toStringAsFixed(3);

                    double wasteCostSubtotal =
                        (materialCostSubtotal / filamentUsed) * wasteWeight;
                    String wasteCostSubtotalString =
                        wasteCostSubtotal.toStringAsFixed(3);

                    double failedPrintCostSubtotal = (failedPrintPercentage /
                            100 *
                            (materialCostSubtotal +
                                printCostSubtotal +
                                electricityCostSubtotal)) +
                        (materialCostSubtotal +
                            printCostSubtotal +
                            electricityCostSubtotal);
                    String failedPrintCostSubtotalString =
                        failedPrintCostSubtotal.toStringAsFixed(3);

                    double processingCostSubtotal = postProcessing;
                    String processingCostSubtotalString =
                        processingCostSubtotal.toStringAsFixed(3);

                    double totalCost = materialCostSubtotal +
                        printCostSubtotal +
                        electricityCostSubtotal +
                        labourCostSubtotal +
                        equipmentCostSubtotal +
                        wasteCostSubtotal +
                        failedPrintCostSubtotal +
                        processingCostSubtotal;
                    totalCost = totalCost + (totalCost * (taxPercentage / 100));
                    String totalCostString = totalCost.toStringAsFixed(3);

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Total Cost and Subtotals'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text('Total Cost: $totalCostString'),
                              Text('Material Cost Subtotal'
                                  ': $materialCostSubtotalString'),
                              Text(
                                  'Print Cost Subtotal: $printCostSubtotalString'),
                              Text(
                                  'Electricity Cost Subtotal: $electricityCostSubtotalString'),
                              Text(
                                  'Labour Cost Subtotal: $labourCostSubtotalString'),
                              Text(
                                  'Equipment Cost Subtotal: $equipmentCostSubtotalString'),
                              Text(
                                  'Waste Cost Subtotal: $wasteCostSubtotalString'),
                              Text(
                                  'Failed Print Cost Subtotal: $failedPrintCostSubtotalString'),
                              Text(
                                  'Processing Cost Subtotal: $processingCostSubtotalString'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                            TextButton(
                              onPressed: generateInvoice,
                              child: const Text('Generate Invoice'),
                            ),
                            TextButton(
                                onPressed: generateCSV,
                                child: const Text('Generate CSV'))
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Calculate'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
