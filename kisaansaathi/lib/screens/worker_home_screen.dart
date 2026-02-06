// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/work_request.dart';
import '../services/work_request_service.dart';

class WorkerHomeScreen extends StatefulWidget {
  const WorkerHomeScreen({super.key});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  List<WorkRequest> _openRequests = [];
  List<WorkRequest> _myJobs = [];
  bool _isLoading = true;
  String? _workerId;
  String? _workerName;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadWorkerData();
  }

  Future<void> _loadWorkerData() async {
    final prefs = await SharedPreferences.getInstance();
    _workerId = prefs.getString('workerId');
    _workerName = prefs.getString('workerName');

    if (_workerId != null) {
      await _fetchData();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    // Fetch open work requests
    final openResult = await WorkRequestService.getOpenWorkRequests();
    if (openResult.success) {
      _openRequests = openResult.data as List<WorkRequest>;
    }

    // Fetch worker's accepted jobs
    if (_workerId != null) {
      final myJobsResult = await WorkRequestService.getWorkerJobs(_workerId!);
      if (myJobsResult.success) {
        _myJobs = myJobsResult.data as List<WorkRequest>;
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _acceptJob(WorkRequest request) async {
    if (_workerId == null || _workerName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to accept jobs'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accept Job'),
        content: Text(
          'Do you want to accept this job?\n\n'
          'Work Type: ${request.workType}\n'
          'Payment: ₹${request.paymentAmount.toStringAsFixed(0)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
            ),
            child: const Text('Accept', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // Accept the job
    final result = await WorkRequestService.acceptWorkRequest(
      requestId: request.id,
      workerId: _workerId!,
      workerName: _workerName!,
    );

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Job accepted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      await _fetchData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _callFarmer(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch phone dialer'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Dashboard'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _selectedIndex == 0
              ? _buildAvailableJobsTab()
              : _buildMyJobsTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'Available Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'My Jobs',
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableJobsTab() {
    if (_openRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_off, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No jobs available at the moment',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _fetchData,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _openRequests.length,
        itemBuilder: (context, index) {
          final request = _openRequests[index];
          return _buildJobCard(request, isAvailable: true);
        },
      ),
    );
  }

  Widget _buildMyJobsTab() {
    if (_myJobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'You haven\'t accepted any jobs yet',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _myJobs.length,
        itemBuilder: (context, index) {
          final request = _myJobs[index];
          return _buildJobCard(request, isAvailable: false);
        },
      ),
    );
  }

  Widget _buildJobCard(WorkRequest request, {required bool isAvailable}) {
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
            // Header with work type and payment
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
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '₹${request.paymentAmount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              request.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),

            // Farmer info
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  'Posted by: ${request.farmerName}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: request.farmerPhone.isNotEmpty
                        ? () => _callFarmer(request.farmerPhone)
                        : null,
                    icon: const Icon(Icons.phone),
                    label: const Text('Call Farmer'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green.shade700,
                      side: BorderSide(color: Colors.green.shade700),
                    ),
                  ),
                ),
                if (isAvailable) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _acceptJob(request),
                      icon: const Icon(Icons.check),
                      label: const Text('Accept Job'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
