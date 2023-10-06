import 'package:bloc/bloc.dart';
import 'package:social_app/providers/api/news/sports_news/bloc/sports_event.dart';
import 'package:social_app/providers/api/news/sports_news/bloc/sports_state.dart';
import 'package:social_app/providers/api/news/sports_news/provider/sports_api_repository.dart';

class SportsBloc extends Bloc<SportsEvent, SportsState> {
  SportsBloc() : super(SportsInitial()) {
    final SportsApiRepository apiRespository = SportsApiRepository();

    // Gets List of Sport News
    on<GetSportsList>((event, emit) async {
      try {
        emit(SportsLoading());
        final sportNews = await apiRespository.getSportNews();
        emit(SportsLoaded(sportNews));
        if (sportNews.error != null) {
          emit(SportsError(sportNews.error));
        }
      } on NetworkError {
        emit(const SportsError("Network Error"));
      }
    });
  }
}
