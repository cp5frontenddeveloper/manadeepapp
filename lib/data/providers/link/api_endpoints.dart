
// Base URL for the API
const String adminLink = 'http://192.168.0.108:8000/api';

// Login page link
const String loginPageLink = '$adminLink/representatives/login';

// Function to get the admin connection notification endpoint
String getAdminConnectNotificationEndpoint(String userId) {
  final String endpoint = "$adminLink/representatives/$userId/logs";
  print('API Endpoint: $endpoint'); // Logging the API endpoint
  return endpoint;
}

// Reset password endpoint
const String resetPasswordEndpoint =
    "$adminLink/representatives/reset-password";

// Get customers link
const String getCustomersLink = '$adminLink/clients';

// Get box inventory link
const String getBoxInventoryLink = '$adminLink/inventory-boxes';

// Function to update notification endpoint
String updateNotificationEndpoint(String id) =>
    '$adminLink/representatives/logs/$id';

// Get box types link
const String getBoxTypesLink = '$adminLink/box-types';

// Add order response link
const String addOrderResponseLink = '$adminLink/orders';

// Function to get order link
String getOrderLink(String id) => "$adminLink/representatives/$id/orders";
// Add  Not to notification admin
String addNote = "$adminLink/notes";
String getNote(String id) => "$adminLink/notes/$id";
