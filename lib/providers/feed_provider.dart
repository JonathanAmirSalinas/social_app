import 'package:flutter/foundation.dart';
import 'package:social_app/services/content_services.dart';

class FeedProvider with ChangeNotifier {
  List<Map<String, dynamic>> _feed = [];
  //List<Map<String, dynamic>> _ref = [];
  late int topTimestamp;
  late int bottomTimestamp;
  bool hasMore = true;

  List<Map<String, dynamic>> get getFeed => _feed;
  //List<Map<String, dynamic>> get getRef => _ref;

  // ?
  Future<void> setFeed() async {}

  //////////////////////////////////////////// Gets initial user feed (50 posts)
  Future<void> getUserFeed() async {
    _feed.clear();
    _feed = await ContentServices().getUserFeed();
    topTimestamp = _feed[0]['timestamp']; // First Post timestamp
    bottomTimestamp =
        _feed[_feed.length - 1]['timestamp']; // Last Post timestamp
    notifyListeners();
  }

  Future<void> refreshPost(String pid) async {
    for (int i = 0; i < _feed.length; i++) {
      if (pid == _feed[i]['id_content']) {
        Map<String, dynamic> updatedPost =
            await ContentServices().getUpdatedPost(pid);
        _feed[i] = updatedPost;
        notifyListeners();
        break;
      }
    }

    notifyListeners();
  }

  //////////////////////////////////// Gets Newest Feed Posts (Top Feed Refresh)
  Future<void> refreshTopFeed(bool newpost) async {
    List<Map<String, dynamic>> newPost = [];
    List<Map<String, dynamic>> newFeed = [];

    // newFeed added to the top of the Feed List
    if (newpost) {
      // TO-DO Compare feed to make sure new post is not added twice
      newFeed = await ContentServices().refreshFeed(5, true, topTimestamp);
      //newPost = await ContentServices().getPost(); Work in Progress
      // newFeed = newPost + newFeed than newFeed.set() or something
    } else {
      newFeed = await ContentServices().refreshFeed(5, true, topTimestamp);
    }
    //
    _feed = newPost + newFeed + _feed;
    // refresh top timestamp
    topTimestamp = _feed[1]['timestamp']; // First Post timestamp
    notifyListeners();
  }

  ////////////////////////////////// Gets Older Feed Posts (Bottom Feed Refresh)
  Future<void> refreshBottomFeed() async {
    List<Map<String, dynamic>> newFeed = [];
    newFeed = await ContentServices().refreshFeed(15, false, bottomTimestamp);
    // newFeed added to the top of the Feed List
    _feed = _feed + newFeed;
    // Refresh bottom timestamp
    bottomTimestamp =
        _feed[_feed.length - 1]['timestamp']; // Last Post timestamp
    notifyListeners();
  }

  // TODO: ONCE INITAL FEED IS LOADED IN STATE GET OLDER POSTS USING

  // Update
  notifyListeners();
}
