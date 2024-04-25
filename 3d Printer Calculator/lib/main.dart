import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


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

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController filamentCostController = TextEditingController();
  final TextEditingController filamentWeightController = TextEditingController();
  final TextEditingController filamentUsedController = TextEditingController();
  final TextEditingController costPerGramController = TextEditingController();
  final TextEditingController printPricePerHourController = TextEditingController();
  final TextEditingController printTimeDaysController = TextEditingController();
  final TextEditingController printTimeHoursController = TextEditingController();
  final TextEditingController printTimeMinutesController = TextEditingController();
  final TextEditingController powerConsumptionController = TextEditingController();
  final TextEditingController costPerKWhController = TextEditingController();
  final TextEditingController labourTimeDaysController = TextEditingController();
  final TextEditingController labourTimeHoursController = TextEditingController();
  final TextEditingController labourTimeMinutesController = TextEditingController();
  final TextEditingController labourRateController = TextEditingController();
  final TextEditingController purchasePriceController = TextEditingController();
  final TextEditingController upgradesPriceController = TextEditingController();
  final TextEditingController annualRepairCostsController = TextEditingController();
  final TextEditingController lifespanYearsController = TextEditingController();
  final TextEditingController lifespanMonthsController = TextEditingController();
  final TextEditingController lifespanDaysController = TextEditingController();
  final TextEditingController postProcessingController = TextEditingController();
  final TextEditingController wasteWeightController = TextEditingController();
  final TextEditingController failedPrintPercentageController = TextEditingController();
  final TextEditingController taxPercentageController = TextEditingController();
  final TextEditingController materialProfitMarginController = TextEditingController();
  final TextEditingController electricityProfitMarginController = TextEditingController();




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


  double calculateTotalCost() {
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
    double failedPrintPercentage = double.parse(failedPrintPercentageController.text);
    double taxPercentage = double.parse(taxPercentageController.text);
    double materialProfitMargin = double.parse(materialProfitMarginController.text);
    double electricityProfitMargin = double.parse(electricityProfitMarginController.text);
    double printTimeDays = double.parse(printTimeDaysController.text);
    double printTimeHours = double.parse(printTimeHoursController.text);
    double printTimeMinutes = double.parse(printTimeMinutesController.text);
    double lifespanYears = double.parse(lifespanYearsController.text);
    double lifespanMonths = double.parse(lifespanMonthsController.text);
    double lifespanDays = double.parse(lifespanDaysController.text);


    // Calculate total cost
    double materialCost = filamentUsed * costPerGram;
    if (addMaterialProfitMargin && materialCost > 0) {
      materialCost = (filamentUsed * (filamentCost / filamentWeight)) + ((filamentUsed * (filamentCost / filamentWeight)) * materialProfitMargin/100) ;
    }
    double printTimeInHours = (printTimeDays * 24) + (printTimeHours) + (printTimeMinutes / 60);
    double printCost = printTimeInHours * printPricePerHour;

    double electricityCost = 0.0;
    if (addElectricityProfitMargin && electricityCost > 0) {
      electricityCost = ((powerConsumption/1000) * printTimeInHours * costPerKWh) + (((powerConsumption/1000) * printTimeInHours * costPerKWh)* electricityProfitMargin/100);
    }

    double labourTimeInHours = (labourTimeDays * 24) + (labourTimeHours) + (labourTimeMinutes / 60);
    double labourCost = labourTimeInHours * labourRate;

    double printerLifespanInYears = (lifespanYears) + (lifespanMonths / 12) + (lifespanDays / 365);
    double equipmentCost = (purchasePrice + upgradesPrice + annualRepairCosts) / (printerLifespanInYears * 24 * 365);
    double wasteCost = (materialCost / filamentWeight) * wasteWeight;


    double failedPrintCost = (failedPrintPercentage/100 * (materialCost + printCost + electricityCost)) + (materialCost + printCost + electricityCost);
    double processingCost = postProcessing;
    double taxCost = materialCost + printCost + electricityCost + labourCost + equipmentCost + processingCost + wasteCost + failedPrintCost;

    return taxCost + (taxCost * taxPercentage/100);
  }

  ////


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
            children: <Widget>[
              const Text('Material Costs:'),
              TextFormField(
                controller: filamentCostController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter> [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  LengthLimitingTextInputFormatter(8)
                ],
                decoration: const InputDecoration(
                  labelText: 'Filament Cost per Reel',
                ),
              ),
              TextFormField(
                controller: filamentWeightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter> [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  LengthLimitingTextInputFormatter(8)
                ],
                decoration: const InputDecoration(
                  labelText: 'Filament Weight (grams)',
                ),
              ),
              TextFormField(
                controller: filamentUsedController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter> [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  LengthLimitingTextInputFormatter(8)
                ],
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
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter> [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    LengthLimitingTextInputFormatter(8)
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Material Profit Margin (%)',
                  ),
                ),
              ],
              const Text('Print Costs:'),

              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: printTimeDaysController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter> [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        LengthLimitingTextInputFormatter(8)
                      ],
                      decoration: const InputDecoration(labelText: 'Print Time Days'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: printTimeHoursController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter> [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        LengthLimitingTextInputFormatter(8)
                      ],
                      decoration: const InputDecoration(labelText: 'Print Time Hours'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: printTimeMinutesController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter> [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        LengthLimitingTextInputFormatter(8)
                      ],
                      decoration: const InputDecoration(labelText: 'Print Time Minutes'),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: printPricePerHourController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter> [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  LengthLimitingTextInputFormatter(8)
                ],
                decoration: const InputDecoration(
                  labelText: 'Print Price per Hour',
                ),
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
                    TextFormField(
                      controller: powerConsumptionController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        LengthLimitingTextInputFormatter(8)
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Wattage of Printer (W)',
                      ),
                    ),
                    TextFormField(
                      controller: costPerKWhController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        LengthLimitingTextInputFormatter(8)
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Cost per kWh',
                      ),
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
                      TextFormField(
                        controller: electricityProfitMarginController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                          LengthLimitingTextInputFormatter(8)
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Electricity Profit Percentage (%)',
                        ),
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
                    child: TextFormField(
                      controller: labourTimeDaysController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter> [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        LengthLimitingTextInputFormatter(8)
                      ],
                      decoration: const InputDecoration(labelText: 'Labour Time Days'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: labourTimeHoursController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter> [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        LengthLimitingTextInputFormatter(8)
                      ],
                      decoration: const InputDecoration(labelText: 'Labour Time Hours'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: labourTimeMinutesController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter> [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        LengthLimitingTextInputFormatter(8)
                      ],
                      decoration: const InputDecoration(labelText: 'Labour Time Minutes'),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: labourRateController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter> [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  LengthLimitingTextInputFormatter(8)
                ],
                decoration: const InputDecoration(
                  labelText: 'Labour Rate per Hour',
                ),
              ),

              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Equipment Costs:'),
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
                    TextFormField(
                      controller: purchasePriceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        LengthLimitingTextInputFormatter(8)
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Printer Purchase Price',
                      ),
                    ),
                    TextFormField(
                      controller: upgradesPriceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        LengthLimitingTextInputFormatter(8)
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Printer Upgrades Price',
                      ),
                    ),
                    TextFormField(
                      controller: annualRepairCostsController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        LengthLimitingTextInputFormatter(8)
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Annual Repair Costs',
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: lifespanYearsController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                              LengthLimitingTextInputFormatter(8)
                            ],
                            decoration: const InputDecoration(labelText: 'Printer Lifespan Years'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: lifespanMonthsController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                              LengthLimitingTextInputFormatter(8)
                            ],
                            decoration: const InputDecoration(labelText: 'Printer Lifespan Months'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: lifespanDaysController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                              LengthLimitingTextInputFormatter(8)
                            ],
                            decoration: const InputDecoration(labelText: 'Printer Lifespan Days'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),


              const Text('Post-Processing Costs:'),
              TextFormField(
                controller: postProcessingController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter> [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  LengthLimitingTextInputFormatter(8)
                ],
                decoration: const InputDecoration(
                  labelText: 'Post Processing (Painting, Sanding, etc.)',
                ),
              ),
              const Text('Waste Costs:'),
              TextFormField(
                controller: wasteWeightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter> [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  LengthLimitingTextInputFormatter(8)
                ],
                decoration: const InputDecoration(
                  labelText: 'Weight of Waste Material (grams)',
                ),
              ),
              const Text('Failed Print Costs:'),
              TextFormField(
                controller: failedPrintPercentageController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter> [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  LengthLimitingTextInputFormatter(8)
                ],
                decoration: const InputDecoration(
                  labelText: 'Percentage to Charge for Failed Print (%)',
                ),
              ),
              const Text('Tax/VAT/GST:'),
              TextFormField(
                controller: taxPercentageController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter> [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  LengthLimitingTextInputFormatter(8)
                ],
                decoration: const InputDecoration(
                  labelText: 'Tax/VAT/GST Percentage (%)',
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if ((addMaterialProfitMargin && materialProfitMarginController.text.isEmpty) ||
                        (countElectricity && (powerConsumptionController.text.isEmpty || costPerKWhController.text.isEmpty)) ||
                        (countEquipment && (purchasePriceController.text.isEmpty || upgradesPriceController.text.isEmpty || annualRepairCostsController.text.isEmpty || lifespanYearsController.text.isEmpty || lifespanMonthsController.text.isEmpty || lifespanDaysController.text.isEmpty)) ||
                        (addElectricityProfitMargin && electricityProfitMarginController.text.isEmpty)
                    ) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Warning'),
                            content: const Text('Please either untick the box or fill in a value.'),
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

                    double filamentCost = double.tryParse(filamentCostController.text) ?? 0;
                    double filamentWeight = double.tryParse(filamentWeightController.text) ?? 0;
                    double filamentUsed = double.tryParse(filamentUsedController.text) ?? 0;
                    double printTime = double.tryParse(printTimeHoursController.text) ?? 0;
                    double printPricePerHour = double.tryParse(printPricePerHourController.text) ?? 0;
                    double powerConsumption = double.tryParse(powerConsumptionController.text) ?? 0;
                    double costPerKWh = double.tryParse(costPerKWhController.text) ?? 0;
                    double labourTime = double.tryParse(labourTimeHoursController.text) ?? 0;
                    double labourRate = double.tryParse(labourRateController.text) ?? 0;
                    double purchasePrice = double.tryParse(purchasePriceController.text) ?? 0;
                    double upgradesPrice = double.tryParse(upgradesPriceController.text) ?? 0;
                    double annualRepairCosts = double.tryParse(annualRepairCostsController.text) ?? 0;
                    double printerLifespan = double.tryParse(lifespanYearsController.text) ?? 0;
                    double postProcessing = double.tryParse(postProcessingController.text) ?? 0;
                    double wasteWeight = double.tryParse(wasteWeightController.text) ?? 0;
                    double failedPrintPercentage = double.tryParse(failedPrintPercentageController.text) ?? 0;
                    double taxPercentage = double.tryParse(taxPercentageController.text) ?? 0;
                    double materialProfitMargin = addMaterialProfitMargin ? (double.tryParse(materialProfitMarginController.text) ?? 0) : 0;
                    double electricityProfitMargin = addElectricityProfitMargin ? (double.tryParse(electricityProfitMarginController.text) ?? 0) : 0;

                    double materialCostSubtotal = (filamentUsed * (filamentCost / filamentWeight)) + ((filamentUsed * (filamentCost / filamentWeight)) * materialProfitMargin/100);
                    String materialCostSubtotalString = materialCostSubtotal.toStringAsFixed(3);

                    double printCostSubtotal = printTime * printPricePerHour;
                    String printCostSubtotalString = printCostSubtotal.toStringAsFixed(3);

                    double electricityCostSubtotal = ((powerConsumption/1000) * printTime * costPerKWh) + (((powerConsumption/1000) * printTime * costPerKWh)* electricityProfitMargin/100);
                    String electricityCostSubtotalString = electricityCostSubtotal.toStringAsFixed(3);

                    double labourCostSubtotal = labourTime * labourRate;
                    String labourCostSubtotalString = labourCostSubtotal.toStringAsFixed(3);

                    double equipmentCostSubtotal = (purchasePrice + upgradesPrice + annualRepairCosts) / (printerLifespan * 24 * 365);
                    String equipmentCostSubtotalString = equipmentCostSubtotal.toStringAsFixed(3);

                    double wasteCostSubtotal = (materialCostSubtotal / filamentUsed) * wasteWeight;
                    String wasteCostSubtotalString = wasteCostSubtotal.toStringAsFixed(3);

                    double failedPrintCostSubtotal = (failedPrintPercentage / 100 * (materialCostSubtotal + printCostSubtotal + electricityCostSubtotal)) + (materialCostSubtotal + printCostSubtotal + electricityCostSubtotal);
                    String failedPrintCostSubtotalString = failedPrintCostSubtotal.toStringAsFixed(3);

                    double processingCostSubtotal = postProcessing;
                    String processingCostSubtotalString = processingCostSubtotal.toStringAsFixed(3);

                    double totalCost = materialCostSubtotal + printCostSubtotal + electricityCostSubtotal + labourCostSubtotal + equipmentCostSubtotal + wasteCostSubtotal + failedPrintCostSubtotal + processingCostSubtotal;
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
                              Text('Total Cost: $totalCostString'),
                              const SizedBox(height: 10),
                              Text('Material Cost Subtotal: $materialCostSubtotalString'),
                              Text('Print Cost Subtotal: $printCostSubtotalString'),
                              Text('Electricity Cost Subtotal: $electricityCostSubtotalString'),
                              Text('Labour Cost Subtotal: $labourCostSubtotalString'),
                              Text('Equipment Cost Subtotal: $equipmentCostSubtotalString'),
                              Text('Waste Cost Subtotal: $wasteCostSubtotalString'),
                              Text('Failed Print Cost Subtotal: $failedPrintCostSubtotalString'),
                              Text('Processing Cost Subtotal: $processingCostSubtotalString'),
                            ],
                          ),
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