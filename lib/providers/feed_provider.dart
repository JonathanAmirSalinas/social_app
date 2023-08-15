import 'package:flutter/foundation.dart';
import 'package:social_app/services/content_services.dart';

class FeedProvider with ChangeNotifier {
  List<Map<String, dynamic>> _feed = [];
  late int topTimestamp;
  late int bottomTimestamp;
  bool hasMore = true;

  List<Map<String, dynamic>> get getFeed => _feed;

  // ?
  Future<void> setFeed() async {}

  //////////////////////////////////////////// Gets initial user feed (50 posts)
  Future<void> getUserFeed() async {
    _feed = await ContentServices().getUserFeed();
    topTimestamp = _feed[0]['timestamp']; // First Post timestamp
    bottomTimestamp =
        _feed[_feed.length - 1]['timestamp']; // Last Post timestamp
    notifyListeners();
  }

  Future<void> refreshPost(Map<String, dynamic> post) async {
    int index = _feed.indexOf(post);
    Map<String, dynamic> updatedPost =
        await ContentServices().getUpdatedPost(post['id_content']);

    _feed[index] = updatedPost;
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
    topTimestamp = _feed[0]['timestamp']; // First Post timestamp
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
