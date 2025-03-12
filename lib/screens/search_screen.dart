import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/search_bar_widget.dart';
import '../bloc/search/search_bloc.dart';
import '../bloc/search/search_event.dart';
import '../bloc/search/search_state.dart';

class SearchScreen extends StatefulWidget {
  final String initialQuery;
  
  const SearchScreen({
    Key? key, 
    this.initialQuery = '',
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  late final SearchBloc _searchBloc;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _searchFocusNode = FocusNode();
    _searchBloc = SearchBloc();

    // Process initial query if provided
    if (widget.initialQuery.isNotEmpty) {
      _performSearch(widget.initialQuery);
      _searchBloc.add(SearchQueryChanged(widget.initialQuery));
    }
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchBloc.close();
    super.dispose();
  }
  
  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // In a real app, this would be an API call to fetch search results
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  void _handleBackPress() {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchBloc,
      child: Scaffold(
        appBar: AppBar(
          title: SearchBarWidget(
            hintText: 'Search for clothes, shoes, etc.',
            onSearch: (query) {
              _searchBloc.add(SearchQueryChanged(query));
              _performSearch(query);
            },
            initialValue: _searchController.text,
            focusNode: _searchFocusNode,
            autofocus: _searchController.text.isEmpty,
          ),
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBackPress,
          ),
        ),
        body: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchController.text.isEmpty) {
      return const Center(
        child: Text('Start typing to search products'),
      );
    }

    // This would display actual results from an API in a real app
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Searched for "${_searchController.text}"',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'In a real app, search results would appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }
} 