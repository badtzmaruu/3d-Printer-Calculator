import 'package:flutter/material.dart';

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
  final TextEditingController costPerGramController = TextEditingController();
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
    // Parse input values
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

    // Calculate total cost
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
              Column(
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
                      ), // Closing the Checkbox widget
                    ], // Closing the children list
                  ), // Closing the Row widget


                      const SizedBox(width: 8), // Add some spacing between the checkbox and the label
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
              ),

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
              const Text('Post-Processing Costs:'),
              TextFormField(
                controller: postProcessingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Post Processing (Painting, Sanding, etc.)',
                ),
              ),
              const Text('Waste Costs:'),
              TextFormField(
                controller: wasteWeightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Weight of Waste Material (grams)',
                ),
              ),
              const Text('Failed Print Costs:'),
              TextFormField(
                controller: failedPrintPercentageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Percentage to Charge for Failed Print (%)',
                ),
              ),
              const Text('Tax/VAT/GST:'),
              TextFormField(
                controller: taxPercentageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Tax/VAT/GST Percentage (%)',
                ),
              ),

              const SizedBox(height: 20),

              Center(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
