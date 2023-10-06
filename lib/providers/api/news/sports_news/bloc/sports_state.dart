import 'package:equatable/equatable.dart';
import 'package:social_app/providers/api/news/sports_news/model/sports_model.dart';

abstract class SportsState extends Equatable {
  const SportsState();

  @override
  List<Object> get props => [];
}

class SportsInitial extends SportsState {}

class SportsLoading extends SportsState {}

class SportsLoaded extends SportsState {
  final SportsModel sportsModel;
  const SportsLoaded(this.sportsModel);
}

class SportsError extends SportsState {
  final String? errorMessage;
  const SportsError(this.errorMessage);
}
