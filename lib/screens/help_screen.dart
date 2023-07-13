import 'package:flutter/material.dart';
import 'package:foodbridge_project/screens/donate_guide.dart';
import 'package:foodbridge_project/screens/recieve_guide.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Guide',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                // Handle tap on the first section
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DonateGuide(),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/donate.png',
                        width: 150,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Center(
                        child: Text(
                          'Donating Guide',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                // Handle tap on the first section
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReceiveGuide(),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/donation.png',
                        width: 150,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Center(
                        child: Text(
                          'Receiving Guide',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
