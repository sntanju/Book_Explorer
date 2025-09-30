import 'package:dartz/dartz.dart';
import 'package:book_explorer/src/core/data/models/failure.dart';

abstract class IUseCase<TUseCaseInput, TUseCaseOutput> {
  Future<Either<Failure, TUseCaseOutput>> execute(TUseCaseInput input);
}