import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/models.dart';

/// Loads bundled JSON content from assets. All results are cached in memory
/// so asset parsing only happens once per session.
class ContentRepository {
  ContentRepository._();
  static final ContentRepository instance = ContentRepository._();

  final Map<String, Deity> _deities = {};
  final Map<String, Stotra> _stotras = {};
  final Map<String, Festival> _festivals = {};
  final Map<String, PujaGuide> _pujaGuides = {};
  final Map<String, VratRule> _vratRules = {};

  // ---------------------------------------------------------------------------
  // Deities
  // ---------------------------------------------------------------------------

  Future<Deity> getDeity(String id) async {
    return _deities[id] ??= Deity.fromJson(
      await _loadJson('assets/content/deities/$id.json'),
    );
  }

  Future<List<Deity>> listDeities() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final paths = manifest
        .listAssets()
        .where((p) =>
            p.startsWith('assets/content/deities/') && p.endsWith('.json'))
        .toList();
    return Future.wait(paths.map((p) {
      final id = p.split('/').last.replaceAll('.json', '');
      return getDeity(id);
    }));
  }

  // ---------------------------------------------------------------------------
  // Stotras
  // ---------------------------------------------------------------------------

  Future<Stotra> getStotra(String id) async {
    return _stotras[id] ??= Stotra.fromJson(
      await _loadJson('assets/content/stotras/$id.json'),
    );
  }

  /// Returns all stotras listed under a deity's [stotras] field.
  Future<List<Stotra>> listStotrasForDeity(String deityId) async {
    final deity = await getDeity(deityId);
    return Future.wait(deity.stotras.map(getStotra));
  }

  Future<List<Stotra>> listAllStotras() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final paths = manifest
        .listAssets()
        .where((p) =>
            p.startsWith('assets/content/stotras/') && p.endsWith('.json'))
        .toList();
    return Future.wait(paths.map((p) {
      final id = p.split('/').last.replaceAll('.json', '');
      return getStotra(id);
    }));
  }

  // ---------------------------------------------------------------------------
  // Festivals
  // ---------------------------------------------------------------------------

  Future<Festival> getFestival(String id) async {
    return _festivals[id] ??= Festival.fromJson(
      await _loadJson('assets/content/festivals/$id.json'),
    );
  }

  Future<List<Festival>> listFestivalsForDeity(String deityId) async {
    final deity = await getDeity(deityId);
    return Future.wait(deity.festivals.map(getFestival));
  }

  Future<List<Festival>> listAllFestivals() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final paths = manifest
        .listAssets()
        .where((p) =>
            p.startsWith('assets/content/festivals/') && p.endsWith('.json'))
        .toList();
    return Future.wait(paths.map((p) {
      final id = p.split('/').last.replaceAll('.json', '');
      return getFestival(id);
    }));
  }

  // ---------------------------------------------------------------------------
  // Puja Guides
  // ---------------------------------------------------------------------------

  Future<PujaGuide> getPujaGuide(String id) async {
    return _pujaGuides[id] ??= PujaGuide.fromJson(
      await _loadJson('assets/content/puja_guides/$id.json'),
    );
  }

  Future<PujaGuide?> getPujaGuideForDeity(String deityId) async {
    final deity = await getDeity(deityId);
    if (deity.pujaGuide == null) return null;
    return getPujaGuide(deity.pujaGuide!);
  }

  Future<List<PujaGuide>> listAllPujaGuides() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final paths = manifest
        .listAssets()
        .where((p) =>
            p.startsWith('assets/content/puja_guides/') && p.endsWith('.json'))
        .toList();
    return Future.wait(paths.map((p) {
      final id = p.split('/').last.replaceAll('.json', '');
      return getPujaGuide(id);
    }));
  }

  // ---------------------------------------------------------------------------
  // Vrat Rules
  // ---------------------------------------------------------------------------

  Future<VratRule> getVratRule(String id) async {
    return _vratRules[id] ??= VratRule.fromJson(
      await _loadJson('assets/content/vrat_rules/$id.json'),
    );
  }

  Future<List<VratRule>> listAllVratRules() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final paths = manifest
        .listAssets()
        .where((p) =>
            p.startsWith('assets/content/vrat_rules/') && p.endsWith('.json'))
        .toList();
    return Future.wait(paths.map((p) {
      final id = p.split('/').last.replaceAll('.json', '');
      return getVratRule(id);
    }));
  }

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> _loadJson(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    return jsonDecode(raw) as Map<String, dynamic>;
  }
}
