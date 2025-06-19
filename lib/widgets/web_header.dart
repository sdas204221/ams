// ignore: avoid_web_libraries_in_flutter
import 'dart:ui' as html;
import 'dart:js' as js;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WebHeader extends StatefulWidget {
  final ThemeData theme;
  final List<String> roles;
  final VoidCallback onLogout;

  const WebHeader({
    super.key,
    required this.theme,
    required this.roles,
    required this.onLogout,
  });

  @override
  State<WebHeader> createState() => _WebHeaderState();
}

class _WebHeaderState extends State<WebHeader> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final usernames =
          await Provider.of<UserProvider>(
            context,
            listen: false,
          ).getAllUsernames();
      setState(() {
        _suggestions = usernames ?? [];
      });
    });
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (_suggestions.contains(query)) {
      Navigator.pushNamed(context, '/profile', arguments: query);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not found')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.theme.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
  onPressed: () {
  if (kIsWeb) {
    // Only works on Flutter Web
    // Use `dart:html` only inside this block
    // So avoid global import error
    // ignore: avoid_web_libraries_in_flutter
    // import 'dart:html' as html;
    // ignore: deprecated_member_use
    js.context.callMethod('open', ['https://brsnc.in/']);
  } else {
    // Optionally handle mobile/desktop with url_launcher
  }
},
  child: Text(
    'BRSNC Alumni Association',
    style: widget.theme.textTheme.headlineMedium?.copyWith(
      color: Colors.white,
    ),
  ),
)
,
              Row(
                children: [
                  Tooltip(
                    message: 'Account',
                    child: IconButton(
                      icon: const Icon(
                        Icons.account_circle_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pushNamed(context, '/account'),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Tooltip(
                    message: 'Logout',
                    child: IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: widget.onLogout,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Top Row: Title + Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title
              Text(
                'Home',
                style: widget.theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 50),
              // Menu + Logout
              Expanded(
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return _suggestions.where(
                      (u) => u.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      ),
                    );
                  },
                  onSelected: (String selection) {
                    _searchController.text = selection;
                    _onSearch();
                  },
                  fieldViewBuilder: (
                    context,
                    controller,
                    focusNode,
                    onEditingComplete,
                  ) {
                    _searchController.text = controller.text;
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      onEditingComplete: onEditingComplete,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search user profile',
                        hintStyle: const TextStyle(color: Colors.white70),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search, color: Colors.white),
                          onPressed: _onSearch,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 50),
              Row(
                children: [
                  if (widget.roles.contains('admin') ||
                      widget.roles.contains('moderator')) ...[
                    _buildNavButton(
                      context,
                      'Approve Listings',
                      '/admin/approve-listings',
                    ),
                    _buildNavButton(
                      context,
                      'Approve Users',
                      '/admin/approve-users',
                    ),
                    _buildNavButton(
                      context,
                      'Assign Roles',
                      '/admin/assign-roles',
                    ),
                  ],
                  // const SizedBox(width: 12),
                  // Tooltip(
                  //   message: 'Account',
                  //   child: IconButton(
                  //     icon: const Icon(Icons.account_circle_outlined, color: Colors.white),
                  //     onPressed: () => Navigator.pushNamed(context, '/account'),
                  //   ),
                  // ),
                  // const SizedBox(width: 6),
                  // Tooltip(
                  //   message: 'Logout',
                  //   child: IconButton(
                  //     icon: const Icon(Icons.logout, color: Colors.white),
                  //     onPressed: widget.onLogout,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),

          // Search Bar
          //const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String title, String route) {
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, route),
      child: Text(title, style: const TextStyle(color: Colors.white)),
    );
  }
}
