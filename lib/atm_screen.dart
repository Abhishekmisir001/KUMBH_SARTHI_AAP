import 'package:flutter/material.dart';

class AtmFinderScreen extends StatelessWidget {
  const AtmFinderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue,
                  child: Text(
                    "A",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      "Abhishek Mishra",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.notifications, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: "Search for Bank / ATM",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Your Perfect Finding Ways",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _FeatureCard(
                  imagePath: 'assets/find-bank.jpg',
                  label: 'Find your bank',
                ),
                _FeatureCard(
                  imagePath: 'assets/find-atm.jpg',
                  label: 'Find Bank / ATMs',
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Near You",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _BankTile(
                    bankName: "HDFC Bank",
                    address: "No. 4, Ground Floor, haridoss main road",
                    status: "Closed | Opens 10 am, Monday",
                    imagePath: 'assets/hdfc.png',
                  ),
                  _BankTile(
                    bankName: "IOB Bank ATM",
                    address: "Bank",
                    status: "Open 24 Hours",
                    imagePath: 'assets/iob.png',
                  ),
                  _BankTile(
                    bankName: "Union Bank",
                    address: "Union Road, City Center",
                    status: "Closed | Opens 9 am, Monday",
                    imagePath: 'assets/union.png',
                  ),
                  _BankTile(
                    bankName: "SBI ATM",
                    address: "Main Market Road",
                    status: "Open 24 Hours",
                    imagePath: 'assets/sbi.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String imagePath;
  final String label;

  const _FeatureCard({required this.imagePath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset(
            imagePath,
            height: 80,
          ),
          SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _BankTile extends StatelessWidget {
  final String bankName;
  final String address;
  final String status;
  final String imagePath;

  const _BankTile({
    required this.bankName,
    required this.address,
    required this.status,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              height: 40,
              width: 40,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bankName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    address,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 5),
                  Text(
                    status,
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.call, color: Colors.green),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.directions, color: Colors.blue),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.share, color: Colors.grey),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AtmFinderScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
