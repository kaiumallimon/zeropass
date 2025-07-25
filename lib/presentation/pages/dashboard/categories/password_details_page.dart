import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zeropass/presentation/providers/detailed_password_provider.dart';
import 'package:zeropass/shared/widgets/custom_textfield.dart';

class PasswordDetailsPage extends StatefulWidget {
  const PasswordDetailsPage({super.key, required this.passwordData});

  final Map<String, dynamic> passwordData;

  @override
  State<PasswordDetailsPage> createState() => _PasswordDetailsPageState();
}

class _PasswordDetailsPageState extends State<PasswordDetailsPage> {
  bool _initialized = false;
  late DetailedPasswordProvider _provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _provider = context.read<DetailedPasswordProvider>();
      _provider.setInitialData(widget.passwordData);
      _initialized = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        toolbarHeight: 80,
        title: Text('${widget.passwordData['name']} Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.passwordData['from'] == 'home') {
              context.go('/home');
            } else {
              context.pop();
            }
          },
        ),
        actions: [
          Consumer<DetailedPasswordProvider>(
            builder: (context, provider, child) {
              return IconButton(
                onPressed: () async {
                  if (provider.isEditable) {
                    await provider.updatePassword(widget.passwordData['id']);
                    provider.makeEditable(false);
                    context.pop();
                  } else {
                    provider.makeEditable(true);
                    provider.setInitialData(widget.passwordData);
                  }
                },
                icon: Icon(
                  provider.isEditable ? Icons.check : Icons.edit,
                  color: theme.colorScheme.primary,
                ),
              );
            },
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Consumer<DetailedPasswordProvider>(
            builder: (context, provider, child) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Name',
                      hintText: widget.passwordData['name'] ?? 'Enter name',
                      keyboardType: TextInputType.text,
                      isEditable: provider.isEditable,
                      controller: provider.nameController,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      label: 'Url',
                      hintText: widget.passwordData['url'] ?? 'N/A',
                      keyboardType: TextInputType.text,
                      isEditable: provider.isEditable,
                      controller: provider.urlController,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      label: 'Username/Email',
                      hintText: widget.passwordData['username'] ?? 'N/A',
                      keyboardType: TextInputType.text,
                      isEditable: provider.isEditable,
                      controller: provider.usernameController,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      label: 'Password',
                      hintText: widget.passwordData['password'] ?? 'N/A',
                      keyboardType: TextInputType.text,
                      isEditable: provider.isEditable,
                      controller: provider.passwordController,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      label: 'Note',
                      hintText: widget.passwordData['note'] ?? 'N/A',
                      keyboardType: TextInputType.text,
                      isEditable: provider.isEditable,
                      height: 150,
                      isExpandable: true,
                      controller: provider.noteController,
                    ),
                    const SizedBox(height: 20),

                    // CustomButton(
                    //   text: 'Update Password',
                    //   width: double.infinity,
                    //   onPressed: provider.isEditable
                    //       ? () async {
                    //           await provider.updatePassword(
                    //             widget.passwordData['id'],
                    //           );
                    //           provider.makeEditable(false);
                    //           ScaffoldMessenger.of(context).showSnackBar(
                    //             const SnackBar(
                    //               content: Text('Password updated!'),
                    //             ),
                    //           );
                    //         }
                    //       : null,
                    // ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
