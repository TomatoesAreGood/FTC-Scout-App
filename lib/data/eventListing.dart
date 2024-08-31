class EventListing {
  static final julianEpoch = DateTime.utc(0, 0, 0, 0, 0, 0);
  final String name;
  final String country;
  final String city;
  final String dateStart;
  final String code;
  final int type;

  const EventListing({
    required this.name,
    required this.country,
    required this.city,
    required this.dateStart,
    required this.code,
    required this.type
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
          type: int.parse(eventList[i]['type'])
        ));
      }   
    }
    print("FROM JSON SUCCESS");
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

  ExtendedEventListing({required this.year, required super.name, required super.country, required super.city, required super.dateStart, required super.code, required super.type});

  @override
  operator ==(o) => o is ExtendedEventListing && o.city == city && o.name == name && o.country == country && o.dateStart == dateStart && o.code == code && o.type == type && o.year == year;
}