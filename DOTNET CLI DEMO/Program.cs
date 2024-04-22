using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _3dPrinterPriceCalc
{
    internal class Program
    {
        static void Main(string[] args)
        {
            // Prompt user for material costs
            Console.WriteLine("Material Costs:");
            Console.Write("Enter material used (in grams): ");
            double materialUsed = GetDoubleInput();
            Console.Write("Enter cost per gram of material: ");
            double costPerGram = GetDoubleInput();
            double materialCost = materialUsed * costPerGram;

            // Prompt user for print costs
            Console.WriteLine("\nPrint Costs:");
            Console.Write("Enter print time (in hours): ");
            double printTime = GetDoubleInput();
            Console.Write("Enter print price per hour: ");
            double printPricePerHour = GetDoubleInput();
            double printCost = printTime * printPricePerHour;

            // Prompt user for electricity costs
            Console.WriteLine("\nElectricity Costs:");
            Console.Write("Enter power consumption of printer (kW): ");
            double powerConsumption = GetDoubleInput();
            Console.Write("Enter cost per kWh: ");
            double costPerKWh = GetDoubleInput();
            double electricityCost = powerConsumption * printTime * costPerKWh;

            // Prompt user for labour costs
            Console.WriteLine("\nLabour Costs:");
            Console.Write("Enter labour time (in hours): ");
            double labourTime = GetDoubleInput();
            Console.Write("Enter labour rate per hour: ");
            double labourRate = GetDoubleInput();
            double labourCost = labourTime * labourRate;

            // Prompt user for equipment costs
            Console.WriteLine("\nEquipment Costs (Maintenance, Repair and Depreciation):");
            Console.Write("Enter printer purchase price: ");
            double purchasePrice = GetDoubleInput();
            Console.Write("Enter printer upgrades price: ");
            double upgradesPrice = GetDoubleInput();
            Console.Write("Enter annual repair costs: ");
            double annualRepairCosts = GetDoubleInput();
            Console.Write("Enter printer lifespan (in years): ");
            double printerLifespan = GetDoubleInput();
            double equipmentCost = (purchasePrice + upgradesPrice + annualRepairCosts) / (printerLifespan * 24 * 365);

            // Prompt user for post-processing costs
            Console.WriteLine("\nPost Processing Costs (Painting, Smoothing, etc.):");
            // Add code to calculate post-processing costs

            // Prompt user for overhead costs
            Console.WriteLine("\nOverhead Costs (Rent, Insurance, etc.):");
            // Add code to calculate overhead costs

            // Prompt user for waste costs
            Console.WriteLine("\nWaste Costs:");
            Console.Write("Enter weight of waste material (in grams): ");
            double wasteWeight = GetDoubleInput();

            // Calculate waste costs
            double wasteCost = (materialCost / materialUsed) * wasteWeight;


            // Prompt user for failed print costs
            Console.WriteLine("\nFailed Print Costs:");
            Console.Write("Failed print? (Y/N): ");
            string failedPrintInput = Console.ReadLine().Trim().ToUpper();

            double failedPrintCost = 0;
            if (failedPrintInput == "Y")
            {
                Console.Write("Enter percentage to charge: ");
                double failedPrintPercentage = GetDoubleInput() / 100;
                failedPrintCost = (failedPrintPercentage * (materialCost + printCost + electricityCost)) + (materialCost + printCost + electricityCost);
            }

            // Prompt user for tax/VAT/GST
            Console.WriteLine("\nTAX/VAT/GST:");
            Console.Write("Enter tax/VAT/GST percentage: ");
            double taxPercentage = GetDoubleInput() / 100;

            // Calculate tax/VAT/GST
            double taxCost = (materialCost + printCost + electricityCost) * taxPercentage;

            // Calculate total cost including tax/VAT/GST
            double totalCostWithTax = materialCost + printCost + electricityCost + labourCost + equipmentCost + taxCost;

            // Display total cost with tax
            Console.WriteLine($"\nTotal Cost (including tax/VAT/GST): {totalCostWithTax:C}");

            // Calculate total cost including failed print costs and tax/VAT/GST
            double totalCostWithFailedPrintAndTax = totalCostWithTax + failedPrintCost;

            // Display total cost with failed print costs and tax
            Console.WriteLine($"\nTotal Cost (including failed print costs and tax/VAT/GST): {totalCostWithFailedPrintAndTax:C}");



            // Calculate total cost
            double totalCost = materialCost + printCost + electricityCost + labourCost + equipmentCost;

            // Display total cost
            Console.WriteLine($"\nTotal Cost: {totalCost:C}");

            // Display summary of all costs
            // Add code to display summary

            Console.WriteLine("\nPress any key to exit.");
            Console.ReadKey();
        }

        // Method to get double input from user
        static double GetDoubleInput()
        {
            double input;
            while (!double.TryParse(Console.ReadLine(), out input))
            {
                Console.WriteLine("Invalid input. Please enter a valid number:");
            }
            return input;
        }
    }
}

