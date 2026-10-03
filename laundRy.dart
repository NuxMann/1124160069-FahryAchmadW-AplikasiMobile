// =====================================================
/*
HW 2 :  Laundry
Nama : Fahry Achmad Wibowo
NIM : 1124160069
 */
//  ====================================================


// ABSTRACTION

enum ServiceType {
  normal,
  express,
}

class LaundryTransaction {
  final String customer;
  final double actualWeight;
  final ServiceType service;

  const LaundryTransaction({
    required this.customer,
    required this.actualWeight,
    required this.service,
  });
}

class LaundryBill {
  final double chargedWeight;
  final double basicCost;
  final double expressCost;
  final double totalCost;

  const LaundryBill({
    required this.chargedWeight,
    required this.basicCost,
    required this.expressCost,
    required this.totalCost,
  });
}

// END OF ABSTRACTION

// DATA

const double ratePerKilogram = 7000;
const double minimumWeight = 2;
const double expressMultiplier = 0.50;

final List<LaundryTransaction> transactionHistory = [];

// END OF DATA

// DECOMPOSITION 

// BR-04
// Berat harus lebih besar dari 0 kg
bool hasValidWeight(double weight) {
  return weight > 0;
}

// BR-02
// Jika berat kurang dari 2 kg, sistem menggunakan 2 kg
double resolveChargedWeight(double actualWeight) {
  return actualWeight < minimumWeight
      ? minimumWeight
      : actualWeight;
}

// BR-01
// Menghitung biaya laundry berdasarkan berat yang dikenakan
double calculateBasicCost(double chargedWeight) {
  return chargedWeight * ratePerKilogram;
}

// BR-03
// Express mendapatkan tambahan 50% dari biaya dasar
double calculateExpressCost(
  double basicCost,
  ServiceType service,
) {
  return service == ServiceType.express
      ? basicCost * expressMultiplier
      : 0;
}

// Menggabungkan biaya dasar dan biaya express
double calculateFinalCost(
  double basicCost,
  double expressCost,
) {
  return basicCost + expressCost;
}

// END OF DECOMPOSITION 

// ALGORITHM 

LaundryBill? createBill(LaundryTransaction transaction) {
  // BR-04
  if (!hasValidWeight(transaction.actualWeight)) {
    return null;
  }

  // BR-02
  final chargedWeight =
      resolveChargedWeight(transaction.actualWeight);

  // BR-01
  final basicCost =
      calculateBasicCost(chargedWeight);

  // BR-03
  final expressCost =
      calculateExpressCost(
        basicCost,
        transaction.service,
      );

  final finalCost =
      calculateFinalCost(
        basicCost,
        expressCost,
      );

  return LaundryBill(
    chargedWeight: chargedWeight,
    basicCost: basicCost,
    expressCost: expressCost,
    totalCost: finalCost,
  );
}

// END OF ALGORITHM 

// OUTPUT 

String formatRupiah(double amount) {
  return 'Rp${amount.toStringAsFixed(0)}';
}

String describeTransaction(
  LaundryTransaction transaction,
  LaundryBill bill,
) {
  final serviceName =
      transaction.service == ServiceType.express
          ? 'Express'
          : 'Normal';

  return '''
Pelanggan   : ${transaction.customer}
Layanan     : $serviceName
Berat       : ${transaction.actualWeight} kg
Ditagihkan  : ${bill.chargedWeight} kg
Biaya dasar : ${formatRupiah(bill.basicCost)}
Tambahan    : ${formatRupiah(bill.expressCost)}
TOTAL       : ${formatRupiah(bill.totalCost)}
''';
}

// END OF OUTPUT 

// TEST SCENARIO 

void runTest(
  String title,
  LaundryTransaction transaction,
) {
  print('\n$title');

  final bill = createBill(transaction);

  if (bill == null) {
    print('Hasil      : Gagal - berat tidak valid');
    return;
  }


  transactionHistory.add(transaction);
  print(describeTransaction(transaction, bill));
}

void main() {

  // Skenario 1
  // 4 kg normal
  // Expected: Rp28.000
  runTest(
    '--- TEST 1: Laundry Normal ---',
    const LaundryTransaction(
      customer: 'Hanip',
      actualWeight: 4,
      service: ServiceType.normal,
    ),
  );

  // Skenario 2 - BR-02
  // 1 kg normal dihitung 2 kg
  // Expected: Rp14.000
  runTest(
    '--- TEST 2: Berat Minimum ---',
    const LaundryTransaction(
      customer: 'Ajis',
      actualWeight: 1,
      service: ServiceType.normal,
    ),
  );

  // Skenario 3 - BR-03
  // 4 kg express
  // Basic  = Rp28.000
  // Extra  = Rp14.000
  // Total  = Rp42.000
  runTest(
    '--- TEST 3: Laundry Express ---',
    const LaundryTransaction(
      customer: 'Jokowi',
      actualWeight: 4,
      service: ServiceType.express,
    ),
  );

  // Skenario 4 - BR-04
  // Berat 0 kg tidak valid
  // Expected: Gagal - berat tidak valid
  runTest(
    '--- TEST 4: Berat Tidak Valid ---',
    const LaundryTransaction(
      customer: 'Prabowo',
      actualWeight: 0,
      service: ServiceType.normal,
    ),
  );

  // Skenario 5 - BR-02 + BR-03
  // 1.5 kg express dihitung 2 kg
  // Basic = Rp14.000
  // Extra = Rp7.000
  // Total = Rp21.000
  runTest(
    '--- TEST 5: Minimum Weight + Express ---',
    const LaundryTransaction(
      customer: 'Dimas',
      actualWeight: 1.5,
      service: ServiceType.express,
    ),
  );

  // Perulangan untuk menampilkan seluruh transaksi valid
  print('\n=== RINGKASAN TRANSAKSI ===');

  for (final transaction in transactionHistory) {
    print(
      '${transaction.customer} - '
      '${transaction.actualWeight} kg - '
      '${transaction.service.name}',
    );
  }

  print(
    'Jumlah transaksi valid: '
    '${transactionHistory.length}',
  );
}

// END OF TEST SCENARIO 