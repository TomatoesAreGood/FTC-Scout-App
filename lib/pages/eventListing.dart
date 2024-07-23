class EventListing {
  static final julianEpoch = DateTime.utc(0, 0, 0, 0, 0, 0);
  final String name;
  final String country;
  final String city;
  final String dateStart;
  final String code;

  const EventListing({
    required this.name,
    required this.country,
    required this.city,
    required this.dateStart,
    required this.code
  });

  static fromJson(Map<String, dynamic> json){
    List<EventListing> allEvents = [];
    List eventList = json['events'];
    
    for (var i = 0; i < eventList.length; i++){
      if(int.parse(eventList[i]['type']) < 12 || int.parse(eventList[i]['type']) > 16){
        allEvents.add(EventListing(
          name: eventList[i]['name'], 
          country: eventList[i]['country'], 
          city: eventList[i]['city'], 
          dateStart: eventList[i]['dateStart'].substring(0, 10), 
          code: eventList[i]['code']
        ));
      }   
    }
    print("FROM JSON SUCCESS");
    return allEvents;
  }

  static int getNumericValue(String date){
    return int.parse(date.substring(0,4) + date.substring(5, 7) + date.substring(8, 10));
  }

  
  static int getJulianDate(String date){
    // DateTime date = DateTime.utc(int.parse(input.substring(0,4)), 
    // int.parse(input.substring(5, 7)), 
    // int.parse(input.substring(8, 10)), 0, 0, 0);
    // return date.difference(julianEpoch).inDays;
    return int.parse(date.substring(0,4))*365 + int.parse(date.substring(5, 7))*30 + int.parse(date.substring(8, 10));
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
        if (getNumericValue(L[i].dateStart) < getNumericValue(R[j].dateStart)){
          arr[k] = L[i];
          i++;
        }else{
          arr[k] = R[j];
          j++;
        }
        k++;
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