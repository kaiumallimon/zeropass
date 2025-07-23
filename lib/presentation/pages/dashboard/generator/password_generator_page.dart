import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zeropass/core/constants/app_strings.dart';
import 'package:zeropass/shared/widgets/custom_button.dart';
import 'package:zeropass/utils/password_generator.dart';

class PasswordGeneratorPage extends StatefulWidget {
  const PasswordGeneratorPage({super.key});

  @override
  State<PasswordGeneratorPage> createState() => _PasswordGeneratorPageState();
}

class _PasswordGeneratorPageState extends State<PasswordGeneratorPage> {
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeDigits = true;
  bool _includeSpecialChars = true;
  int _passwordLength = 8;

  String? _generatedPassword;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        shadowColor: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surface,
        toolbarHeight: 80,
        title: const Text('Strong Password Generator'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.passwordGenerateSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(.7),
                  ),
                ),
                const SizedBox(height: 20),
                _buildOptionTile(
                  theme,
                  'Include Uppercase Letters',
                  _includeUppercase,
                  (val) => setState(() => _includeUppercase = val),
                ),
                const SizedBox(height: 15),
                _buildOptionTile(
                  theme,
                  'Include Lowercase Letters',
                  _includeLowercase,
                  (val) => setState(() => _includeLowercase = val),
                ),
                const SizedBox(height: 15),
                _buildOptionTile(
                  theme,
                  'Include Digits',
                  _includeDigits,
                  (val) => setState(() => _includeDigits = val),
                ),
                const SizedBox(height: 15),
                _buildOptionTile(
                  theme,
                  'Include Special Characters',
                  _includeSpecialChars,
                  (val) => setState(() => _includeSpecialChars = val),
                ),
                const SizedBox(height: 15),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  tileColor: theme.colorScheme.primaryContainer.withOpacity(.1),
                  title: const Text('Password Length'),
                  subtitle: Slider(
                    value: _passwordLength.toDouble(),
                    min: 8,
                    max: 32,
                    divisions: 24,
                    label: '$_passwordLength',
                    onChanged: (value) {
                      setState(() {
                        _passwordLength = value.toInt();
                      });
                    },
                  ),
                  trailing: Text(
                    '$_passwordLength',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Generate Password',
                  width: double.infinity,
                  onPressed: () {
                    setState(() {
                      _generatedPassword = PasswordUtils.generateStrongPassword(
                        length: _passwordLength,
                        includeUppercase: _includeUppercase,
                        includeLowercase: _includeLowercase,
                        includeDigits: _includeDigits,
                        includeSpecialChars: _includeSpecialChars,
                      );
                    });
                  },
                ),
                const SizedBox(height: 20),
                if (_generatedPassword != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withOpacity(
                        .15,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Generated Password:',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(.5),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: SelectableText(
                                _generatedPassword!,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: _generatedPassword!),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Password copied!'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Text.rich(
                          TextSpan(
                            text: 'Strength: ',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                .7,
                              ),
                            ),
                            children: [
                              TextSpan(
                                text: PasswordUtils.checkPasswordStrength(
                                  _generatedPassword!,
                                ),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    ThemeData theme,
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: theme.colorScheme.primaryContainer.withOpacity(.1),
      title: Text(title),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}
