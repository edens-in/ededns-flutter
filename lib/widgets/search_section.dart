import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_theme.dart';
import 'search_bar_widget.dart';
import '../bloc/search/search_bloc.dart';
import '../bloc/search/search_event.dart';
import '../bloc/search/search_state.dart';

class SearchSection extends StatefulWidget {
  final Function(String) onSearch;
  final EdgeInsetsGeometry padding;
  
  const SearchSection({
    Key? key,
    required this.onSearch,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  }) : super(key: key);

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  final FocusNode _searchFocusNode = FocusNode();
  late final SearchBloc _searchBloc;
  
  @override
  void initState() {
    super.initState();
    _searchBloc = SearchBloc();
  }
  
  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchBloc.close();
    super.dispose();
  }
  
  void _handleSearch(String query) {
    _searchBloc.add(SearchQueryChanged(query));
    
    if (query.isNotEmpty) {
      widget.onSearch(query);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchBloc,
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return Container(
            padding: widget.padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                SearchBarWidget(
                  hintText: 'Search for clothes, shoes, etc.',
                  onSearch: _handleSearch,
                  focusNode: _searchFocusNode,
                  initialValue: state.query,
                ),
                
                // Show search results when there's a query
                // if (state.query.isNotEmpty && state.status == SearchStatus.active) ...[
                //   const SizedBox(height: 16),
                //   _buildSearchResults(state.query),
                // ],
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildSearchResults(String query) {
    // This would typically show actual search results
    // For this example, we'll just show a placeholder
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Text(
          'Searching for "$query"...',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }
} 