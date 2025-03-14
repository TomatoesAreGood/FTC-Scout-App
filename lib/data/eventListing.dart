class EventListing {
  static final julianEpoch = DateTime.utc(0, 0, 0, 0, 0, 0);
  final String name;
  final String country;
  final String city;
  final String dateStart;
  final String dateEnd;
  final String code;
  final String? venue;
  final String? website;
  final String? liveStream;
  final int type;

  const EventListing({
    required this.name,
    required this.country,
    required this.city,
    required this.dateStart,
    required this.code,
    required this.type,
    required this.dateEnd,
    required this.venue,
    required this.liveStream,
    required this.website
  });

  static List<EventListing> fromJson(Map<String, dynamic> json){
    List<EventListing> allEvents = [];
    List eventList = json['events'];
    
    for (var i = 0; i < eventList.length; i++){
      if(int.parse(eventList[i]['type']) < 12 || int.parse(eventList[i]['type']) > 16){
        allEvents.add(EventListing(
          name: eventList[i]['name'], 
          country: eventList[i]['country'], 
          city: eventList[i]['city'], 
          dateStart: eventList[i]['dateStart'].substring(0, 10), 
          code: eventList[i]['code'],
          type: int.parse(eventList[i]['type']),
          dateEnd: eventList[i]['dateEnd'].substring(0, 10),
          venue: eventList[i]['venue'],
          liveStream: eventList[i]['liveStreamUrl'],
          website: eventList[i]['website']
        ));
      }   
    }
    return allEvents;
  }

  static int getNumericValue(String date){
    return int.parse(date.substring(0,4) + date.substring(5, 7) + date.substring(8, 10));
  }

  
  static int getJulianDate(String input){
    DateTime date = DateTime.utc(int.parse(input.substring(0,4)), 
    int.parse(input.substring(5, 7)), 
    int.parse(input.substring(8, 10)), 0, 0, 0);
    return date.difference(julianEpoch).inDays;
  }

  static void mergeSortDate(List<EventListing> arr){
    if (arr.length <= 1){
      return;
    }
    int mid = (arr.length / 2).floor() ;
    List<EventListing> L = arr.sublist(0, mid);
    List<EventListing> R = arr.sublist(mid, arr.length);
  
    mergeSortDate(L);
    mergeSortDate(R);
    int i = 0;
    int j = 0;
    int k = 0;
  
    while(i < L.length && j < R.length){
      if(getNumericValue(L[i].dateStart) == getNumericValue(R[j].dateStart)){
        if (L[i].name.compareTo(R[j].name) > 0){
          arr[k] = L[i];
          i++;
        }else{
          arr[k] = R[j];
          j++;
        }
        k++;
      }else{
        if (getNumericValue(L[i].dateStart) < getNumericValue(R[j].dateStart)){
          arr[k] = L[i];
          i++;
        }else{
          arr[k] = R[j];
          j++;
        }
        k++;
      }
    }
    while(i < L.length){
      arr[k] = L[i];
      i++;
      k++;
    }
    while(j < R.length){
      arr[k] = R[j];
      j++;
      k++;
    }
  } 
}

class ExtendedEventListing extends EventListing{
  final int year;

  ExtendedEventListing({required this.year, required super.name, required super.country, required super.city, required super.dateStart, required super.code, required super.type, required super.dateEnd, required super.venue, required super.liveStream, required super.website});

  static List<ExtendedEventListing> fromJson(Map<String, dynamic> json){
    List<ExtendedEventListing> allEvents = [];
    List eventList = json['events'];

    for (var i = 0; i < eventList.length; i++){
      if(eventList[i]['type'] < 12 || eventList[i]['type'] > 16){
        allEvents.add(ExtendedEventListing(
          name: eventList[i]['name'], 
          country: eventList[i]['country'], 
          city: eventList[i]['city'], 
          dateStart: eventList[i]['dateStart'], 
          code: eventList[i]['code'],
          type: eventList[i]['type'],
          dateEnd: eventList[i]['dateEnd'],
          venue: eventList[i]['venue'],
          liveStream: eventList[i]['liveStreamUrl'],
          website: eventList[i]['website'],
          year: eventList[i]['year']
        ));
      }   
    }
    return allEvents;
  }

  Map<String, dynamic> toJson(){
    return {
      'name': name,
      'country' : country,
      'city': city,
      'dateStart': dateStart,
      'code': code,
      'type': type,
      'dateEnd': dateEnd,
      'venue': venue,
      'liveStreamUrl': liveStream,
      'webiste' : website,
      'year': year      
    };
  }


  @override
  operator ==(other) => other is ExtendedEventListing && other.city == city && other.name == name && other.country == country && other.dateStart == dateStart && other.code == code && other.type == type && other.year == year; 
}