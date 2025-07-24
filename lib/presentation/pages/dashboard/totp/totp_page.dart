import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zeropass/presentation/pages/dashboard/totp/totp_add_qr_code_page.dart';
import 'package:zeropass/presentation/providers/totp_provider.dart';

class TotpPage extends StatefulWidget {
  const TotpPage({super.key});

  @override
  State<TotpPage> createState() => _TotpPageState();
}

class _TotpPageState extends State<TotpPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TotpProvider>().loadTotpEntries(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // fetch the TOTP entries

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        shadowColor: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surface,
        toolbarHeight: 80,
        title: const Text('Authenticator (TOTP)'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Consumer<TotpProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (provider.errorMessage != null) {
                return Center(child: Text(provider.errorMessage!));
              } else if (provider.totpEntries.isEmpty) {
                return Center(
                  child: Text(
                    'No TOTP entries found. Please add a new entry by clicking the plus button.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(.5),
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  // Row(
                  //   spacing: 10,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Icon(
                  //       Icons.info_outline,
                  //       color: theme.colorScheme.onSurface.withOpacity(.5),
                  //     ),
                  //     Expanded(
                  //       child: Text(
                  //         'Long press on an entry to copy the OTP to clipboard.',
                  //         style: theme.textTheme.bodyMedium?.copyWith(
                  //           color: theme.colorScheme.onSurface.withOpacity(.5),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.totpEntries.length,
                      itemBuilder: (context, index) {
                        final entry = provider.totpEntries[index];
                        final otp =
                            provider.currentOtps[entry.name] ?? '••••••';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Dismissible(
                            background: Container(
                              color: theme.colorScheme.error,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(
                                Icons.delete,
                                color: theme.colorScheme.onError,
                              ),
                            ),
                            key: Key(entry.secret),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) async {
                              await provider.deleteTotpEntry(entry.secret);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  margin: EdgeInsets.all(10),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor:
                                      theme.colorScheme.primaryContainer,
                                  content: Text(
                                    '${entry.name} deleted',
                                    style: TextStyle(
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: ListTile(
                              onLongPress: () {
                                Clipboard.setData(ClipboardData(text: otp));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    margin: EdgeInsets.all(10),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor:
                                        theme.colorScheme.primaryContainer,
                                    content: Text(
                                      'OTP copied to clipboard',
                                      style: TextStyle(
                                        color: theme
                                            .colorScheme
                                            .onPrimaryContainer,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(.1),
                                  width: 1.5,
                                ),
                              ),
                              tileColor: theme.colorScheme.primary.withOpacity(
                                .1,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.issuer == entry.name
                                        ? entry.issuer
                                        : '${entry.issuer} (${(entry.name).split(':').last})',
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    otp,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Consumer<TotpProvider>(
                                builder: (context, provider, _) {
                                  final remaining = provider.secondsRemaining;
                                  final progress = remaining / 30;
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 32,
                                        height: 32,
                                        child: CircularProgressIndicator(
                                          value: progress,
                                          strokeWidth: 4,
                                          color: theme.colorScheme.primary,
                                          backgroundColor: theme
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.1),
                                        ),
                                      ),
                                      Text(
                                        remaining.toString(),
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                height: 180,
                decoration: BoxDecoration(
                  // color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: EdgeInsets.all(20),
                child: Consumer<TotpProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return Center(
                        child: CupertinoActivityIndicator(
                          color: theme.colorScheme.primary,
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: theme.colorScheme.onSurface.withOpacity(
                                .1,
                              ),
                              width: 1.5,
                            ),
                          ),
                          leading: Icon(Icons.qr_code),
                          title: Text('Scan QR Code'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TotpAddQrCodePage(
                                  onScan: (String scannedData) {
                                    print('Scanned Data: $scannedData');
                                    provider.scanQrCode(context, scannedData);
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: theme.colorScheme.onSurface.withOpacity(
                                .1,
                              ),
                              width: 1.5,
                            ),
                          ),
                          leading: Icon(Icons.keyboard),
                          title: Text('Enter Key Manually'),
                          onTap: () {
                            Navigator.pop(context);
                            context.go('/totp/add-manual');
                          },
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
