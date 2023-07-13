import 'package:flutter/material.dart';

class ReceiveGuide extends StatelessWidget {
  const ReceiveGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Guide to Receiving',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'General Guide',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  size: 80,
                ),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                    child: Text(
                        '1. Scroll through homepage and find items that you need')),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.filter_alt,
                  size: 80,
                ),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: Text(
                    '2. Having trouble finding items you need? Filter by categories or directly search for it.',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite,
                  size: 80,
                ),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: Text(
                    '3. See something you like? Save it for later if you wish.',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat,
                  size: 80,
                ),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: Text(
                    '4. Chat with the donor and wait for donor to confirm donation',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check,
                  size: 80,
                ),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: Text(
                    '5. Accept donation once the donor has sent the request',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_people,
                  size: 80,
                ),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: Text(
                    '6. Meetup with donor at agreed meeting point to collect item.',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.rate_review,
                  size: 80,
                ),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: Text(
                    '7. Once the item has been collected, feel free to leave a review from within the chatroom for the other party. Share your experiences with the other party, be it good or bad!',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Others',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.block,
                  size: 80,
                ),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: Text(
                    'Note that all listings that have already expired or had been donated will be auto flagged out and will no longer be visible on the front page',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning,
                  size: 80,
                ),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: Text(
                    'Come across any suspicious characters? Report them.',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
