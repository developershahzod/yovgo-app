import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../config/app_theme.dart';
import 'dart:async';

class MapScreenNew extends StatefulWidget {
  const MapScreenNew({Key? key}) : super(key: key);

  @override
  State<MapScreenNew> createState() => _MapScreenNewState();
}

class _MapScreenNewState extends State<MapScreenNew> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  bool _showLocationDialog = true;
  String _selectedFilter = '24/7';
  
  final LatLng _center = const LatLng(41.2995, 69.2401); // Tashkent

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    // Add car wash markers
    final carWashes = [
      {'id': '1', 'name': 'Black Star', 'lat': 41.3105, 'lng': 69.2401, 'rating': 5.0},
      {'id': '2', 'name': '777 car wash', 'lat': 41.2895, 'lng': 69.2301, 'rating': 5.0},
      {'id': '3', 'name': 'Car Wash 3', 'lat': 41.3005, 'lng': 69.2501, 'rating': 4.8},
      {'id': '4', 'name': 'Car Wash 4', 'lat': 41.2995, 'lng': 69.2601, 'rating': 4.6},
      {'id': '5', 'name': 'Car Wash 5', 'lat': 41.2795, 'lng': 69.2201, 'rating': 4.9},
    ];

    for (var wash in carWashes) {
      _markers.add(
        Marker(
          markerId: MarkerId(wash['id'] as String),
          position: LatLng(wash['lat'] as double, wash['lng'] as double),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          onTap: () {
            // Show car wash details
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 13.0,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // Top Search Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Avto moykalarni qidirish',
                              hintStyle: TextStyle(
                                color: AppTheme.textTertiary,
                                fontSize: 15,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppTheme.textSecondary,
                                size: 22,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 24,
                          color: AppTheme.borderGray,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: AppTheme.textSecondary,
                            size: 22,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('24/7', '24/7', AppTheme.green),
                        const SizedBox(width: 8),
                        _buildFilterChip('Hozir ochiq', 'Hozir ochiq', AppTheme.primaryCyan),
                        const SizedBox(width: 8),
                        _buildFilterChip('Eng yaqin', 'Eng yaqin', AppTheme.textSecondary),
                        const SizedBox(width: 8),
                        _buildFilterChip('Reytingi', 'Reytingi', AppTheme.textSecondary),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // My Location Button
          Positioned(
            right: 20,
            bottom: 420,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.my_location,
                  color: AppTheme.primaryCyan,
                  size: 24,
                ),
                onPressed: () {
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLng(_center),
                  );
                },
              ),
            ),
          ),

          // Bottom Sheet with Car Washes
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Handle
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.borderGray,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    
                    // Car Wash List
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(20),
                        children: [
                          _buildCarWashCard(
                            'Black Star Car Wash',
                            'Matbuotchilar Street 32, Tashkent',
                            '500 m',
                            4.6,
                            '22:00 GACHA OCHIQ',
                            true,
                          ),
                          const SizedBox(height: 12),
                          _buildCarWashCard(
                            'Wash N Go Car Wash',
                            'Tutzor mahallasi, 35 uy, Choshtepa, 100114, Tashkent',
                            '900 m',
                            4.6,
                            'YOPIQ 8:00 GACHA',
                            false,
                          ),
                          const SizedBox(height: 12),
                          _buildCarWashCard(
                            'DJ Car Wash',
                            'Chimrobod ko\'chasi 28, Tashkent, Toshkent',
                            '1.2 km',
                            4.6,
                            '24/7 OCHIQ',
                            true,
                          ),
                          const SizedBox(height: 12),
                          _buildCarWashCard(
                            'Car wash 777',
                            'Qumtariq ko\'chasi 59 Tashkent',
                            '1.5 km',
                            4.8,
                            '2 SOATDA YOPILADI',
                            true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Location Permission Dialog
          if (_showLocationDialog)
            Container(
              color: AppTheme.overlayDark,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Geolokatsiyangizga\nruxsat bering',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Sizga yaqin avtomoykalarni ko\'rishimiz uchun sozlamalarda joylashuv ma\'lumotiga ruxsat bering',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showLocationDialog = false;
                          });
                        },
                        child: Text(
                          'Hozir emas',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showLocationDialog = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.darkNavy,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Sozlamalarni ochish',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String id, String label, Color color) {
    final isSelected = _selectedFilter == id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : AppTheme.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: color, width: 1.5) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (id == '24/7')
              Icon(Icons.access_time, size: 18, color: color)
            else if (id == 'Hozir ochiq')
              Icon(Icons.schedule, size: 18, color: color)
            else if (id == 'Eng yaqin')
              Icon(Icons.near_me, size: 18, color: color)
            else
              Icon(Icons.star, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarWashCard(
    String name,
    String address,
    String distance,
    double rating,
    String status,
    bool isOpen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/car-wash-detail');
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderGray, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star, size: 16, color: AppTheme.yellow),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isOpen ? AppTheme.primaryCyan : AppTheme.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 12,
                              color: AppTheme.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              status,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppTheme.primaryCyan,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        distance,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryCyan,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
