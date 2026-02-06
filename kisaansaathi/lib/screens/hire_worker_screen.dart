// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/work_request.dart';
import '../services/work_request_service.dart';

class HireWorkerScreen extends StatefulWidget {
  const HireWorkerScreen({super.key});

  @override
  State<HireWorkerScreen> createState() => _HireWorkerScreenState();
}

class _HireWorkerScreenState extends State<HireWorkerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _workTypeController = TextEditingController();
  final _paymentController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingRequests = true;
  String? _farmerId;
  String? _farmerName;
  String? _farmerPhone;
  List<WorkRequest> _myRequests = [];

  final List<String> _workTypes = [
    'Harvesting',
    'Sowing',
    'Plowing',
    'Weeding',
    'Irrigation',
    'Fertilizer Application',
    'Pest Control',
    'General Farm Work',
    'Other',
  ];

  String _selectedWorkType = 'Harvesting';

  @override
  void initState() {
    super.initState();
    _loadFarmerData();
  }

  Future<void> _loadFarmerData() async {
    final prefs = await SharedPreferences.getInstance();
    _farmerId = prefs.getString('farmerId');
    _farmerName = prefs.getString('farmerName');
    _farmerPhone = prefs.getString('phoneNumber');

    if (_farmerId != null) {
      await _fetchMyRequests();
    } else {
      setState(() {
        _isLoadingRequests = false;
      });
    }
  }

  Future<void> _fetchMyRequests() async {
    if (_farmerId == null) return;

    setState(() {
      _isLoadingRequests = true;
    });

    final result = await WorkRequestService.getFarmerWorkRequests(_farmerId!);
    if (result.success) {
      setState(() {
        _myRequests = result.data as List<WorkRequest>;
        _isLoadingRequests = false;
      });
    } else {
      setState(() {
        _isLoadingRequests = false;
      });
    }
  }

  Future<void> _postJob() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_farmerId == null || _farmerName == null || _farmerPhone == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login as a farmer to post jobs'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final workType = _selectedWorkType == 'Other'
        ? _workTypeController.text.trim()
        : _selectedWorkType;

    final result = await WorkRequestService.createWorkRequest(
      farmerId: _farmerId!,
      farmerName: _farmerName!,
      farmerPhone: _farmerPhone!,
      workType: workType,
      paymentAmount: double.parse(_paymentController.text.trim()),
      description: _descriptionController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Job posted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form
      _workTypeController.clear();
      _paymentController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedWorkType = 'Harvesting';
      });

      // Refresh requests list
      await _fetchMyRequests();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteRequest(String requestId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Job'),
        content: const Text('Are you sure you want to delete this job posting?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final result = await WorkRequestService.deleteWorkRequest(requestId);
    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Job deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
      await _fetchMyRequests();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hire a Worker'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Post Job Form
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Post a New Job',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Work Type Dropdown
                    Text(
                      'Work Type',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedWorkType,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      items: _workTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedWorkType = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Custom work type if "Other" is selected
                    if (_selectedWorkType == 'Other') ...[
                      TextFormField(
                        controller: _workTypeController,
                        decoration: InputDecoration(
                          labelText: 'Specify Work Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        validator: (value) {
                          if (_selectedWorkType == 'Other' &&
                              (value == null || value.isEmpty)) {
                            return 'Please specify the work type';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Payment Amount
                    Text(
                      'Payment Amount (₹)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _paymentController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter payment amount',
                        prefixText: '₹ ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter payment amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Text(
                      'Job Description',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Describe the work in detail...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter job description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Post Job Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _postJob,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Post Job',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // My Posted Jobs
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Posted Jobs',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _isLoadingRequests
                      ? const Center(child: CircularProgressIndicator())
                      : _myRequests.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.work_off,
                                      size: 64,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No jobs posted yet',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _myRequests.length,
                              itemBuilder: (context, index) {
                                final request = _myRequests[index];
                                return _buildRequestCard(request);
                              },
                            ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(WorkRequest request) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    request.workType,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: request.isPending
                        ? Colors.orange.shade50
                        : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    request.status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: request.isPending
                          ? Colors.orange.shade700
                          : Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '₹${request.paymentAmount.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              request.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            if (request.isAccepted && request.workerName != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.green.shade700, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Accepted by: ${request.workerName}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (request.isPending) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _deleteRequest(request.id),
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _workTypeController.dispose();
    _paymentController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
