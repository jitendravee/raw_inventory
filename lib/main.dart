import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:raw_material/core/common/theme_notifier.dart';
import 'package:raw_material/features/composition/data/models/composition_model.dart';
import 'package:raw_material/features/composition/data/repositories/composition_repository_impl.dart';
import 'package:raw_material/features/composition/domain/repositories/composition_repository.dart';
import 'package:raw_material/features/composition/presentation/bloc/composition_bloc.dart';
import 'package:raw_material/features/composition/presentation/ui/composition_screen.dart';
import 'package:raw_material/features/inventory/data/datasources/inventory_local_datasource.dart';
import 'package:raw_material/features/inventory/data/datasources/inventory_remote_datasource.dart';
import 'package:raw_material/features/inventory/data/models/inventory_model.dart';
import 'package:raw_material/features/inventory/presentation/ui/inventory_screen.dart';
import 'package:raw_material/features/manufacturing_log/data/datasources/manufacturing_log_local_datasource.dart';
import 'package:raw_material/features/manufacturing_log/data/models/manufacturing_log_model.dart';
import 'package:raw_material/features/manufacturing_log/data/repositories/manufacturing_log_repository_impl.dart';
import 'package:raw_material/features/manufacturing_log/domain/repositories/manufacturing_log_repository.dart';
import 'package:raw_material/features/manufacturing_log/presentation/bloc/manufacturing_log_bloc.dart';
import 'package:raw_material/features/manufacturing_log/presentation/ui/manufacturing_log_screen.dart';

import 'features/inventory/data/repositories/inventory_repository_impl.dart';
import 'features/inventory/domain/repositories/inventory_repository.dart';
import 'features/inventory/presentation/bloc/inventory_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(MaterialModelAdapter());
  await Hive.openBox<MaterialModel>('materials');

  Hive.registerAdapter(CompositionModelAdapter());
  final compositionBox = await Hive.openBox<CompositionModel>('compositions');

  Hive.registerAdapter(ManufacturingLogModelAdapter());
  final logBox =
      await Hive.openBox<ManufacturingLogModel>('manufacturing_logs');

  final logRepo =
      ManufacturingRepositoryImpl(ManufacturingLocalDatasource(logBox));
  final inventoryRepo = InventoryRepositoryImpl(
      HiveInventoryDatasource(),
      SheetsInventoryDatasource(
          'https://script.google.com/macros/s/AKfycbwFAb2cn9l147VxEigaURQQDWNkTFHCtWzU3IVAyMw0ioQT_ZsVun232rNKjWlUvkGu/exec'));
  final compositionRepo = CompositionRepositoryImpl(compositionBox);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: AppWithTheme(
        inventoryRepo: inventoryRepo,
        compositionRepo: compositionRepo,
        manufacturingRepo: logRepo,
      ),
    ),
  );
}

class AppWithTheme extends StatelessWidget {
  final InventoryRepository inventoryRepo;
  final CompositionRepository compositionRepo;
  final ManufacturingRepository manufacturingRepo;

  const AppWithTheme({
    super.key,
    required this.inventoryRepo,
    required this.compositionRepo,
    required this.manufacturingRepo,
  });

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<InventoryRepository>(create: (_) => inventoryRepo),
        RepositoryProvider<CompositionRepository>(
            create: (_) => compositionRepo),
        RepositoryProvider<ManufacturingRepository>(
            create: (_) => manufacturingRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<InventoryBloc>(
              create: (_) => InventoryBloc(inventoryRepo)),
          BlocProvider<CompositionBloc>(
              create: (_) => CompositionBloc(compositionRepo)),
          BlocProvider<ManufacturingBloc>(
            create: (_) => ManufacturingBloc(
                manufacturingRepo, compositionRepo, inventoryRepo),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Raw Material Tracker',
          themeMode: themeNotifier.themeMode,
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          home: const MyHomePage(title: 'Raw Material Dashboard'),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
            },
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildNavigationCard(
              context,
              title: 'Inventory',
              subtitle: 'View and update available raw materials',
              icon: Icons.inventory_2,
              destination: InventoryScreen(),
            ),
            const SizedBox(height: 16),
            _buildNavigationCard(
              context,
              title: 'Manufacturing Log',
              subtitle: 'Add or view manufacturing records',
              icon: Icons.factory,
              destination: ManufacturingScreen(),
            ),
            const SizedBox(height: 16),
            _buildNavigationCard(
              context,
              title: 'Composition',
              subtitle: 'Manage product compositions',
              icon: Icons.scatter_plot,
              destination: CompositionScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget destination,
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => destination),
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: ListTile(
          contentPadding: const EdgeInsets.all(20),
          leading: Icon(icon,
              size: 40, color: Theme.of(context).colorScheme.primary),
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
