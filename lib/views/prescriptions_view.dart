import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:medcs_dashboard/core/utlity/styles.dart';
import 'package:medcs_dashboard/models/prescription_model.dart';
import 'package:intl/intl.dart';
import 'package:medcs_dashboard/providers/order_provider/orders_provider.dart';
import 'package:medcs_dashboard/views/show_image_view.dart';
import 'package:provider/provider.dart'; // for DateFormat

class PrescriptionsView extends StatelessWidget {
  const PrescriptionsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Prescriptions Orders,',
          style: StylesLight.titleSubHeading28,
        ),
      ),
      body: StreamBuilder<List<PrescriptionImageModel>>(
        stream: Provider.of<OrderProvider>(context).fetchPrescriptionImages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred! ${snapshot.error.toString()}'),
            );
          } else {
            final List<PrescriptionImageModel>? prescriptionData =
                snapshot.data;

            if (prescriptionData != null && prescriptionData.isNotEmpty) {
              // Play a sound and show a notification when a new prescription is added
              AudioPlayer()
                  .play(UrlSource('assets/sounds/level-up-191997.mp3'));
              // Schedule a post-frame callback to show the Snackbar after a delay of 1 minute
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('A Prescription order request'),
                    backgroundColor: Colors.green,
                  ),
                );
              });

              return ListView.builder(
                itemCount: prescriptionData.length,
                itemBuilder: (context, index) {
                  final data = prescriptionData[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(data.userImage),
                              backgroundColor: Colors.grey[200],
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.userName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  data.userEmail,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 400),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                        image: data.imageURL,
                                      ),
                                    ),
                                  );
                                },
                                child: Image(
                                  height: 100,
                                  width: 55,
                                  fit: BoxFit.fill,
                                  image: NetworkImage(data.imageURL),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 100),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      orderProvider.acceptOrder(
                                          data.userEmail, context);
                                    },
                                    icon: const Icon(Icons.check,
                                        color: Colors.green),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      orderProvider.declineOrder(
                                          data.userEmail, context);
                                    },
                                    icon: const Icon(Icons.close,
                                        color: Colors.deepOrange),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Time: ${DateFormat.jm().format(data.timestamp.toDate())}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text(
                  'There are no prescriptions',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
