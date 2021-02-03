import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Storage {
  Function update;
  Storage(this.update);

  firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref();

  Future<void> listImages() async {
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref()
        .list(firebase_storage.ListOptions(maxResults: 10));

    if (result.nextPageToken != null) {
      // ignore: unused_local_variable
      firebase_storage.ListResult additionalResults = await firebase_storage
          .FirebaseStorage.instance
          .ref()
          .list(firebase_storage.ListOptions(
            maxResults: 10,
            pageToken: result.nextPageToken,
          ));
    }
  }
}
