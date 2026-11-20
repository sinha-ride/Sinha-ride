import 'package:flutter/material.dart';

void main() {
  runApp(const SinhaRideApp());
}

const Color srYellow = Color(0xFFFFD400);
const Color srBlack = Color(0xFF101010);

class SinhaRideApp extends StatelessWidget {
  const SinhaRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SINHA RIDE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: srYellow,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        appBarTheme: const AppBarTheme(
          backgroundColor: srBlack,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        useMaterial3: true,
      ),
      home: const CustomerHomePage(),
    );
  }
}

enum VehicleType { car, auto, bike }

extension VehicleDetails on VehicleType {
  String get label => switch (this) {
        VehicleType.car => 'Car',
        VehicleType.auto => 'Auto',
        VehicleType.bike => 'Bike',
      };

  String get symbol => switch (this) {
        VehicleType.car => '🚗',
        VehicleType.auto => '🛺',
        VehicleType.bike => '🏍️',
      };

  int get sampleFare => switch (this) {
        VehicleType.car => 89,
        VehicleType.auto => 49,
        VehicleType.bike => 29,
      };

  String get description => switch (this) {
        VehicleType.car => 'Comfortable ride',
        VehicleType.auto => 'Affordable city ride',
        VehicleType.bike => 'Quick solo ride',
      };
}

class RideBooking {
  RideBooking({
    required this.pickup,
    required this.drop,
    required this.vehicle,
    required this.estimatedFare,
    required this.createdAt,
  });

  final String pickup;
  final String drop;
  final VehicleType vehicle;
  final int estimatedFare;
  final DateTime createdAt;
}

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _pickupController = TextEditingController();
  final _dropController = TextEditingController();
  VehicleType _selectedVehicle = VehicleType.car;
  final List<RideBooking> _bookings = [];
  int _tabIndex = 0;

  @override
  void dispose() {
    _pickupController.dispose();
    _dropController.dispose();
    super.dispose();
  }

  void _bookRide() {
    if (!_formKey.currentState!.validate()) return;

    final booking = RideBooking(
      pickup: _pickupController.text.trim(),
      drop: _dropController.text.trim(),
      vehicle: _selectedVehicle,
      estimatedFare: _selectedVehicle.sampleFare,
      createdAt: DateTime.now(),
    );

    setState(() => _bookings.insert(0, booking));

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking request created'),
        content: Text(
          'Your ${booking.vehicle.label} booking request has been saved on '
          'this device for this starter build.\n\n'
          'Estimated sample fare: ₹${booking.estimatedFare}\n\n'
          'Live driver matching and real payments are not connected yet.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _tabIndex = 1);
            },
            child: const Text('View my rides'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.local_taxi, color: srYellow, size: 29),
            SizedBox(width: 9),
            Text('SINHA '),
            Text('RIDE', style: TextStyle(color: srYellow)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => _showInfo('Notifications will be added in a later version.'),
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _tabIndex,
          children: [
            _buildHome(),
            _buildRides(),
            _buildProfile(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (index) => setState(() => _tabIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.history), label: 'My Rides'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHome() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: srBlack,
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Ride, Your Way.', style: TextStyle(color: srYellow, fontSize: 23, fontWeight: FontWeight.bold)),
              SizedBox(height: 7),
              Text('Book a car, auto or bike ride.', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text('Where do you want to go?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Form(
          key: _formKey,
          child: Column(
            children: [
              _locationField(
                controller: _pickupController,
                label: 'Pickup location',
                hint: 'Enter pickup area or address',
                icon: Icons.my_location,
              ),
              const SizedBox(height: 12),
              _locationField(
                controller: _dropController,
                label: 'Drop location',
                hint: 'Enter destination',
                icon: Icons.location_on_outlined,
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text('Choose your ride', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...VehicleType.values.map(_vehicleTile),
        const SizedBox(height: 18),
        FilledButton(
          onPressed: _bookRide,
          style: FilledButton.styleFrom(
            backgroundColor: srYellow,
            foregroundColor: srBlack,
            minimumSize: const Size.fromHeight(56),
            textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: const Text('Request a Ride  →'),
        ),
        const SizedBox(height: 12),
        const Text(
          'Starter version: fares shown are sample values, not live quotes. '
          'Driver matching, maps and payments will be connected in the next development phase.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _locationField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: srBlack),
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Please enter $label';
        return null;
      },
    );
  }

  Widget _vehicleTile(VehicleType vehicle) {
    final selected = _selectedVehicle == vehicle;
    return Card(
      elevation: selected ? 2 : 0,
      color: selected ? const Color(0xFFFFF4B8) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: selected ? srYellow : Colors.black12, width: selected ? 2 : 1),
      ),
      child: ListTile(
        onTap: () => setState(() => _selectedVehicle = vehicle),
        leading: Text(vehicle.symbol, style: const TextStyle(fontSize: 30)),
        title: Text(vehicle.label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(vehicle.description),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('From ₹${vehicle.sampleFare}', style: const TextStyle(fontWeight: FontWeight.bold)),
            if (selected) const Text('Selected', style: TextStyle(fontSize: 11, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildRides() {
    if (_bookings.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.route, size: 58, color: Colors.black38),
              SizedBox(height: 12),
              Text('No rides yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Your ride requests will appear here.'),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _bookings.length,
      itemBuilder: (context, index) {
        final ride = _bookings[index];
        return Card(
          child: ListTile(
            leading: Text(ride.vehicle.symbol, style: const TextStyle(fontSize: 28)),
            title: Text('${ride.pickup} → ${ride.drop}', maxLines: 2, overflow: TextOverflow.ellipsis),
            subtitle: Text('${ride.vehicle.label} • Request saved locally'),
            trailing: Text('₹${ride.estimatedFare}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  Widget _buildProfile() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const CircleAvatar(radius: 38, backgroundColor: srYellow, child: Icon(Icons.person, size: 42, color: srBlack)),
        const SizedBox(height: 12),
        const Center(child: Text('Welcome to SINHA RIDE', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        const SizedBox(height: 22),
        _profileItem(Icons.phone_android, 'Login with mobile number', 'OTP login will be connected in the next phase.'),
        _profileItem(Icons.support_agent, 'Help & Support', 'Customer support setup is pending.'),
        _profileItem(Icons.shield_outlined, 'Safety', 'Safety and emergency features are planned.'),
        _profileItem(Icons.info_outline, 'About SINHA RIDE', 'Your Ride, Your Way.'),
      ],
    );
  }

  Widget _profileItem(IconData icon, String title, String subtitle) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: () => _showInfo(subtitle),
      ),
    );
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
