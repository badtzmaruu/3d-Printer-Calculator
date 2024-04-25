import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:open_file/open_file.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController filamentCostController = TextEditingController();
  final TextEditingController filamentWeightController = TextEditingController();
  final TextEditingController filamentUsedController = TextEditingController();
  final TextEditingController printTimeController = TextEditingController();
  final TextEditingController printPricePerHourController = TextEditingController();
  final TextEditingController powerConsumptionController = TextEditingController();
  final TextEditingController costPerKWhController = TextEditingController();
  final TextEditingController labourTimeController = TextEditingController();
  final TextEditingController labourRateController = TextEditingController();
  final TextEditingController purchasePriceController = TextEditingController();
  final TextEditingController upgradesPriceController = TextEditingController();
  final TextEditingController annualRepairCostsController = TextEditingController();
  final TextEditingController printerLifespanController = TextEditingController();
  final TextEditingController postProcessingController = TextEditingController();
  final TextEditingController wasteWeightController = TextEditingController();
  final TextEditingController failedPrintPercentageController = TextEditingController();
  final TextEditingController taxPercentageController = TextEditingController();
  final TextEditingController materialProfitMarginController = TextEditingController();
  final TextEditingController electricityPercentageController = TextEditingController();

  bool addMaterialProfitMargin = false;
  bool addElectricityCost = false;

  double calculateTotalCost() {
    double filamentCost = double.parse(filamentCostController.text);
    double filamentWeight = double.parse(filamentWeightController.text);
    double filamentUsed = double.parse(filamentUsedController.text);
    double costPerGram = filamentCost / filamentWeight;
    double printTime = double.parse(printTimeController.text);
    double printPricePerHour = double.parse(printPricePerHourController.text);
    double powerConsumption = double.parse(powerConsumptionController.text);
    double costPerKWh = double.parse(costPerKWhController.text);
    double labourTime = double.parse(labourTimeController.text);
    double labourRate = double.parse(labourRateController.text);
    double purchasePrice = double.parse(purchasePriceController.text);
    double upgradesPrice = double.parse(upgradesPriceController.text);
    double annualRepairCosts = double.parse(annualRepairCostsController.text);
    double printerLifespan = double.parse(printerLifespanController.text);
    double postProcessing = double.parse(postProcessingController.text);
    double wasteWeight = double.parse(wasteWeightController.text);
    double failedPrintPercentage = double.parse(failedPrintPercentageController.text);
    double taxPercentage = double.parse(taxPercentageController.text);
    double materialProfitMargin = double.parse(materialProfitMarginController.text);

    double materialCost = filamentUsed * costPerGram;
    if (addMaterialProfitMargin && materialCost > 0) {
      materialCost *= (1 + (materialProfitMargin / 100));
    }
    double printCost = printTime * printPricePerHour;
    double electricityCost = 0.0;
    if (addElectricityCost && electricityCost > 0) {
      double electricityPercentage = double.parse(electricityPercentageController.text);
      electricityCost = powerConsumption * printTime * costPerKWh * (electricityPercentage / 100);
    }
    double labourCost = labourTime * labourRate;
    double equipmentCost = (purchasePrice + upgradesPrice + annualRepairCosts) / (printerLifespan * 24 * 365);
    double wasteCost = (materialCost / filamentWeight) * wasteWeight;
    double failedPrintCost = (failedPrintPercentage * (materialCost + printCost + electricityCost)) + (materialCost + printCost + electricityCost);
    double taxCost = (materialCost + printCost + electricityCost) * (taxPercentage / 100);
    double processingCost = postProcessing;

    return materialCost + printCost + electricityCost + labourCost + equipmentCost + processingCost + wasteCost + failedPrintCost + taxCost;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('3D Printer Calculator'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildMaterialCosts(),
              buildPrintCosts(),
              buildElectricityCosts(),
              buildLabourAndEquipmentCosts(),
              buildPostProcessingCosts(),
              buildWasteAndFailedPrintCosts(),
              buildTaxPercentageField(),
              SizedBox(height: 20),
              buildCalculateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMaterialCosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Material Costs:'),
        TextFormField(
          controller: filamentCostController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Filament Cost per Reel',
          ),
        ),
        TextFormField(
          controller: filamentWeightController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Filament Weight (grams)',
          ),
        ),
        TextFormField(
          controller: filamentUsedController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Filament Used (grams)',
          ),
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
          TextFormField(
            controller: materialProfitMarginController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Material Profit Margin (%)',
            ),
          ),
        ],
      ],
    );
  }

  Widget buildPrintCosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Print Costs:'),
        TextFormField(
          controller: printTimeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Print Time (hours)',
          ),
        ),
        TextFormField(
          controller: printPricePerHourController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Print Price per Hour',
          ),
        ),
      ],
    );
  }

  Widget buildElectricityCosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Electricity Costs:'),
        TextFormField(
          controller: powerConsumptionController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Power Consumption of Printer (kW)',
          ),
        ),
        TextFormField(
          controller: costPerKWhController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Cost per kWh',
          ),
        ),
        Row(
          children: [
            const Text('Add Electricity Profit Margin?'),
            Checkbox(
              value: addElectricityCost,
              onChanged: (value) {
                setState(() {
                  addElectricityCost = value!;
                });
              },
            ),
          ],
        ),
        if (addElectricityCost) ...[
          TextFormField(
            controller: electricityPercentageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Electricity Profit Percentage (%)',
            ),
          ),
        ],
      ],
    );
  }

  Widget buildLabourAndEquipmentCosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Labour and Equipment Costs:'),
        TextFormField(
          controller: labourTimeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Labour Time',
          ),
        ),
        TextFormField(
          controller: labourRateController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Labour Rate (per hour)',
          ),
        ),
        const Text('Equipment Costs:'),
        TextFormField(
          controller: purchasePriceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Printer Purchase Price',
          ),
        ),
        TextFormField(
          controller: upgradesPriceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Printer Upgrades Price',
          ),
        ),
        TextFormField(
          controller: annualRepairCostsController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Annual Repair Costs',
          ),
        ),
        TextFormField(
          controller: printerLifespanController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Printer Lifespan (years)',
          ),
        ),
      ],
    );
  }

  Widget buildPostProcessingCosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Post-Processing Costs:'),
        TextFormField(
          controller: postProcessingController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Post Processing (Painting, Sanding, etc.)',
          ),
        ),
      ],
    );
  }

  Widget buildWasteAndFailedPrintCosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Waste and Failed Print Costs:'),
        TextFormField(
          controller: wasteWeightController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Weight of Waste Material (grams)',
          ),
        ),
        TextFormField(
          controller: failedPrintPercentageController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Percentage to Charge for Failed Print (%)',
          ),
        ),
      ],
    );
  }

  Widget buildTaxPercentageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tax/VAT/GST:'),
        TextFormField(
          controller: taxPercentageController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Tax/VAT/GST Percentage (%)',
          ),
        ),
      ],
    );
  }

  Widget buildCalculateButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          double totalCost = calculateTotalCost();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Total Cost'),
                content: Text('Total Cost: $totalCost'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      generateInvoice(context, totalCost); // Generate PDF invoice
                    },
                    child: const Text('Generate Invoice'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
              );
            },
          );
        },
        child: const Text('Calculate'),
      ),
    );
  }

  void generateInvoice(BuildContext context, double totalCost) {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Invoice', style: const pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Text('Total Cost: \$${totalCost.toStringAsFixed(2)}'),
              pw.SizedBox(height: 20),
              pw.Text('Material Costs: \$${(double.parse(filamentCostController.text) / double.parse(filamentWeightController.text) * double.parse(filamentUsedController.text)).toStringAsFixed(2)}'),
              pw.Text('Print Costs: \$${(double.parse(printTimeController.text) * double.parse(printPricePerHourController.text)).toStringAsFixed(2)}'),
              pw.Text('Electricity Costs: \$${(double.parse(powerConsumptionController.text) * double.parse(printTimeController.text) * double.parse(costPerKWhController.text) * (addElectricityCost ? double.parse(electricityPercentageController.text) / 100 : 1)).toStringAsFixed(2)}'),
              pw.Text('Labour and Equipment Costs: \$${(double.parse(labourTimeController.text) * double.parse(labourRateController.text) + (double.parse(purchasePriceController.text) + double.parse(upgradesPriceController.text) + double.parse(annualRepairCostsController.text)) / (double.parse(printerLifespanController.text) * 24 * 365)).toStringAsFixed(2)}'),
              pw.Text('Post-Processing Costs: \$${double.parse(postProcessingController.text).toStringAsFixed(2)}'),
              pw.Text('Waste and Failed Print Costs: \$${((double.parse(failedPrintPercentageController.text) * (double.parse(filamentCostController.text) / double.parse(filamentWeightController.text) * double.parse(filamentUsedController.text) + double.parse(printTimeController.text) * double.parse(printPricePerHourController.text) + double.parse(powerConsumptionController.text) * double.parse(printTimeController.text) * double.parse(costPerKWhController.text) * (addElectricityCost ? double.parse(electricityPercentageController.text) / 100 : 1))) + (double.parse(filamentCostController.text) / double.parse(filamentWeightController.text) * double.parse(wasteWeightController.text))).toStringAsFixed(2)}'),
              pw.Text('Tax/VAT/GST: \$${((double.parse(filamentCostController.text) / double.parse(filamentWeightController.text) * double.parse(filamentUsedController.text) + double.parse(printTimeController.text) * double.parse(printPricePerHourController.text) + double.parse(powerConsumptionController.text) * double.parse(printTimeController.text) * double.parse(costPerKWhController.text) * (addElectricityCost ? double.parse(electricityPercentageController.text) / 100 : 1)) * (double.parse(taxPercentageController.text) / 100)).toStringAsFixed(2)}'),
            ],
          );
        },
      ),
    );

    savePDF(pdf, context);
  }
  void savePDF(pw.Document pdf, BuildContext context) async {
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/invoice.pdf");
    await file.writeAsBytes(await pdf.save());

    // Open the PDF document in a viewer.
    OpenFile.open(file.path);
  }


  Future<Directory> getTemporaryDirectory() async {
    return Directory.systemTemp;
  }
}
