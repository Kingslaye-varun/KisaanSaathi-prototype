class WorkRequest {
  final String id;
  final String farmerId;
  final String farmerName;
  final String farmerPhone;
  final String workType;
  final double paymentAmount;
  final String description;
  final String status; // 'Pending', 'Accepted'
  final String? workerId; // ID of worker who accepted
  final String? workerName; // Name of worker who accepted
  final DateTime createdAt;
  final DateTime? acceptedAt;

  WorkRequest({
    required this.id,
    required this.farmerId,
    required this.farmerName,
    required this.farmerPhone,
    required this.workType,
    required this.paymentAmount,
    required this.description,
    required this.status,
    this.workerId,
    this.workerName,
    required this.createdAt,
    this.acceptedAt,
  });

  factory WorkRequest.fromJson(Map<String, dynamic> json) {
    return WorkRequest(
      id: json['_id'] ?? '',
      farmerId: json['farmerId'] ?? '',
      farmerName: json['farmerName'] ?? '',
      farmerPhone: json['farmerPhone'] ?? '',
      workType: json['workType'] ?? '',
      paymentAmount: (json['paymentAmount'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      status: json['status'] ?? 'Pending',
      workerId: json['workerId'],
      workerName: json['workerName'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      acceptedAt: json['acceptedAt'] != null
          ? DateTime.parse(json['acceptedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'farmerId': farmerId,
      'farmerName': farmerName,
      'farmerPhone': farmerPhone,
      'workType': workType,
      'paymentAmount': paymentAmount,
      'description': description,
      'status': status,
      'workerId': workerId,
      'workerName': workerName,
      'createdAt': createdAt.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
    };
  }

  // Helper method to check if request is pending
  bool get isPending => status == 'Pending';

  // Helper method to check if request is accepted
  bool get isAccepted => status == 'Accepted';
}
