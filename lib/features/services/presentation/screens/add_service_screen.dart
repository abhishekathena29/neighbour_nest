import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/models/service_model.dart';
import '../../../auth/presentation/auth_provider.dart';
import '../service_provider.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();
  final _tagsController = TextEditingController();

  String _selectedCategory = 'academic_tutoring';
  ServiceType _selectedServiceType = ServiceType.oneTime;
  bool _isOnline = false;
  bool _hasPricing = true; // New: Switch for pricing
  DateTime? _availableFrom;
  DateTime? _availableTo;
  int _maxParticipants = 1;

  // New: Available timing
  TimeOfDay? _availableStartTime;
  TimeOfDay? _availableEndTime;
  List<String> _selectedDays = [];
  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Add Service'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Basic Information'),
              const SizedBox(height: 16),

              // Service Title
              _buildTextField(
                controller: _titleController,
                label: 'Service Title',
                hint: 'e.g., Math Tutoring for Grade 10',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter service title';
                  }
                  if (value.length > AppConstants.maxTitleLength) {
                    return 'Title too long';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Description
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Describe your service in detail...',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter service description';
                  }
                  if (value.length > AppConstants.maxDescriptionLength) {
                    return 'Description too long';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Category
              _buildDropdown(
                label: 'Category',
                value: _selectedCategory,
                items: AppConstants.defaultCategories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['id'],
                    child: Text(category['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Service Type
              _buildDropdown(
                label: 'Service Type',
                value: _selectedServiceType.toString().split('.').last,
                items: ServiceType.values.map((type) {
                  return DropdownMenuItem(
                    value: type.toString().split('.').last,
                    child: Text(_getServiceTypeLabel(type)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedServiceType = ServiceType.values.firstWhere(
                      (e) => e.toString().split('.').last == value,
                    );
                  });
                },
              ),

              const SizedBox(height: 24),

              _buildSectionTitle('Pricing & Availability'),
              const SizedBox(height: 16),

              // Has Pricing Switch
              _buildSwitchTile(
                title: 'Include Pricing',
                subtitle: 'Turn off if you want to discuss pricing separately',
                value: _hasPricing,
                onChanged: (value) {
                  setState(() {
                    _hasPricing = value!;
                    if (!_hasPricing) {
                      _priceController.clear();
                    }
                  });
                },
              ),

              // Price (shown only if _hasPricing is true)
              if (_hasPricing) ...[
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _priceController,
                  label: 'Price (₹)',
                  hint: '500',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (_hasPricing) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter valid price';
                      }
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 16),

              // Online/Offline
              _buildSwitchTile(
                title: 'Online Service',
                subtitle: 'Check if this service can be provided online',
                value: _isOnline,
                onChanged: (value) {
                  setState(() {
                    _isOnline = value!;
                  });
                },
              ),

              if (!_isOnline) ...[
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _locationController,
                  label: 'Location',
                  hint: 'Enter service location',
                ),
              ],

              const SizedBox(height: 16),

              // Available From
              _buildDateField(
                label: 'Available From',
                value: _availableFrom,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _availableFrom = date;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              // Available To
              _buildDateField(
                label: 'Available To',
                value: _availableTo,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _availableFrom ?? DateTime.now(),
                    firstDate: _availableFrom ?? DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _availableTo = date;
                    });
                  }
                },
              ),

              const SizedBox(height: 24),

              _buildSectionTitle('Available Timing'),
              const SizedBox(height: 16),

              // Available Days
              const Text(
                'Available Days',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _daysOfWeek.map((day) {
                  final isSelected = _selectedDays.contains(day);
                  return FilterChip(
                    label: Text(day),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedDays.add(day);
                        } else {
                          _selectedDays.remove(day);
                        }
                      });
                    },
                    selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                    checkmarkColor: AppTheme.primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Time Range
              Row(
                children: [
                  Expanded(
                    child: _buildTimeField(
                      label: 'Start Time',
                      value: _availableStartTime,
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          setState(() {
                            _availableStartTime = time;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTimeField(
                      label: 'End Time',
                      value: _availableEndTime,
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _availableStartTime ?? TimeOfDay.now(),
                        );
                        if (time != null) {
                          setState(() {
                            _availableEndTime = time;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _buildSectionTitle('Additional Information'),
              const SizedBox(height: 16),

              // Max Participants
              _buildTextField(
                controller: TextEditingController(
                  text: _maxParticipants.toString(),
                ),
                label: 'Max Participants',
                hint: '1',
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _maxParticipants = int.tryParse(value) ?? 1;
                },
              ),

              const SizedBox(height: 16),

              // Contact Information
              _buildTextField(
                controller: _contactController,
                label: 'Contact Information',
                hint: 'Phone number or email for inquiries',
              ),

              const SizedBox(height: 16),

              // Tags
              _buildTextField(
                controller: _tagsController,
                label: 'Tags (comma separated)',
                hint: 'math, tutoring, grade10, algebra',
              ),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.greenOrangeGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Consumer<ServiceProvider>(
                      builder: (context, serviceProvider, child) {
                        return serviceProvider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Create Service',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: BorderSide(
                color: AppTheme.textSecondary.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: BorderSide(
                color: AppTheme.textSecondary.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: const BorderSide(color: AppTheme.primaryColor),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(color: AppTheme.textSecondary.withOpacity(0.3)),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            items: items,
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required void Function(bool?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppTheme.textSecondary.withOpacity(0.3)),
      ),
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              border: Border.all(
                color: AppTheme.textSecondary.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  value != null
                      ? '${value.day}/${value.month}/${value.year}'
                      : 'Select date',
                  style: TextStyle(
                    color: value != null
                        ? AppTheme.textPrimary
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField({
    required String label,
    required TimeOfDay? value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              border: Border.all(
                color: AppTheme.textSecondary.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  value != null ? value.format(context) : 'Select time',
                  style: TextStyle(
                    color: value != null
                        ? AppTheme.textPrimary
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getServiceTypeLabel(ServiceType type) {
    switch (type) {
      case ServiceType.oneTime:
        return 'One Time';
      case ServiceType.recurring:
        return 'Recurring';
      case ServiceType.workshop:
        return 'Workshop';
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final serviceProvider = Provider.of<ServiceProvider>(
      context,
      listen: false,
    );

    if (authProvider.userProfile == null) return;

    // Build timing string
    String? timingString;
    if (_selectedDays.isNotEmpty &&
        _availableStartTime != null &&
        _availableEndTime != null) {
      timingString =
          '${_selectedDays.join(', ')}: ${_availableStartTime!.format(context)} - ${_availableEndTime!.format(context)}';
    }

    final service = ServiceModel(
      id: '', // Will be set by Firestore
      contributorId: authProvider.userProfile!.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      tags: _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList(),
      serviceType: _selectedServiceType,
      price: _hasPricing && _priceController.text.isNotEmpty
          ? double.tryParse(_priceController.text)
          : null,
      location: _locationController.text.trim().isNotEmpty
          ? _locationController.text.trim()
          : null,
      isOnline: _isOnline,
      availableFrom: _availableFrom,
      availableTo: _availableTo,
      maxParticipants: _maxParticipants,
      contactInfo: _contactController.text.trim().isNotEmpty
          ? _contactController.text.trim()
          : null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      requirements: timingString != null ? {'timing': timingString} : null,
    );

    final success = await serviceProvider.createService(service);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Service created successfully!'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
      context.pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            serviceProvider.errorMessage ?? 'Failed to create service',
          ),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }
}
