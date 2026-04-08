import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/user_profile_service.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  
  String _selectedGender = 'Male';
  String _selectedGoal = 'Weight Loss';
  bool _isEditing = false;
  final UserProfileService userProfile = Get.put(UserProfileService());


  void _fetchUserProfile() async {

    
    // Update form fields with backend data
    setState(() {
      _nameController.text = userProfile.name.value;
      _emailController.text = userProfile.email.value;
      _phoneController.text = userProfile.phone.value;
      _selectedGender = userProfile.gender.value;
      _ageController.text = userProfile.age.value;
      _heightController.text = userProfile.height.value;
      _weightController.text = userProfile.weight.value;
      _selectedGoal = userProfile.fitnessGoal.value;
    });
  }

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _goals = ['Weight Loss', 'Muscle Gain', 'Strength Training', 'Endurance', 'General Fitness'];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0F23),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Personal Information',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = !_isEditing;
                        });
                      },
                      child: Text(
                        _isEditing ? 'Cancel' : 'Edit',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF6C63FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Form
              Expanded(
                child: Obx(() => userProfile.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF6C63FF),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                      children: [
                        // Profile Picture
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFF9C88FF)],
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Basic Info
                        Obx(() {
                          _nameController.text = userProfile.name.value;
                          _emailController.text = userProfile.email.value;
                          _phoneController.text = userProfile.phone.value;
                          return Column(
                            children: [
                              _buildInfoField('Full Name', _nameController, Icons.person_outline),
                              const SizedBox(height: 16),
                              _buildInfoField('Email', _emailController, Icons.email_outlined),
                              const SizedBox(height: 16),
                              _buildInfoField('Phone', _phoneController, Icons.phone_outlined),
                            ],
                          );
                        }),
                        const SizedBox(height: 16),
                        // Gender Dropdown
                        _buildDropdownField('Gender', _selectedGender, _genders, Icons.wc, (value) {
                          setState(() => _selectedGender = value!);
                        }),
                        const SizedBox(height: 16),
                        // Physical Info
                        Obx(() {
                          _ageController.text = userProfile.age.value;
                          _heightController.text = userProfile.height.value;
                          _weightController.text = userProfile.weight.value;
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoField('Age', _ageController, Icons.cake_outlined, suffix: 'years'),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildInfoField('Height', _heightController, Icons.height, suffix: 'cm'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildInfoField('Weight', _weightController, Icons.monitor_weight_outlined, suffix: 'kg'),
                            ],
                          );
                        }),
                        const SizedBox(height: 16),
                        // Fitness Goal
                        Obx(() {
                          _selectedGoal = userProfile.fitnessGoal.value;
                          return _buildDropdownField('Fitness Goal', _selectedGoal, _goals, Icons.flag_outlined, (value) {
                            setState(() => _selectedGoal = value!);
                          });
                        }),
                        const SizedBox(height: 40),
                        // Save Button
                        if (_isEditing)
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF6C63FF), Color(0xFF9C88FF)],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF6C63FF).withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _saveChanges,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  'Save Changes',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                      ],
                          ),
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

  Widget _buildInfoField(String label, TextEditingController controller, IconData icon, {String? suffix}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: TextFormField(
        controller: controller,
        enabled: _isEditing,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(
            color: Colors.grey[400],
          ),
          prefixIcon: Icon(icon, color: Colors.grey[400]),
          suffixText: suffix,
          suffixStyle: GoogleFonts.inter(color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
        validator: (value) {
          if (value?.isEmpty ?? true) return 'This field is required';
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items, IconData icon, ValueChanged<String?> onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        style: GoogleFonts.inter(color: Colors.white),
        dropdownColor: const Color(0xFF1A1A2E),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(color: Colors.grey[400]),
          prefixIcon: Icon(icon, color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: _isEditing ? onChanged : null,
      ),
    );
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isEditing = false;
      });
      
      // Save fitness goal
      final userProfile = Get.find<UserProfileService>();
      userProfile.updateFitnessGoal(_selectedGoal);
      
      Get.snackbar(
        'Success',
        'Personal information updated successfully',
        backgroundColor: const Color(0xFF6C63FF).withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}
