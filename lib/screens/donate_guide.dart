import 'package:flutter/material.dart';

class DonateGuide extends StatelessWidget {
  const DonateGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Guide to Donation',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Text('General Guide', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.question_mark,
                  size: 80,
                ),
                SizedBox(
                  width: 8,
                ),
                Text('1. Select item to donate'),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_box,
                  size: 80,
                ),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: Text(
                    '2. Upload details of item. Include a picture, title, categories, dietary specifications, collection address and any other information',
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
                    '3. Wait for others to express interest and chat with them',
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
                    '4. Once the other party has confirmed interest and wishes to collect item, within the chatroom, click on offer donation to confirm. This will be used for tracking ratings and reviews later on. Note that once you have offered donation to 1 person, you can no longer offer the item to anyone else.',
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
                    '5. Arrange collection point for recipient to come and collect item',
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
                    '6. Once the item has been collected, feel free to leave a review from within the chatroom for the other party. Share your experiences with the other party, be it good or bad!',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text('Others', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.edit,
                  size: 80,
                ),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: Text(
                    'Manage listings from within your profile page. You can edit and delete listings.',
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
