import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Import speech_to_text package when added manually
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../theme/app_theme.dart';
import '../bloc/search/search_bloc.dart';
import '../bloc/search/search_event.dart';
import '../bloc/search/search_state.dart';

class SearchBarWidget extends StatefulWidget {
  final String hintText;
  final Function(String) onSearch;
  final bool autofocus;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? iconColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final FocusNode? focusNode;
  final String? initialValue;
  
  const SearchBarWidget({
    Key? key,
    this.hintText = 'Search products...',
    required this.onSearch,
    this.autofocus = false,
    this.backgroundColor,
    this.textColor,
    this.hintColor,
    this.iconColor,
    this.padding,
    this.borderRadius,
    this.focusNode,
    this.initialValue,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late final TextEditingController _searchController;
  // Will be initialized when speech_to_text is added
  late stt.SpeechToText _speech;
  bool _isListening = false;
  
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialValue);
    // Initialize speech when package is added
    _speech = stt.SpeechToText();
    _initSpeech();
  }
  
  // This will be implemented when speech_to_text is added
  void _initSpeech() async {
    await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() {
            _isListening = false;
          });
        }
      },
      onError: (errorNotification) {
        setState(() {
          _isListening = false;
        });
        _showErrorDialog(errorNotification.errorMsg);
      },
    );
  }
  
  void _startListening() async {
    FocusScope.of(context).unfocus();
    
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
          onResult: (result) {
            setState(() {
              _searchController.text = result.recognizedWords;
              if (result.finalResult) {
                _isListening = false;
                if (_searchController.text.isNotEmpty) {
                  widget.onSearch(_searchController.text);
                }
              }
            });
          },
        );
      } else {
        _showErrorDialog('Speech recognition is not available on this device');
      }
    } else {
      setState(() {
        _isListening = false;
        _speech.stop();
      });
    }
  }
  
  void _performSearch() {
    if (_searchController.text.isNotEmpty) {
      widget.onSearch(_searchController.text);
      FocusScope.of(context).unfocus();
    }
  }
  
  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Voice Recognition Error'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  @override
  void didUpdateWidget(SearchBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue && 
        widget.initialValue != _searchController.text) {
      _searchController.text = widget.initialValue ?? '';
    }
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    // Will be uncommented when speech_to_text is added
    _speech.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    print('-----------------search build---------------');
    // Default colors based on theme
    final backgroundColor = widget.backgroundColor ?? 
        (isDark ? Colors.grey[800] : Colors.grey[100]);
    final textColor = widget.textColor ?? 
        (isDark ? Colors.white : Colors.black87);
    final hintColor = widget.hintColor ?? 
        (isDark ? Colors.grey[400] : Colors.grey[500]);
    final iconColor = widget.iconColor ?? 
        (isDark ? Colors.grey[300] : Colors.grey[600]);
    
    return BlocConsumer<SearchBloc, SearchState>(
      listenWhen: (previous, current) => 
        current.hasError || 
        (previous.voiceStatus != current.voiceStatus && current.voiceStatus == VoiceSearchStatus.error),
      listener: (context, state) {
        if (state.hasError) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Voice Recognition Error'),
              content: Text(state.errorMessage!),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      },
      builder: (context, state) {
        return 
            Container(
              padding:EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(30),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: iconColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: widget.focusNode,
                      style: TextStyle(color: textColor),
                      autofocus: widget.autofocus,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: TextStyle(color: hintColor),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      textInputAction: TextInputAction.search,
                      onChanged: (value) {
                        context.read<SearchBloc>().add(SearchQueryChanged(value));
                      },
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          context.read<SearchBloc>().add(SearchSubmitted(value));
                          widget.onSearch(value);
                          FocusScope.of(context).unfocus();
                        }
                      },
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        context.read<SearchBloc>().add(SearchCleared());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.close,
                          color: iconColor,
                          size: 18,
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      if (state.isVoiceSearchActive) {
                        context.read<SearchBloc>().add(VoiceSearchStopped());
                      } else {
                        context.read<SearchBloc>().add(VoiceSearchStarted());
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        state.isVoiceSearchActive ? Icons.mic : Icons.mic_none,
                        color: state.isVoiceSearchActive 
                            ? AppTheme.primaryColor 
                            : iconColor,
                        size: 20,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_searchController.text.isNotEmpty) {
                        context.read<SearchBloc>().add(SearchSubmitted(_searchController.text));
                        widget.onSearch(_searchController.text);
                        FocusScope.of(context).unfocus();
                      }
                    },
                    child: Container(
                      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),child: Icon(
                        Icons.search_rounded,
                        color: AppTheme.primaryColor,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            );
      },
    );
  }
} 