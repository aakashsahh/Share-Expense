import 'package:share_expenses/data/datasources/local/category_local_datasource.dart';
import 'package:share_expenses/data/models/category_model.dart';

abstract class CategoryRepository {
  Future<List<Category>> getAllCategories();
  Future<Category?> getCategoryById(String id);
  Future<void> addCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(String id);
  Future<void> initDefaultCategories();
}

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl(this.localDataSource);

  @override
  Future<List<Category>> getAllCategories() async {
    return await localDataSource.getAllCategories();
  }

  @override
  Future<Category?> getCategoryById(String id) async {
    return await localDataSource.getCategoryById(id);
  }

  @override
  Future<void> addCategory(Category category) async {
    await localDataSource.addCategory(category);
  }

  @override
  Future<void> updateCategory(Category category) async {
    await localDataSource.updateCategory(category);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await localDataSource.deleteCategory(id);
  }

  @override
  Future<void> initDefaultCategories() async {
    await localDataSource.initDefaultCategories();
  }
}
