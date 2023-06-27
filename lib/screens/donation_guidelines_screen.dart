import 'package:flutter/material.dart';

class DonationGuidelines extends StatelessWidget {
  const DonationGuidelines({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Donation Guidelines',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('1. Safety and Quality: Donate only food that is safe for consumption and of good quality. Ensure that the food items are not expired, spoiled, or contaminated.'),
            SizedBox(height: 16,),
            Text('2. Non-Perishable Items: Consider donating non-perishable food items such as canned goods, dry grains, pasta, rice, and packaged snacks. These items have a longer shelf life and are easier to distribute.'),
            SizedBox(height: 16,),
            Text('3. Nutritional Value: Aim to donate food items that are nutritious and can contribute to a balanced diet. Items such as canned vegetables, fruits in natural juices, whole grain products, and low-sodium items are highly beneficial.'),
            SizedBox(height: 16,),
            Text('4. Allergens and Special Dietary Needs: Clearly label any food items that contain common allergens such as nuts, dairy, gluten, or shellfish. Additionally, consider donating items that cater to special dietary needs, such as gluten-free or vegan options.'),
            SizedBox(height: 16,),
            Text('5. Proper Packaging: Ensure that donated food items are properly sealed and packaged to maintain their freshness and prevent contamination during transportation.'),
            SizedBox(height: 16,),
            Text('6. Clear Expiration Dates: Check the expiration dates of donated food items to ensure they are still within their usable period. Avoid donating items that have expired or are close to expiration.'),
            SizedBox(height: 16,),
            Text('7. Original Packaging: Whenever possible, donate food items in their original, unopened packaging. This helps maintain food safety standards and provides transparency to recipients about the product\'s origin.'),
            SizedBox(height: 16,),
            Text('8. Quantities and Portion Sizes: Donate food items in appropriate quantities and portion sizes. Consider the needs of the recipients and the logistics of distribution to avoid excessive waste or inadequate supply.'),
            SizedBox(height: 16,),
            Text('9. Handling Instructions: Include any necessary handling instructions or special requirements for specific food items, especially perishable goods that require refrigeration or specific storage conditions.'),
            SizedBox(height: 16,),
            Text('10. Hygiene and Food Safety: Prioritize hygiene when handling and donating food items. Ensure that the items are clean, free from pests or contaminants, and stored appropriately before donation.'),
            SizedBox(height: 16,),
            Text('11. Local Regulations: Familiarize yourself with local food safety regulations and guidelines to ensure compliance when donating food. Different regions may have specific requirements, and it\'s important to adhere to them.'),
            SizedBox(height: 16,),
          ],
        ),
      ),
    );
  }
}