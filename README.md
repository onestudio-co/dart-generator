# dart-generator

# Manual installation:

1- generate a platform executable from code 
```
dart compile exe main.dart -o generator
```
this will generate a new generator file inside the lib folder.

2- create alias inside your ```.bash_profile``` and ```.zshrc``` files 
```
alias generator="/Users/userName/packages/generator/lib/generator"
```
now you can use command line directly from your terminal 

# Usage:

1- generate factory
```
generator make factory --name UserFactory
```
this will generate ```user_factory.dart``` file inside ```data/factories``` directory

``` dart
import 'package:famcare/auth/models/user.dart';
import 'package:famcare/auth/models/address.dart';
import 'package:famcare/auth/models/note.dart';

import 'address_factory.dart';
import 'note_factory.dart';

import 'package:faker/faker.dart';

class UserFactory {
  int? id;

  String? name;

  int? age;

  Address? address;

  List<Note>? notes;

  int? _count;

  dynamic create(
      {int? id, String? name, int? age, Address? address, List<Note>? notes}) {
    final mUser = User(
      id: id ?? this.id ?? faker.randomGenerator.integer(2),
      name: name ?? this.name ?? faker.randomGenerator.string(23),
      age: age ?? this.age ?? faker.randomGenerator.integer(2),
      address: address ?? this.address ?? AddressFactory().make(),
      notes: notes ?? this.notes ?? NoteFactory().count(10).make(),
    );
    if (_count != null) {
      return List<User>.filled(_count!, mUser);
    } else {
      return mUser;
    }
  }

  UserFactory state(
      {int? id, String? name, int? age, Address? address, List<Note>? notes}) {
    this.id = id ?? this.id;
    this.name = name ?? this.name;
    this.age = age ?? this.age;
    this.address = address ?? this.address;
    this.notes = notes ?? this.notes;
    return this;
  }

  UserFactory count(int count) {
    _count = count;
    return this;
  }

  UserFactory hasAddress(
      {Address? address,
      int? id,
      Country? country,
      String? address,
      String? street}) {
    if (address != null) {
      this.address = address;
    } else {
      this.address = AddressFactory().create(
        id: id,
        country: country,
        address: address,
        street: street,
      );
    }
    return this;
  }

  UserFactory hasNotes(
      {List<Note>? notes, int? count, String? title, String? content}) {
    if (notes != null) {
      this.notes = notes;
    } else {
      assert(count != null);
      this.notes = NoteFactory().count(count).create(
            title: title,
            content: content,
          );
    }
    return this;
  }
}
```
  
2- generate feature
first you need to create a yaml file with the content of this feature and the file name must have the same feature name

for example for emition traccker feature we create emotions_tracker.yaml inside emotions_tracker feature package
``` yaml
name: emotions_tracker


data:
  base_url: backend-develop.famcare.app
  headers: { Authorization: Bearer 2545|XTiItBo8ayOuSTZgwQ1hSMApvOhOhhAblj6o39lk,
             Content-Type: application/json }
  apis:
    - name: getEmotions
      method: GET
      path: api/v2/emotions
      model: Emotion
      response_model: ListResponse
    - name: addDailyEmotion
      method: POST
      path: api/v2/users/userId/emotions
      body: {emotion_id: 1, diary: hello im sad}
      values: {userId: 4}
      response_model: SuccessResponse
    - name: getCurrentEmotion
      method: GET
      path: api/v2/users/userId/emotions
      values: { userId: 4 }
      model: UserEmotion
      response_model: SingleResponse
    - name: emotionsHistory
      method: GET
      path: api/v2/users/userId/emotions-history
      values: {userId: 4}
      model: UserEmotion
      response_model: ListResponse
  create_repo: true
  events:
    - name: View Daily Emotion
      params: [Placement]
    - name: View Emotions History
      params: []
    - name: View Specific Day Emotional
      params: [Id, Emotion Id,  Emotion Text,  Created At]

presentations:
  - name: DailyEmotionView
    controllers:
      - initial_api: getCurrentEmotion
        apis: [getCurrentEmotion]
    feature_flag:
      key: emotions_feature_flag
    generate_route: false
  - name: FillDailyEmotionPage
    controllers:
      - initial_api: getEmotions
        apis: [addDailyEmotion]
    generate_route: true
  - name: EmotionsHistoryPage
    controller:
      - initial_api: emotionsHistory
        apis: [emotionsHistory]
    generate_route: true
```
Then write this command:
```
generate make feature --name emotionsTracker
```
This will generate a all data files: 
- ```Emotion```
- ```UserEmotion```
- ```EmotionsTrackerRemoteDataSource```
- ```EmotionsTrackerRepository```
- ```ViewDailyEmotionEvent```
- ```ViewEmotionsHistoryEvent```
- ```ViewSpecificDayEmotionalEvent```
