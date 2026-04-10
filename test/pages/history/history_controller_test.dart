import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_ai_workflow/pages/history/history_controller.dart';

void main() {
  group('HistoryController Tests', () {
    late HistoryController historyController;

    setUp(() {
      // Initialize flutter test binding
      TestWidgetsFlutterBinding.ensureInitialized();
      // Initialize GetX before each test
      Get.testMode = true;
      historyController = HistoryController();
    });

    tearDown(() {
      // Clean up after each test
      historyController.onClose();
      Get.reset();
    });

    // Test 1: Initial state verification
    group('Initial State Tests', () {
      test('historyItems should be empty initially before onInit', () {
        expect(historyController.historyItems.isEmpty, true);
      });

      test('isLoading should be false initially', () {
        expect(historyController.isLoading.value, false);
      });

      test('filterStatus should be "all" initially', () {
        expect(historyController.filterStatus.value, 'all');
      });

      test('searchQuery should be empty initially', () {
        expect(historyController.searchQuery.value, '');
      });
    });

    // Test 2: Load history data
    group('Load History Data Tests', () {
      test('should load history items on init', () async {
        historyController.onInit();
        
        // Tunggu hingga loading selesai
        await Future.delayed(const Duration(milliseconds: 600));
        
        expect(historyController.historyItems.isNotEmpty, true);
        expect(historyController.historyItems.length, 6);
      });

      test('historyItems should contain valid data', () async {
        historyController.onInit();
        await Future.delayed(const Duration(milliseconds: 600));
        
        final firstItem = historyController.historyItems.first;
        expect(firstItem.id, isNotEmpty);
        expect(firstItem.title, isNotEmpty);
        expect(firstItem.description, isNotEmpty);
        expect(firstItem.status, isNotEmpty);
      });
    });

    // Test 3: Filter status functionality
    group('Filter Status Tests', () {
      setUp(() async {
        historyController.onInit();
        await Future.delayed(const Duration(milliseconds: 600));
      });

      test('should update filterStatus when setFilter is called', () {
        historyController.setFilter('completed');
        expect(historyController.filterStatus.value, 'completed');
      });

      test('should filter items by status', () {
        historyController.setFilter('completed');
        final filtered = historyController.filteredItems;
        
        for (final item in filtered) {
          expect(item.status, 'completed');
        }
      });

      test('should show all items when filter is "all"', () {
        historyController.setFilter('all');
        final filtered = historyController.filteredItems;
        
        expect(filtered.length, historyController.historyItems.length);
      });

      test('should filter by pending status', () {
        historyController.setFilter('pending');
        final filtered = historyController.filteredItems;
        
        for (final item in filtered) {
          expect(item.status, 'pending');
        }
      });

      test('should filter by in_progress status', () {
        historyController.setFilter('in_progress');
        final filtered = historyController.filteredItems;
        
        for (final item in filtered) {
          expect(item.status, 'in_progress');
        }
      });
    });

    // Test 4: Search functionality
    group('Search History Tests', () {
      setUp(() async {
        historyController.onInit();
        await Future.delayed(const Duration(milliseconds: 600));
      });

      test('should update searchQuery when searchHistory is called', () {
        historyController.searchHistory('test');
        expect(historyController.searchQuery.value, 'test');
      });

      test('should search by title', () {
        historyController.searchHistory('Pembelian');
        final filtered = historyController.filteredItems;
        
        expect(filtered.isNotEmpty, true);
        for (final item in filtered) {
          expect(
            item.title.toLowerCase().contains('pembelian'),
            true,
          );
        }
      });

      test('should search by description', () {
        historyController.searchHistory('berhasil');
        final filtered = historyController.filteredItems;
        
        expect(filtered.isNotEmpty, true);
      });

      test('should be case insensitive search', () {
        historyController.searchHistory('PEMBELIAN');
        final filtered = historyController.filteredItems;
        
        expect(filtered.isNotEmpty, true);
      });

      test('should return empty when search has no match', () {
        historyController.searchHistory('nonexistent');
        final filtered = historyController.filteredItems;
        
        expect(filtered.isEmpty, true);
      });
    });

    // Test 5: Combined filter and search
    group('Combined Filter and Search Tests', () {
      setUp(() async {
        historyController.onInit();
        await Future.delayed(const Duration(milliseconds: 600));
      });

      test('should filter by status and search simultaneously', () {
        historyController.setFilter('completed');
        historyController.searchHistory('Pembelian');
        final filtered = historyController.filteredItems;
        
        for (final item in filtered) {
          expect(item.status, 'completed');
          expect(
            item.title.toLowerCase().contains('pembelian') ||
            item.description.toLowerCase().contains('pembelian'),
            true,
          );
        }
      });

      test('should clear search and keep filter', () {
        historyController.setFilter('completed');
        historyController.searchHistory('Pembelian');
        historyController.searchHistory('');
        final filtered = historyController.filteredItems;
        
        for (final item in filtered) {
          expect(item.status, 'completed');
        }
      });
    });

    // Test 6: Status color and label
    group('Status Color and Label Tests', () {
      test('should return correct color for completed status', () {
        expect(historyController.getStatusColor('completed'), '#4CAF50');
      });

      test('should return correct color for in_progress status', () {
        expect(historyController.getStatusColor('in_progress'), '#FF9800');
      });

      test('should return correct color for pending status', () {
        expect(historyController.getStatusColor('pending'), '#2196F3');
      });

      test('should return correct color for cancelled status', () {
        expect(historyController.getStatusColor('cancelled'), '#F44336');
      });

      test('should return correct label for completed status', () {
        expect(historyController.getStatusLabel('completed'), 'Selesai');
      });

      test('should return correct label for in_progress status', () {
        expect(historyController.getStatusLabel('in_progress'), 'Proses');
      });

      test('should return correct label for pending status', () {
        expect(historyController.getStatusLabel('pending'), 'Menunggu');
      });

      test('should return correct label for cancelled status', () {
        expect(historyController.getStatusLabel('cancelled'), 'Dibatalkan');
      });
    });

    // Test 7: Refresh history
    group('Refresh History Tests', () {
      test('should clear and reload history items', () async {
        historyController.onInit();
        await Future.delayed(const Duration(milliseconds: 600));
        
        final initialCount = historyController.historyItems.length;
        
        await historyController.refreshHistory();
        await Future.delayed(const Duration(milliseconds: 600));
        
        expect(historyController.historyItems.length, initialCount);
      });

      test('should set isLoading to true during refresh', () async {
        historyController.onInit();
        
        final future = historyController.refreshHistory();
        // Check immediately after calling refresh
        expect(historyController.isLoading.value, true);
        
        await future;
      });
    });

    // Test 8: Delete history item
    group('Delete History Item Tests', () {
      setUp(() async {
        historyController.onInit();
        await Future.delayed(const Duration(milliseconds: 600));
      });

      test('should delete item by id', () {
        final initialCount = historyController.historyItems.length;
        final firstItemId = historyController.historyItems.first.id;
        
        historyController.deleteHistoryItem(firstItemId);
        
        expect(historyController.historyItems.length, initialCount - 1);
        expect(
          historyController.historyItems.any((item) => item.id == firstItemId),
          false,
        );
      });

      test('should not affect other items when deleting one', () {
        final secondItemId = historyController.historyItems[1].id;
        final secondItemTitle = historyController.historyItems[1].title;
        
        historyController.deleteHistoryItem(historyController.historyItems.first.id);
        
        final stillExists = historyController.historyItems.any(
          (item) => item.id == secondItemId && item.title == secondItemTitle,
        );
        expect(stillExists, true);
      });
    });

    // Test 9: Clear all history
    group('Clear All History Tests', () {
      setUp(() async {
        historyController.onInit();
        await Future.delayed(const Duration(milliseconds: 600));
      });

      test('should clear all history items', () async {
        expect(historyController.historyItems.isNotEmpty, true);
        
        await historyController.clearAllHistory();
        
        expect(historyController.historyItems.isEmpty, true);
      });
    });

    // Test 10: Filtered items sorting
    group('Filtered Items Sorting Tests', () {
      setUp(() async {
        historyController.onInit();
        await Future.delayed(const Duration(milliseconds: 600));
      });

      test('should sort filtered items by date descending', () {
        final filtered = historyController.filteredItems;
        
        for (int i = 0; i < filtered.length - 1; i++) {
          expect(
            filtered[i].date.isAfter(filtered[i + 1].date) ||
            filtered[i].date.isAtSameMomentAs(filtered[i + 1].date),
            true,
          );
        }
      });

      test('should maintain sorting after filter change', () {
        historyController.setFilter('completed');
        final filtered = historyController.filteredItems;
        
        for (int i = 0; i < filtered.length - 1; i++) {
          expect(
            filtered[i].date.isAfter(filtered[i + 1].date) ||
            filtered[i].date.isAtSameMomentAs(filtered[i + 1].date),
            true,
          );
        }
      });
    });

    // Test 11: Observable reactivity
    group('Observable Reactivity Tests', () {
      setUp(() async {
        historyController.onInit();
        await Future.delayed(const Duration(milliseconds: 600));
      });

      test('historyItems should be observable', () {
        expect(historyController.historyItems, isA<RxList>());
      });

      test('isLoading should be observable', () {
        expect(historyController.isLoading, isA<RxBool>());
      });

      test('filterStatus should be observable', () {
        expect(historyController.filterStatus, isA<RxString>());
      });

      test('searchQuery should be observable', () {
        expect(historyController.searchQuery, isA<RxString>());
      });
    });

    // Test 12: HistoryItem model
    group('HistoryItem Model Tests', () {
      test('should create HistoryItem with all properties', () {
        final item = HistoryItem(
          id: '1',
          title: 'Test',
          description: 'Test description',
          date: DateTime.now(),
          status: 'completed',
          icon: 'shopping_bag',
        );
        
        expect(item.id, '1');
        expect(item.title, 'Test');
        expect(item.description, 'Test description');
        expect(item.status, 'completed');
        expect(item.icon, 'shopping_bag');
      });

      test('should have all required properties', () {
        final item = HistoryItem(
          id: 'test-id',
          title: 'Test Title',
          description: 'Test Description',
          date: DateTime(2026, 4, 10),
          status: 'pending',
          icon: 'history',
        );
        
        expect(item.id, isNotEmpty);
        expect(item.title, isNotEmpty);
        expect(item.description, isNotEmpty);
        expect(item.date, isNotNull);
        expect(item.status, isNotEmpty);
        expect(item.icon, isNotEmpty);
      });
    });
  });
}
