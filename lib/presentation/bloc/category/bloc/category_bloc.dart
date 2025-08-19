import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_expenses/data/repositories/categories_repository.dart';
import 'package:share_expenses/presentation/bloc/category/bloc/category_event.dart';
import 'package:share_expenses/presentation/bloc/category/bloc/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;

  CategoryBloc(this.repository) : super(CategoryInitial()) {
    // Load
    on<LoadCategories>((event, emit) async {
      emit(CategoryLoading());
      try {
        final categories = await repository.getAllCategories();
        emit(CategoryLoaded(categories));
        print(categories);
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    // Add
    on<AddCategory>((event, emit) async {
      if (state is CategoryLoaded) {
        try {
          await repository.addCategory(event.category);
          final categories = await repository.getAllCategories();
          emit(CategoryLoaded(categories));
        } catch (e) {
          emit(CategoryError(e.toString()));
        }
      }
    });

    // Update
    on<UpdateCategory>((event, emit) async {
      if (state is CategoryLoaded) {
        try {
          await repository.updateCategory(event.category);
          final categories = await repository.getAllCategories();
          emit(CategoryLoaded(categories));
        } catch (e) {
          emit(CategoryError(e.toString()));
        }
      }
    });

    // Delete
    on<DeleteCategory>((event, emit) async {
      if (state is CategoryLoaded) {
        try {
          await repository.deleteCategory(event.id.toString());
          final categories = await repository.getAllCategories();
          emit(CategoryLoaded(categories));
        } catch (e) {
          emit(CategoryError(e.toString()));
        }
      }
    });
  }
}
