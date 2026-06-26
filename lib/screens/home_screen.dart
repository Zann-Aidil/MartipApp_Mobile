import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:martip_mobile/constants/app_colors.dart';
import 'package:martip_mobile/controllers/location_controller.dart';
import 'package:martip_mobile/controllers/deposit_controller.dart';
import 'package:martip_mobile/screens/profil_screen.dart';
import 'package:martip_mobile/widgets/location_card.dart';
import 'package:martip_mobile/widgets/deposit_card.dart';
import 'package:martip_mobile/widgets/state_widgets.dart';
import 'package:martip_mobile/widgets/custom_app_drawer.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:martip_mobile/controllers/auth_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.lightGrey,
      appBar: _buildCustomAppBar(),
      drawer: const CustomAppDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const HomeContent(),
          const DepositListContent(),
          const ScanContent(),
          const ProfilScreen(),
        ],
      ),
      bottomNavigationBar: _buildCustomBottomNav(),
    );
  }

  AppBar _buildCustomAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        icon: Icon(
          Icons.menu_rounded,
          color: Colors.grey.shade800,
          size: 26,
        ),
      ),
      title: FittedBox(
        fit: BoxFit.contain,
        child: Image.asset(
          'assets/images/New folder/logo-website.png',
          height: 65, 
          fit: BoxFit.contain,
        ),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade600, Colors.blue.shade400],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                setState(() => _selectedIndex = 3);
              },
              child: const Center(
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildCustomBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // Realtime refresh data titipan
          if (index == 1) {
            Get.find<DepositController>().loadDeposits();
          }
        },
        backgroundColor: Colors.white,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue.shade600,
        unselectedItemColor: Colors.grey.shade400,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
        items: [
          BottomNavigationBarItem(
            icon: AnimatedBuilder(
              animation: AlwaysStoppedAnimation(
                _selectedIndex == 0 ? 1.0 : 0.0,
              ),
              builder: (context, child) {
                return Transform.scale(
                  scale: _selectedIndex == 0 ? 1.1 : 1.0,
                  child: Icon(
                    _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                    size: 24,
                  ),
                );
              },
            ),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Transform.scale(
              scale: _selectedIndex == 1 ? 1.1 : 1.0,
              child: Icon(
                _selectedIndex == 1
                    ? Icons.inventory_2
                    : Icons.inventory_2_outlined,
                size: 24,
              ),
            ),
            label: 'Status Titipan',
          ),
          BottomNavigationBarItem(
            icon: Transform.scale(
              scale: _selectedIndex == 2 ? 1.1 : 1.0,
              child: Icon(
                _selectedIndex == 2 ? Icons.qr_code_scanner : Icons.qr_code_2,
                size: 24,
              ),
            ),
            label: 'OnoPay QR',
          ),
          BottomNavigationBarItem(
            icon: Transform.scale(
              scale: _selectedIndex == 3 ? 1.1 : 1.0,
              child: Icon(
                _selectedIndex == 3 ? Icons.person : Icons.person_outline,
                size: 24,
              ),
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final TextEditingController _searchController = TextEditingController();
  final LocationController _locationController = Get.find();
  final PageController _bannerController = PageController();
  Timer? _bannerTimer;
  int _currentBannerPage = 0;
  final int _totalBannerPages = 3;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerController.hasClients) {
        _currentBannerPage++;
        _bannerController.animateToPage(
          _currentBannerPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        ).then((_) {
          // Loop Slide,
          // silent jump ke slide 0 tanpa animasi
          if (_currentBannerPage >= _totalBannerPages) {
            _currentBannerPage = 0;
            _bannerController.jumpToPage(0);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner Carousel
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 160,
                  child: PageView(
                    controller: _bannerController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentBannerPage = index;
                      });
                    },
                    children: [
                      // Slide 0
                      _buildBannerSlide(
                        context,
                        'Promo Penitipan!',
                        'Diskon 50% untuk titipan tas hari ini.',
                        Colors.blue.shade800,
                        'assets/images/martip_banner_promo.png',
                      ),
                      // Slide 1
                      _buildBannerSlide(
                        context,
                        'Aman & Terpercaya',
                        'Barangmu dijaga dengan fasilitas CCTV.',
                        Colors.indigo.shade800,
                        'assets/images/martip_banner_cctv.png',
                      ),
                      // Slide 2
                      _buildBannerSlide(
                        context,
                        'Lokasi Terdekat',
                        'Cari mitra MARTIP di sekitarmu.',
                        Colors.purple.shade800,
                        'assets/images/martip_banner_map.png',
                      ),
                      // Slide 3 (duplikat slide 0 — untuk efek geser kanan terus)
                      _buildBannerSlide(
                        context,
                        'Promo Penitipan!',
                        'Diskon 50% untuk titipan tas hari ini.',
                        Colors.blue.shade800,
                        'assets/images/martip_banner_promo.png',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Dot indicators (pakai modulo supaya dot ke-4 = dot ke-1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_totalBannerPages, (index) {
                    final int activeDot = _currentBannerPage % _totalBannerPages;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: activeDot == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: activeDot == index
                            ? Colors.blue.shade600
                            : Colors.grey.shade300,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                // Search
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          // Pencarian AJAX real-time
                          if (value.isEmpty) {
                            _locationController.clearSearch();
                          } else {
                            _locationController.searchLocations(value);
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: 'Cari lokasi...',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(60, 56),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        if (_searchController.text.isNotEmpty) {
                          _locationController.searchLocations(
                            _searchController.text,
                          );
                        }
                      },
                      child: const Icon(Icons.search),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Search Results atau Rekomendasi
          Obx(() {
            if (_locationController.searchQuery.isNotEmpty) {
              // Show search results
              if (_locationController.isLoading.value) {
                return const LoadingWidget(message: 'Mencari...');
              } else if (_locationController.searchResults.isEmpty) {
                return const EmptyWidget(
                  message: 'Lokasi tidak ditemukan',
                  icon: Icons.location_off,
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Hasil Pencarian (${_locationController.searchResults.length})',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...(_locationController.searchResults.map((location) {
                      return LocationCard(
                        location: location,
                        onTap: () {
                          Get.toNamed('/detail', arguments: location);
                        },
                      );
                    }).toList()),
                    const SizedBox(height: 16),
                  ],
                );
              }
            }

            // Show recommendations when not searching
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'LOKASI REKOMENDASI',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() {
                  if (_locationController.isLoading.value) {
                    return const LoadingWidget();
                  } else if (_locationController.locations.isEmpty) {
                    return const EmptyWidget(message: 'Belum ada lokasi');
                  } else {
                    return Column(
                      children: [
                        ...(_locationController.locations.take(3).map((
                          location,
                        ) {
                          return LocationCard(
                            location: location,
                            onTap: () {
                              Get.toNamed('/detail', arguments: location);
                            },
                          );
                        }).toList()),
                      ],
                    );
                  }
                }),
              ],
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildBannerSlide(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    String imageUrl,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            color.withOpacity(0.65),
            BlendMode.srcOver,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class DepositListContent extends StatelessWidget {
  const DepositListContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DepositController controller = Get.find();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Get.offAllNamed('/home');
                Get.snackbar(
                  'Info', 
                  'Silakan pilih lokasi mitra di Beranda terlebih dahulu',
                  backgroundColor: Colors.blue.shade50,
                  colorText: Colors.blue.shade800,
                  snackPosition: SnackPosition.TOP,
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Titipan Baru'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
          Obx(() {
            if (controller.isLoading.value && controller.deposits.isEmpty) {
              return const SizedBox(height: 300, child: LoadingWidget());
            } else if (controller.deposits.isEmpty) {
              return const SizedBox(
                height: 300,
                child: EmptyWidget(
                  message: 'Belum ada riwayat titipan',
                  icon: Icons.inventory_2,
                ),
              );
            } else {
              return Column(
                children: [
                  ...controller.deposits.map((deposit) {
                    return DepositCard(
                      deposit: deposit,
                      onTap: () => Get.toNamed('/tracking', arguments: deposit),
                    );
                  }).toList(),
                  const SizedBox(height: 16),
                ],
              );
            }
          }),
        ],
      ),
    );
  }
}

class ScanContent extends StatefulWidget {
  const ScanContent({Key? key}) : super(key: key);

  @override
  State<ScanContent> createState() => _ScanContentState();
}

class _ScanContentState extends State<ScanContent> {
  bool _isScanning = false;
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _startScan() {
    setState(() {
      _isScanning = true;
    });
  }

  Future<void> _processDirectPayment(String barcode) async {
    final authController = Get.find<AuthController>();
    String phone = authController.user?.phone ?? '';

    // Gunakan nomor HP default jika tidak ada, sesuai kebiasaan di aplikasi ini
    if (phone.isEmpty) {
      phone = '082276146870';
    }
    
    String trackingCode = '';
    try {
      final qrDataJson = jsonDecode(barcode);
      if (qrDataJson is Map<String, dynamic> && qrDataJson.containsKey('tracking_code')) {
        trackingCode = qrDataJson['tracking_code'].toString();
      }
    } catch (e) {
      if (barcode.contains('MARTIP-PAY-')) {
        try {
          final startIndex = barcode.indexOf('MARTIP-PAY-') + 11;
          final endIndex = barcode.indexOf('-AMT-');
          if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
            trackingCode = barcode.substring(startIndex, endIndex);
          }
        } catch (_) {}
      }
    }

    if (trackingCode.isEmpty) {
      trackingCode = 'TRX-${DateTime.now().millisecondsSinceEpoch}'; // fallback
    }

    // Tampilkan loading dialog yang bisa di-dismiss dengan tombol back
    Get.dialog(
      WillPopScope(
        onWillPop: () async {
          Get.back(); // tutup loading dialog
          return false;
        },
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Memproses pembayaran...',
                style: TextStyle(color: Colors.white, fontSize: 14, decoration: TextDecoration.none),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      final url = Uri.parse('http://10.0.2.2:8000/api/mobile/pay');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'tracking_code': trackingCode,
          'qr_code': barcode,
          'payer_phone': phone,
        }),
      );

      Get.back(); // tutup loading

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success'] == true) {
          final receiptData = result['data'] ?? {};
          Get.offAllNamed('/invoice', arguments: {
            'transaction_id': receiptData['receipt_no'] ?? trackingCode,
            'amount': receiptData['amount'] ?? 0,
            'date': receiptData['date'] ?? DateTime.now().toIso8601String(),
            'item_name': receiptData['item_name'] ?? 'Titipan Barang',
            'merchant': receiptData['merchant'] ?? 'MARTIP',
            'payment_method': 'OnoPay QR',
            'status': receiptData['status'] ?? 'Berhasil'
          });
        }
        // Jika gagal, diam saja — tidak menampilkan error
      }
      // Jika status code bukan 200, diam saja — tidak menampilkan error
    } catch (e) {
      // Tutup loading jika masih terbuka, tanpa menampilkan error
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }

  void _onDetect(String barcode) {
    setState(() {
      _isScanning = false;
    });
    
    _processDirectPayment(barcode);
  }

  @override
  Widget build(BuildContext context) {
    if (_isScanning) {
      return Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && _isScanning) {
                final barcode = barcodes.first.rawValue;
                if (barcode != null) {
                  _onDetect(barcode);
                }
              }
            },
          ),
          Center(
            child: Text(
              'Arahkan kamera ke QR Code OnoPay',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () => setState(() => _isScanning = false),
                child: const Text('Batal'),
              ),
            ),
          ),
        ],
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.qr_code_scanner,
                size: 80,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Scan QR Pembayaran',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Arahkan kamera ke QR Code OnoPay di layar monitor/website untuk melanjutkan proses pembayaran secara otomatis.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _startScan,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Scan Sekarang', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                _onDetect('MARTIP-PAY-INV-123456789-AMT-35000');
              },
              child: const Text('Simulasi Scan Web QR (Tanpa Kamera)'),
            )
          ],
        ),
      ),
    );
  }
}
