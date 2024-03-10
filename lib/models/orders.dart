import 'package:medcs_dashboard/models/accepted_orders.dart';
import 'package:medcs_dashboard/models/declined_orders.dart';

class Orders {
  final List<AcceptedOrders> acceptedOrders;
  final List<DeclinedOrders> declinedOrders;

  Orders({required this.acceptedOrders, required this.declinedOrders});
}
