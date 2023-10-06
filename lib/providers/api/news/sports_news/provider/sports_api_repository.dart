import 'package:social_app/providers/api/news/sports_news/model/sports_model.dart';
import 'package:social_app/providers/api/news/sports_news/provider/sports_api_provider.dart';

class SportsApiRepository {
  final _provider = SportsApiProvider();

  Future<SportsModel> getSportNews() {
    return _provider.getSportNews();
  }
}

class NetworkError extends Error {}
