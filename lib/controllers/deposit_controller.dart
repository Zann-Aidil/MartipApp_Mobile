import 'package:get/get.dart';
import '../models/deposit_model.dart';
import '../repositories/deposit_repository.dart';
import '../controllers/auth_controller.dart';

class DepositController extends GetxController {
  final depositRepository = DepositRepository();
  final authController = Get.find<AuthController>();

  var deposits = RxList<DepositModel>([]);
  var currentDeposit = Rx<DepositModel?>(null);
  var isLoading = false.obs;
  var errorMessage = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadDeposits();
  }

  // LOAD all deposits for current user
  Future<void> loadDeposits() async {
    isLoading.value = true;
    try {
      if (authController.user == null) return;

      final userDeposits = await depositRepository.getDepositsByUserId(
        authController.user!.id!,
      );
      deposits.value = userDeposits;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // CREATE - Create new deposit
  Future<bool> createDeposit({
    required int merchantId,
    required String itemType,
    required String itemDescription,
    required List<String> itemPhotos,
    required String durationUnit,
    required int durationValue,
    required double estimatedAmount,
    String? specialNotes,
  }) async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      if (authController.user == null) {
        throw Exception('User not logged in');
      }

      final newDeposit = DepositModel(
        userId: authController.user!.id!,
        merchantId: merchantId,
        itemType: itemType,
        itemDescription: itemDescription,
        itemPhotos: itemPhotos,
        durationUnit: durationUnit,
        durationValue: durationValue,
        estimatedAmount: estimatedAmount,
        specialNotes: specialNotes,
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final depositId = await depositRepository.createDeposit(newDeposit);
      final deposit = await depositRepository.getDepositById(depositId);

      if (deposit != null) {
        deposits.add(deposit);
        currentDeposit.value = deposit;
        return true;
      }
      return false;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // READ - Get deposit by ID
  Future<DepositModel?> getDepositById(int id) async {
    try {
      return await depositRepository.getDepositById(id);
    } catch (e) {
      errorMessage.value = e.toString();
      return null;
    }
  }

  // UPDATE - Update deposit
  Future<bool> updateDeposit(DepositModel deposit) async {
    isLoading.value = true;
    try {
      final updated = deposit.copyWith(
        updatedAt: DateTime.now(),
      );

      await depositRepository.updateDeposit(updated);
      
      // Update in list
      final index = deposits.indexWhere((d) => d.id == deposit.id);
      if (index != -1) {
        deposits[index] = updated;
      }

      if (currentDeposit.value?.id == deposit.id) {
        currentDeposit.value = updated;
      }

      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // UPDATE - Update deposit status
  Future<bool> updateDepositStatus(int depositId, String status) async {
    try {
      await depositRepository.updateDepositStatus(depositId, status);
      await loadDeposits();
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    }
  }

  // UPDATE - Set QR Code
  Future<bool> setQRCode(int depositId, String qrCode) async {
    try {
      await depositRepository.updateQRCode(depositId, qrCode);
      await loadDeposits();
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    }
  }

  // DELETE - Delete deposit
  Future<bool> deleteDeposit(int id) async {
    isLoading.value = true;
    try {
      await depositRepository.deleteDeposit(id);
      deposits.removeWhere((d) => d.id == id);

      if (currentDeposit.value?.id == id) {
        currentDeposit.value = null;
      }

      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Get deposits by status
  List<DepositModel> getDepositsByStatus(String status) {
    return deposits.where((d) => d.status == status).toList();
  }

  // Get active deposits
  List<DepositModel> get activeDeposits {
    return deposits.where((d) => 
      d.status != 'completed' && d.status != 'cancelled'
    ).toList();
  }

  // Get completed deposits
  List<DepositModel> get completedDeposits {
    return deposits.where((d) => d.status == 'completed').toList();
  }
}
