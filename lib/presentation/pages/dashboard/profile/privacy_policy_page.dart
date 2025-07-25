import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: theme.colorScheme.surface,
        toolbarHeight: 80,
        title: const Text('Privacy Policy'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedShield01,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Your Privacy Matters',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'ZeroPass is committed to protecting your privacy and securing your personal information. This policy explains how we handle your data.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Last updated: July 26, 2025',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Privacy Principles
              _buildSection(theme, 'Our Privacy Principles', [
                _PolicyPoint(
                  'Zero-Knowledge Architecture',
                  'We cannot access your passwords or personal data. Everything is encrypted locally on your device.',
                ),
                _PolicyPoint(
                  'Minimal Data Collection',
                  'We only collect the minimum data necessary to provide our services.',
                ),
                _PolicyPoint(
                  'No Third-Party Sharing',
                  'We never sell, rent, or share your personal information with third parties for marketing purposes.',
                ),
                _PolicyPoint(
                  'Transparency',
                  'We are transparent about our data practices and give you control over your information.',
                ),
              ]),

              // Data Collection
              _buildSection(theme, 'Information We Collect', [
                _PolicyPoint(
                  'Account Information',
                  'Email address and encrypted account credentials for authentication and account recovery.',
                ),
                _PolicyPoint(
                  'Encrypted Vault Data',
                  'Your passwords, notes, and TOTP secrets are encrypted locally before any storage or transmission.',
                ),
                _PolicyPoint(
                  'Usage Analytics',
                  'Anonymous usage statistics to improve the app performance and user experience.',
                ),
                _PolicyPoint(
                  'Device Information',
                  'Basic device information for security purposes and app optimization.',
                ),
              ]),

              // Data Usage
              _buildSection(theme, 'How We Use Your Information', [
                _PolicyPoint(
                  'Service Provision',
                  'To provide, maintain, and improve the ZeroPass password management service.',
                ),
                _PolicyPoint(
                  'Security',
                  'To detect and prevent unauthorized access, fraud, and other security threats.',
                ),
                _PolicyPoint(
                  'Communication',
                  'To send important service updates, security alerts, and respond to support requests.',
                ),
                _PolicyPoint(
                  'Legal Compliance',
                  'To comply with applicable laws, regulations, and legal processes.',
                ),
              ]),

              // Data Security
              _buildSection(theme, 'Data Security & Encryption', [
                _PolicyPoint(
                  'End-to-End Encryption',
                  'All sensitive data is encrypted using AES-256 encryption before leaving your device.',
                ),
                _PolicyPoint(
                  'Local Storage',
                  'Passwords are primarily stored locally on your device using secure storage mechanisms.',
                ),
                _PolicyPoint(
                  'Secure Transmission',
                  'All data transmission uses TLS encryption and industry-standard security protocols.',
                ),
                _PolicyPoint(
                  'Regular Security Audits',
                  'We regularly review and update our security measures to protect against emerging threats.',
                ),
              ]),

              // User Rights
              _buildSection(theme, 'Your Rights & Choices', [
                _PolicyPoint(
                  'Access & Export',
                  'You can access and export your encrypted data at any time through the app settings.',
                ),
                _PolicyPoint(
                  'Data Deletion',
                  'You can delete your account and all associated data permanently from your profile settings.',
                ),
                _PolicyPoint(
                  'Opt-Out',
                  'You can opt out of non-essential communications and analytics collection in settings.',
                ),
                _PolicyPoint(
                  'Portability',
                  'Your data is exportable in standard formats for use with other password managers.',
                ),
              ]),

              // Data Retention
              _buildSection(theme, 'Data Retention', [
                _PolicyPoint(
                  'Active Accounts',
                  'We retain your encrypted data as long as your account remains active.',
                ),
                _PolicyPoint(
                  'Deleted Accounts',
                  'When you delete your account, all data is permanently removed within 30 days.',
                ),
                _PolicyPoint(
                  'Backup Retention',
                  'Encrypted backups may be retained for up to 90 days for disaster recovery purposes.',
                ),
              ]),

              // Third Party Services
              _buildSection(theme, 'Third-Party Services', [
                _PolicyPoint(
                  'Cloud Storage',
                  'If enabled, encrypted backups may be stored with trusted cloud providers (Supabase).',
                ),
                _PolicyPoint(
                  'Analytics',
                  'We may use privacy-focused analytics services to understand app usage patterns.',
                ),
                _PolicyPoint(
                  'No Tracking',
                  'We do not use advertising networks or tracking services that compromise your privacy.',
                ),
              ]),

              // Contact Information
              _buildSection(theme, 'Contact Us', [
                _PolicyPoint(
                  'Privacy Questions',
                  'If you have questions about this privacy policy, contact us at privacy@zeropass.com',
                ),
                _PolicyPoint(
                  'Data Requests',
                  'For data access, correction, or deletion requests, email support@zeropass.com',
                ),
                _PolicyPoint(
                  'Security Issues',
                  'Report security vulnerabilities to security@zeropass.com',
                ),
              ]),

              // Policy Updates
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.onSurface.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Policy Updates',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'We may update this privacy policy from time to time. We will notify you of any material changes by posting the new policy in the app and sending a notification. Your continued use of ZeroPass after such modifications constitutes acceptance of the updated policy.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Footer
              Center(
                child: Text(
                  'ZeroPass - Secure. Private. Yours.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    ThemeData theme,
    String title,
    List<_PolicyPoint> points,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < points.length; i++) ...[
                _buildPolicyPoint(theme, points[i]),
                if (i < points.length - 1) const SizedBox(height: 16),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPolicyPoint(ThemeData theme, _PolicyPoint point) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 6),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    point.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    point.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PolicyPoint {
  final String title;
  final String description;

  _PolicyPoint(this.title, this.description);
}
