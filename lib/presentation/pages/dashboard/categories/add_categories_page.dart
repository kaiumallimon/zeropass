import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeropass/core/constants/app_strings.dart';
import 'package:zeropass/presentation/providers/add_category_provider.dart';
import 'package:zeropass/shared/widgets/custom_button.dart';
import 'package:zeropass/shared/widgets/custom_textfield.dart';

class AddCategoriesPage extends StatelessWidget {
  const AddCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        toolbarHeight: 80,
        title: Text('Add Category'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.add_category_tip,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(.7),
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Category',
                hintText: "Enter category name",
                keyboardType: TextInputType.text,
                controller: context
                    .read<AddCategoryProvider>()
                    .categoryNameController,
              ),
              const SizedBox(height: 20),
              Consumer<AddCategoryProvider>(
                builder: (context, provider, child) => CustomButton(
                  text: 'Add New Category',
                  isLoading: provider.isLoading,
                  onPressed: () async {
                    await provider.addCategory(context);
                  },
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
