import 'package:flutter/material.dart';

class DiagnosisResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diagnosis Results"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4.0,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Image and Result Title
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        child: Image.asset(
                          'assets/spine_image.png', // Change to your image path
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Result: Osteophytes", // Example result, update as needed
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Result Assessment Section
                Text(
                  "Result Assessment",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Osteophytes are bony growths that form on the edges of your bones, often in joints like the spine. "
                  "While they are generally harmless, they can cause issues when they grow larger or press on surrounding tissues or nerves.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),

                // Impact on Health Section
                Text(
                  "Impact on Health",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "• Pain: Osteophytes can irritate nerves, causing pain in the spine, neck, or lower back.\n"
                  "• Stiffness: May limit movement and make daily tasks harder.\n"
                  "• Nerve Compression: Severe cases can cause tingling, numbness, or weakness in the limbs.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),

                // Buttons for Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        // Handle Conclusion action
                      },
                      child: Text("Conclusion"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle First Aid action
                      },
                      child: Text("First Aid"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Save Result action
                      },
                      child: Text("Save Result"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
