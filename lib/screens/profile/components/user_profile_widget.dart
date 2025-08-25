// lib/screens/profile/components/user_profile_widget.dart
import 'package:flutter/material.dart';
import 'package:oksana_shik/utils/theme.dart';
import 'package:oksana_shik/models/user_model.dart' as user_model;

class UserProfileWidget extends StatelessWidget {
  final user_model.User? userData;
  final bool isEditing;
  final TextEditingController fullNameController;
  final TextEditingController phoneNumberController;
  final VoidCallback
      onEditPressed; // Функция для обработки нажатия на кнопку редактирования

  const UserProfileWidget({
    super.key,
    required this.userData,
    required this.isEditing,
    required this.fullNameController,
    required this.phoneNumberController,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.primaryColor,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: AppTheme.backgroundColor,
                  ),
                ),
                const SizedBox(height: 15),
                // Поле ФИО
                isEditing
                    ? TextField(
                        controller: fullNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'ФИО',
                        ),
                      )
                    : Text(
                        userData?.fullName ?? '',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                const SizedBox(height: 5),
                // Поле email
                Text(
                  userData?.email ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.subColorGrey,
                  ),
                ),
                const SizedBox(height: 5),
                // Поле телефона
                isEditing
                    ? TextField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Телефон',
                        ),
                      )
                    : Text(
                        userData?.phoneNumber ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.subColorGrey,
                        ),
                      ),
                const SizedBox(height: 10),
                Text(
                  'Присоединился: ${userData != null ? _formatDate(userData!.createdAt) : ""}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.subColorGrey,
                  ),
                ),
              ],
            ),
            // Кнопка редактирования
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                icon: Icon(
                  isEditing ? Icons.save : Icons.edit,
                  size: 28,
                  color: AppTheme.subColorGrey,
                ),
                onPressed: onEditPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
