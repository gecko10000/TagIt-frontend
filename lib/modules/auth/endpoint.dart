import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/common/extension/build_context.dart';
import 'package:tagit_frontend/model/api/base.dart';
import 'package:tagit_frontend/modules/auth/endpoint_model.dart';

class EndpointScreen extends ConsumerStatefulWidget {
  // The exception that led the app to open this screen.
  final Object? exception;

  const EndpointScreen({this.exception, super.key});

  @override
  ConsumerState<EndpointScreen> createState() => _EndpointScreenState();
}

class _EndpointScreenState extends ConsumerState<EndpointScreen> {
  final controller = TextEditingController(text: accountBox.get("host"));

  // This boolean indicates whether to show
  // the indicator ahead of the text field
  bool endpointChecked = false;

  void checkEndpoint() {
    ref.read(endpointProvider.notifier).state = controller.text;
    setState(() {
      endpointChecked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Center(
                child: Column(
      children: [
        Row(children: [
          Expanded(
              child: TextField(
            controller: controller,
            onChanged: (s) {
              // greys out the continue button
              ref.read(endpointProvider.notifier).state = "";
              setState(() => endpointChecked = false);
            },
            onSubmitted: (s) => checkEndpoint(),
          )),
          endpointChecked
              ? _EndpointValidityIndicator()
              : TextButton(
                  onPressed: checkEndpoint, child: const Text("Verify")),
        ]),
        TextButton(
            // only make the button clickable
            // when backendInfo is present
            onPressed: ref.watch(multiUrlBackendInfoProvider).whenOrNull(
                data: (info) => () => submitEndpoint(context, info)),
            child: const Text("Continue")),
      ],
    ))));
  }

  @override
  void initState() {
    super.initState();
    if (widget.exception != null) {
      Future(() => context.showTextSnackBar(widget.exception!.toString()));
    }
  }
}

class _EndpointValidityIndicator extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
        height: 48,
        width: 48,
        child: ref.watch(multiUrlBackendInfoProvider).when(
            data: (data) {
              final (info, url) = data;
              return Tooltip(
                  message: "$url\nVersion ${info.version}\n${info.users} users",
                  child: const Icon(Icons.check_circle, color: Colors.green));
            },
            error: (ex, st) {
              final error = ex is NoEndpointFoundException
                  ? "Tried Endpoints:\n${ex.triedEndpoints.join("\n")}"
                  : ex.toString();
              return Tooltip(
                  message: error,
                  child: const Icon(Icons.error, color: Colors.red));
            },
            loading: () => const Center(child: CircularProgressIndicator())));
  }
}
