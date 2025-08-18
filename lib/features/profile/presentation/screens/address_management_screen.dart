import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/data/models/address_model.dart';

class AddressManagementScreen extends ConsumerStatefulWidget {
  const AddressManagementScreen({super.key});

  @override
  ConsumerState<AddressManagementScreen> createState() =>
      _AddressManagementScreenState();
}

class _AddressManagementScreenState
    extends ConsumerState<AddressManagementScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _countryController = TextEditingController();
  final _labelController = TextEditingController();

  bool _isDefault = false;
  bool _isEditing = false;
  String? _editingAddressId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _countryController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  void _showAddAddressDialog() {
    _resetForm();
    _isEditing = false;
    _editingAddressId = null;
    _showAddressDialog();
  }

  void _showEditAddressDialog(Address address) {
    _isEditing = true;
    _editingAddressId = address.id;
    _populateForm(address);
    _showAddressDialog();
  }

  void _showAddressDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAddressForm(),
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _streetController.clear();
    _cityController.clear();
    _stateController.clear();
    _zipCodeController.clear();
    _countryController.clear();
    _labelController.clear();
    _isDefault = false;
  }

  void _populateForm(Address address) {
    _streetController.text = address.street;
    _cityController.text = address.city;
    _stateController.text = address.state;
    _zipCodeController.text = address.zipCode;
    _countryController.text = address.country;
    _labelController.text = address.label;
    _isDefault = address.isDefault;
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = ref.read(authProvider).user;
      if (user == null) return;

      final newAddress = Address(
        id:
            _editingAddressId ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        street: _streetController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        zipCode: _zipCodeController.text.trim(),
        country: _countryController.text.trim(),
        label: _labelController.text.trim().isEmpty
            ? 'Home'
            : _labelController.text.trim(),
        isDefault: _isDefault,
      );

      List<Address> addresses = user.addresses
          .map(
            (addr) => addr is Address
                ? addr
                : Address.fromMap(Map<String, dynamic>.from(addr)),
          )
          .toList();

      if (_isEditing) {
        // Update existing address
        final index = addresses.indexWhere(
          (addr) => addr.id == _editingAddressId,
        );
        if (index != -1) {
          addresses[index] = newAddress;
        }
      } else {
        // Add new address
        addresses.add(newAddress);
      }

      // Handle default address logic
      if (_isDefault) {
        addresses = addresses
            .map((addr) => addr.copyWith(isDefault: addr.id == newAddress.id))
            .toList();
      }

      // TODO: Update user in Firebase
      // await ref.read(authProvider.notifier).updateUserAddresses(addresses);

      Navigator.of(context).pop();
      ToastManager.showSuccess(
        context,
        _isEditing
            ? 'Address updated successfully!'
            : 'Address added successfully!',
      );

      setState(() {});
    } catch (e) {
      ToastManager.showError(context, 'Error saving address: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteAddress(Address address) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: Text(
          'Are you sure you want to delete the address "${address.label}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final user = ref.read(authProvider).user;
        if (user == null) return;

        List<Address> addresses = user.addresses
            .map(
              (addr) => addr is Address
                  ? addr
                  : Address.fromMap(Map<String, dynamic>.from(addr)),
            )
            .toList();
        addresses.removeWhere((addr) => addr.id == address.id);

        // If deleted address was default, make first remaining address default
        if (address.isDefault && addresses.isNotEmpty) {
          addresses[0] = addresses[0].copyWith(isDefault: true);
        }

        // TODO: Update user in Firebase
        // await ref.read(authProvider.notifier).updateUserAddresses(addresses);

        if (mounted) {
          ToastManager.showSuccess(context, 'Address deleted successfully!');
          setState(() {});
        }
      } catch (e) {
        if (mounted) {
          ToastManager.showError(context, 'Error deleting address: $e');
        }
      }
    }
  }

  Future<void> _setDefaultAddress(Address address) async {
    try {
      final user = ref.read(authProvider).user;
      if (user == null) return;

      List<Address> addresses = user.addresses.map((addr) {
        final addressObj = addr is Address
            ? addr
            : Address.fromMap(Map<String, dynamic>.from(addr));
        return addressObj.copyWith(isDefault: addressObj.id == address.id);
      }).toList();

      // TODO: Update user in Firebase
      // await ref.read(authProvider.notifier).updateUserAddresses(addresses);

      ToastManager.showSuccess(context, 'Default address updated!');
      setState(() {});
    } catch (e) {
      ToastManager.showError(context, 'Error updating default address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final addresses =
        user?.addresses
            .map(
              (addr) => addr is Address
                  ? addr
                  : Address.fromMap(Map<String, dynamic>.from(addr)),
            )
            .toList() ??
        [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Manage Addresses',
          style: AppTheme.girlishHeadingStyle.copyWith(
            fontSize: 24,
            color: AppColors.secondary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: AppColors.secondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_rounded, color: AppColors.primary),
            onPressed: _showAddAddressDialog,
          ),
        ],
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: addresses.isEmpty
              ? _buildEmptyState()
              : _buildAddressesList(addresses),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
            ),
            child: Icon(
              Icons.location_on_outlined,
              size: 64,
              color: AppColors.secondary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No addresses yet',
            style: AppTheme.girlishHeadingStyle.copyWith(
              fontSize: 24,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Add your first delivery address to get started',
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 16,
              color: AppColors.secondary.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _showAddAddressDialog,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Address'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressesList(List<Address> addresses) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        final address = addresses[index];
        return _buildAddressCard(address);
      },
    );
  }

  Widget _buildAddressCard(Address address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.surface.withValues(alpha: 0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: address.isDefault
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.1),
          width: address.isDefault ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          if (address.isDefault)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Default',
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.location_on_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        address.label,
                        style: AppTheme.elegantBodyStyle.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  address.street,
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 16,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${address.city}, ${address.state} ${address.zipCode}',
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 14,
                    color: AppColors.secondary.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address.country,
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 14,
                    color: AppColors.secondary.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (!address.isDefault)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _setDefaultAddress(address),
                          icon: const Icon(Icons.star_outline_rounded),
                          label: const Text('Set as Default'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                    if (!address.isDefault) const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showEditAddressDialog(address),
                        icon: const Icon(Icons.edit_rounded),
                        label: const Text('Edit'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.secondary,
                          side: BorderSide(color: AppColors.secondary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _deleteAddress(address),
                        icon: const Icon(Icons.delete_rounded),
                        label: const Text('Delete'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressForm() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.surface,
            AppColors.surface.withValues(alpha: 0.95),
            AppColors.background.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 16),
            width: 80,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              _isEditing ? 'Edit Address' : 'Add New Address',
              style: AppTheme.girlishHeadingStyle.copyWith(
                fontSize: 24,
                color: AppColors.secondary,
              ),
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildFormField(
                      controller: _labelController,
                      label: 'Address Label',
                      hint: 'e.g., Home, Work, Grandma\'s House',
                      icon: Icons.label_rounded,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an address label';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      controller: _streetController,
                      label: 'Street Address',
                      hint: 'Enter your street address',
                      icon: Icons.home_rounded,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your street address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFormField(
                            controller: _cityController,
                            label: 'City',
                            hint: 'City',
                            icon: Icons.location_city_rounded,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your city';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildFormField(
                            controller: _stateController,
                            label: 'State',
                            hint: 'State',
                            icon: Icons.map_rounded,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your state';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFormField(
                            controller: _zipCodeController,
                            label: 'ZIP Code',
                            hint: 'ZIP Code',
                            icon: Icons.pin_drop_rounded,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your ZIP code';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildFormField(
                            controller: _countryController,
                            label: 'Country',
                            hint: 'Country',
                            icon: Icons.public_rounded,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your country';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Default address toggle
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: AppColors.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Set as Default Address',
                                  style: AppTheme.elegantBodyStyle.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.secondary,
                                  ),
                                ),
                                Text(
                                  'This address will be used for all future orders',
                                  style: AppTheme.elegantBodyStyle.copyWith(
                                    fontSize: 14,
                                    color: AppColors.secondary.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _isDefault,
                            onChanged: (value) {
                              setState(() {
                                _isDefault = value;
                              });
                            },
                            activeColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.secondary,
                      side: BorderSide(color: AppColors.secondary),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: _isLoading
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
                        : Text(_isEditing ? 'Update' : 'Save'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.elegantBodyStyle.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTheme.elegantBodyStyle.copyWith(
              color: AppColors.secondary.withValues(alpha: 0.5),
            ),
            prefixIcon: Icon(icon, color: AppColors.primary),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
