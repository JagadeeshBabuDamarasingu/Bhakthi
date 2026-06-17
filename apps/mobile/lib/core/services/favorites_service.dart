import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  FavoritesService._();
  static final FavoritesService instance = FavoritesService._();

  static const _deityKey = 'fav_deities';
  static const _stotraKey = 'fav_stotras';

  Set<String> _deities = {};
  Set<String> _stotras = {};

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _deities = (prefs.getStringList(_deityKey) ?? []).toSet();
    _stotras = (prefs.getStringList(_stotraKey) ?? []).toSet();
  }

  bool isDeityFavorited(String id) => _deities.contains(id);
  bool isStotraFavorited(String id) => _stotras.contains(id);

  List<String> get favoritedDeityIds => _deities.toList();
  List<String> get favoritedStotraIds => _stotras.toList();

  Future<void> toggleDeity(String id) async {
    if (_deities.contains(id)) {
      _deities.remove(id);
    } else {
      _deities.add(id);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_deityKey, _deities.toList());
  }

  Future<void> toggleStotra(String id) async {
    if (_stotras.contains(id)) {
      _stotras.remove(id);
    } else {
      _stotras.add(id);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_stotraKey, _stotras.toList());
  }
}
