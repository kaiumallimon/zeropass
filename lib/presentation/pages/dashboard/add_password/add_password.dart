import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:zeropass/core/constants/app_strings.dart';
import 'package:zeropass/presentation/providers/add_password_provider.dart';
import 'package:zeropass/presentation/providers/category_provider.dart';
import 'package:zeropass/shared/widgets/custom_button.dart';
import 'package:zeropass/shared/widgets/custom_dropdown_menu.dart';
import 'package:zeropass/shared/widgets/custom_textfield.dart';

class AddPasswordPage extends StatefulWidget {
  const AddPasswordPage({super.key});

  @override
  State<AddPasswordPage> createState() => _AddPasswordPageState();
}

class _AddPasswordPageState extends State<AddPasswordPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AddPasswordProvider>().loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final addPasswordProvider = context.watch<AddPasswordProvider>();
    final categoryProvider = context.watch<CategoryProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: theme.colorScheme.surface,
        toolbarHeight: 80,
        title: const Text('Add New Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.add_password_tip,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(.7),
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Name*',
                hintText: 'Enter app/website name',
                keyboardType: TextInputType.text,
                controller: addPasswordProvider.nameController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Url',
                hintText: 'Enter app/website url (Skip if not applicable)',
                controller: addPasswordProvider.urlController,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              CustomDropdownField<String>(
                label: 'Select Category*',
                value: addPasswordProvider.selectedCategoryId,
                items: categoryProvider.categories.map((category) {
                  final name = (category['name'] as String?)?.trim();
                  final displayName = (name != null && name.isNotEmpty)
                      ? name
                      : 'Uncategorized';
                  return DropdownMenuItem<String>(
                    value: category['id'],
                    child: Text(displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  addPasswordProvider.setSelectedCategory(value);
                },
                hintText: 'Choose a category',
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Username/Email*',
                hintText: 'Enter username or email',
                keyboardType: TextInputType.emailAddress,
                controller: addPasswordProvider.usernameController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Password*',
                hintText: 'Enter password',
                controller: addPasswordProvider.passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                sideWidget: SizedBox(
                  width: 50,
                  height: 50,
                  child: IconButton(
                    onPressed: () {
                      addPasswordProvider.generatePassword();
                    },

                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedAiMagic,
                      color: theme.colorScheme.primary,
                    ),
                    tooltip: 'Generate Password',
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: theme.colorScheme.primary.withOpacity(.4),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Confirm Password*',
                hintText: 'Enter password',
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                controller: addPasswordProvider.confirmPasswordController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Note',
                hintText: 'Enter any additional information (Optional)',
                controller: addPasswordProvider.notesController,
                keyboardType: TextInputType.multiline,
                isExpandable: true,
                height: 150,
              ),
              const SizedBox(height: 20),
              Consumer<AddPasswordProvider>(
                builder: (context, provider, child) {
                  return CustomButton(
                    text: 'Save Password',
                    width: double.infinity,
                    isLoading: provider.isLoading,
                    onPressed: () async {
                      await provider.savePassword(context);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
