import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class YearlyTeamDivisions{
  static Map<String, List> map = {
    "2024": 
    [
      [1, 535],
      [542, 3351],
      [3371, 3922],
      [3944, 4366],
      [4400, 4950],
      [4951, 5225],
      [5227, 5641],
      [5661, 6093],
      [6101, 6390],
      [6402, 6889],
      [6892, 7153],
      [7156, 7423],
      [7424, 7797],
      [7802, 8149],
      [8153, 8541],
      [8548, 8772],
      [8777, 9040],
      [9044, 9378],
      [9381, 9768],
      [9770, 9989],
      [9990, 10211],
      [10216, 10475],
      [10477, 10752],
      [10755, 11044],
      [11047, 11246],
      [11248, 11454],
      [11455, 11695],
      [11697, 11999],
      [12000, 12309],
      [12313, 12554],
      [12560, 12775],
      [12777, 12993],
      [12995, 13226],
      [13227, 13432],
      [13435, 13657],
      [13661, 13916],
      [13917, 14174],
      [14177, 14381],
      [14382, 14620],
      [14623, 14773],
      [14774, 14944],
      [14946, 15144],
      [15145, 15342],
      [15343, 15523],
      [15524, 15809],
      [15811, 15989],
      [15991, 16158],
      [16161, 16303],
      [16306, 16447],
      [16448, 16605],
      [16606, 16773],
      [16774, 16930],
      [16932, 17113],
      [17114, 17264],
      [17280, 17457],
      [17458, 17651],
      [17652, 17881],
      [17882, 18127],
      [18133, 18294],
      [18295, 18445],
      [18447, 18589],
      [18592, 18775],
      [18781, 18964],
      [18965, 19090],
      [19091, 19196],
      [19197, 19368],
      [19371, 19462],
      [19468, 19589],
      [19590, 19710],
      [19712, 19804],
      [19806, 19911],
      [19912, 20014],
      [20016, 20117],
      [20118, 20232],
      [20233, 20325],
      [20326, 20417],
      [20420, 20608],
      [20613, 20739],
      [20741, 20858],
      [20862, 20976],
      [20979, 21085],
      [21086, 21211],
      [21212, 21326],
      [21327, 21392],
      [21393, 21460],
      [21461, 21528],
      [21529, 21597],
      [21598, 21666],
      [21667, 21734],
      [21735, 21801],
      [21802, 21866],
      [21867, 21932],
      [21933, 21997],
      [21998, 22062],
      [22063, 22132],
      [22133, 22198],
      [22199, 22265],
      [22266, 22331],
      [22332, 22397],
      [22398, 22466],
      [22467, 22533],
      [22534, 22600],
      [22601, 22667],
      [22668, 22734],
      [22735, 22804],
      [22805, 22873],
      [22874, 22941],
      [22942, 23010],
      [23011, 23085],
      [23086, 23161],
      [23162, 23249],
      [23250, 23318],
      [23319, 23388],
      [23389, 23456],
      [23457, 23531],
      [23532, 23600],
      [23601, 23666],
      [23667, 23734],
      [23735, 23802],
      [23803, 23868],
      [23869, 23934],
      [23935, 23999],
      [24000, 24065],
      [24066, 24130],
      [24131, 24195],
      [24196, 24260],
      [24261, 24326],
      [24327, 24392],
      [24393, 24458],
      [24459, 24524],
      [24525, 24592],
      [24593, 24660],
      [24661, 24725],
      [24726, 24791],
      [24792, 24857],
      [24858, 24924],
      [24925, 24992],
      [24993, 25059],
      [25060, 25125],
      [25126, 25197],
      [25198, 25265],
      [25266, 25333],
      [25334, 25401],
      [25403, 25472],
      [25473, 25541],
      [25542, 25625],
      [25626, 25707],
      [25708, 25783],
      [25784, 25856],
      [25857, 25924],
      [25925, 25994],
      [25995, 26066],
      [26068, 26142],
      [26143, 26214],
      [26215, 26286],
      [26287, 26357],
      [26358, 26430],
      [26431, 26507],
      [26508, 26578],
      [26580, 26648],
      [26649, 26722],
      [26723, 26818],
      [26819, 26876],
    ],
    "2023":
    [
      [1, 519],
      [524, 3231],
      [3296, 3830],
      [3839, 4324],
      [4326, 4812],
      [4813, 5126],
      [5131, 5437],
      [5439, 5907],
      [5911, 6205],
      [6206, 6499],
      [6510, 6973],
      [6974, 7215],
      [7224, 7482],
      [7486, 7832],
      [7833, 8188],
      [8194, 8535],
      [8541, 8740],
      [8741, 9001],
      [9006, 9297],
      [9298, 9618],
      [9622, 9897],
      [9898, 10099],
      [10100, 10309],
      [10310, 10540],
      [10541, 10789],
      [10793, 11063],
      [11085, 11248],
      [11253, 11419],
      [11424, 11616],
      [11617, 11892],
      [11898, 12139],
      [12147, 12395],
      [12397, 12603],
      [12604, 12792],
      [12793, 12978],
      [12979, 13181],
      [13186, 13365],
      [13366, 13550],
      [13552, 13750],
      [13753, 14003],
      [14005, 14191],
      [14194, 14377],
      [14379, 14538],
      [14544, 14708],
      [14709, 14842],
      [14845, 14988],
      [14989, 15173],
      [15182, 15352],
      [15353, 15497],
      [15500, 15707],
      [15715, 15868],
      [15869, 16057],
      [16058, 16207],
      [16208, 16333],
      [16334, 16465],
      [16466, 16602],
      [16605, 16731],
      [16734, 16862],
      [16864, 17009],
      [17011, 17157],
      [17159, 17294],
      [17297, 17438],
      [17440, 17595],
      [17596, 17775],
      [17776, 18013],
      [18014, 18149],
      [18151, 18278],
      [18280, 18388],
      [18389, 18498],
      [18499, 18606],
      [18611, 18760],
      [18761, 18891],
      [18893, 19049],
      [19050, 19131],
      [19134, 19250],
      [19251, 19376],
      [19377, 19443],
      [19444, 19508],
      [19509, 19574],
      [19575, 19641],
      [19642, 19706],
      [19707, 19773],
      [19774, 19842],
      [19843, 19907],
      [19908, 19972],
      [19973, 20039],
      [20040, 20104],
      [20105, 20173],
      [20174, 20240],
      [20241, 20305],
      [20306, 20372],
      [20373, 20438],
      [20439, 20503],
      [20504, 20568],
      [20569, 20633],
      [20634, 20705],
      [20706, 20772],
      [20773, 20840],
      [20841, 20905],
      [20906, 20978],
      [20979, 21044],
      [21045, 21113],
      [21114, 21178],
      [21179, 21249],
      [21250, 21359],
      [21360, 21426],
      [21427, 21493],
      [21494, 21564],
      [21565, 21631],
      [21632, 21698],
      [21699, 21767],
      [21768, 21833],
      [21834, 21899],
      [21900, 21964],
      [21965, 22029],
      [22030, 22094],
      [22095, 22165],
      [22166, 22231],
      [22232, 22298],
      [22299, 22364],
      [22365, 22430],
      [22432, 22499],
      [22500, 22565],
      [22566, 22632],
      [22633, 22700],
      [22701, 22769],
      [22770, 22836],
      [22837, 22905],
      [22906, 22974],
      [22975, 23045],
      [23046, 23125],
      [23127, 23214],
      [23215, 23280],
      [23281, 23345],
      [23346, 23410],
      [23411, 23475],
      [23476, 23540],
      [23541, 23605],
      [23606, 23670],
      [23671, 23735],
      [23736, 23800],
      [23801, 23865],
      [23866, 23930],
      [23931, 23995],
      [23996, 24060],
      [24061, 24125],
      [24126, 24190],
      [24191, 24255],
      [24256, 24320],
      [24321, 24385],
      [24386, 24450],
      [24451, 24515],
      [24516, 24580],
      [24581, 24645],
      [24646, 24710],
      [24711, 24775],
      [24776, 24840],
      [24841, 24905],
      [24906, 24970],
      [24971, 25035],
      [25036, 25100],
      [25101, 25165],
      [25166, 25230],
      [25231, 25295],
      [25296, 25360],
      [25361, 25425],
      [25426, 25490],
      [25491, 25555],
      [25556, 99911],
      [99912, 99976],
      [99977, 202300311],
      [202300315, 202300880],
      [202300888, 202301457],
      [202301466, 202301974],
      [202301988, 202302340],
      [202302341, 202302736],
      [202302747, 202303090],
    ],
    "2022":
    [
      [1, 673],
      [689, 3543],
      [3558, 4104],
      [4106, 4625],
      [4628, 5040],
      [5044, 5384],
      [5385, 5919],
      [5921, 6272],
      [6273, 6582],
      [6584, 7065],
      [7078, 7360],
      [7373, 7772],
      [7783, 8153],
      [8161, 8565],
      [8569, 8801],
      [8807, 9110],
      [9113, 9473],
      [9476, 9840],
      [9848, 10098],
      [10099, 10348],
      [10353, 10603],
      [10615, 10902],
      [10908, 11183],
      [11186, 11382],
      [11384, 11608],
      [11609, 11940],
      [11943, 12218],
      [12231, 12515],
      [12516, 12744],
      [12745, 12978],
      [12979, 13226],
      [13227, 13459],
      [13460, 13688],
      [13697, 13998],
      [13999, 14235],
      [14236, 14450],
      [14452, 14673],
      [14675, 14853],
      [14855, 15055],
      [15058, 15282],
      [15284, 15455],
      [15458, 15715],
      [15719, 15889],
      [15891, 16117],
      [16118, 16282],
      [16283, 16423],
      [16424, 16597],
      [16598, 16773],
      [16774, 16935],
      [16936, 17116],
      [17121, 17299],
      [17300, 17481],
      [17482, 17710],
      [17711, 17980],
      [17986, 18175],
      [18183, 18359],
      [18360, 18505],
      [18509, 18686],
      [18687, 18859],
      [18860, 19061],
      [19062, 19154],
      [19162, 19298],
      [19299, 19446],
      [19447, 19571],
      [19572, 19687],
      [19688, 19788],
      [19792, 19895],
      [19896, 19997],
      [19998, 20106],
      [20107, 20225],
      [20228, 20323],
      [20324, 20417],
      [20420, 20607],
      [20608, 20744],
      [20745, 20868],
      [20869, 20990],
      [20991, 21097],
      [21100, 21224],
      [21225, 21336],
      [21337, 21402],
      [21403, 21469],
      [21470, 21535],
      [21536, 21604],
      [21605, 21670],
      [21671, 21735],
      [21736, 21800],
      [21801, 21865],
      [21866, 21930],
      [21931, 21995],
      [21996, 22060],
      [22061, 22127],
      [22128, 22193],
      [22194, 22259],
      [22260, 22324],
      [22325, 22389],
      [22390, 22454],
      [22456, 22522],
      [22523, 22587],
      [22588, 22654],
      [22655, 22720],
      [22722, 22786],
      [22787, 22853],
      [22854, 22920],
      [22921, 22989],
      [22990, 23057],
      [23059, 23139],
      [23140, 202201748],
      [202201749, 202201824],
    ],
    "2021": 
    [
      [1, 701],
      [724, 3565],
      [3583, 4104],
      [4106, 4512],
      [4531, 5011],
      [5014, 5363],
      [5383, 5889],
      [5890, 6191],
      [6198, 6494],
      [6496, 6974],
      [6976, 7231],
      [7238, 7506],
      [7518, 7904],
      [7924, 8365],
      [8367, 8626],
      [8628, 8837],
      [8845, 9121],
      [9128, 9458],
      [9459, 9819],
      [9820, 10024],
      [10031, 10246],
      [10253, 10515],
      [10518, 10768],
      [10771, 11056],
      [11058, 11254],
      [11258, 11444],
      [11453, 11695],
      [11697, 11980],
      [11981, 12282],
      [12294, 12499],
      [12505, 12718],
      [12719, 12886],
      [12887, 13105],
      [13106, 13310],
      [13312, 13514],
      [13523, 13737],
      [13738, 14010],
      [14013, 14214],
      [14223, 14401],
      [14403, 14607],
      [14608, 14759],
      [14765, 14905],
      [14906, 15082],
      [15083, 15298],
      [15300, 15461],
      [15465, 15668],
      [15669, 15859],
      [15861, 16050],
      [16051, 16204],
      [16205, 16333],
      [16334, 16479],
      [16481, 16627],
      [16629, 16757],
      [16759, 16902],
      [16906, 17056],
      [17062, 17219],
      [17221, 17341],
      [17344, 17512],
      [17513, 17703],
      [17704, 17893],
      [17895, 18100],
      [18103, 18249],
      [18251, 18367],
      [18369, 18482],
      [18483, 18598],
      [18599, 18750],
      [18754, 18896],
      [18897, 19058],
      [19059, 19146],
      [19147, 19282],
      [19284, 19395],
      [19396, 19461],
      [19462, 19526],
      [19527, 19594],
      [19595, 19659],
      [19660, 19726],
      [19727, 19791],
      [19792, 19857],
      [19858, 19922],
      [19923, 19987],
      [19988, 20052],
      [20053, 20117],
      [20118, 20183],
      [20184, 20249],
      [20250, 20314],
      [20315, 20380],
      [20381, 20446],
      [20447, 20511],
      [20512, 20576],
      [20577, 20641],
      [20642, 20713],
      [20714, 20780],
      [20781, 20848],
      [20849, 20913],
      [20914, 20985],
      [20986, 21052],
      [21053, 21119],
      [21120, 21184],
      [21185, 99999],
    ],
    "2020":
    [
      [1, 772],
      [965, 3766],
      [3774, 4347],
      [4348, 4969],
      [4970, 5321],
      [5340, 5911],
      [5913, 6297],
      [6299, 6662],
      [6666, 7130],
      [7135, 7420],
      [7423, 7837],
      [7841, 8373],
      [8375, 8646],
      [8647, 8895],
      [8898, 9266],
      [9277, 9768],
      [9772, 9986],
      [9987, 10210],
      [10211, 10526],
      [10528, 10809],
      [10812, 11112],
      [11117, 11268],
      [11270, 11482],
      [11483, 11780],
      [11781, 12118],
      [12123, 12430],
      [12441, 12656],
      [12660, 12842],
      [12843, 13028],
      [13029, 13247],
      [13249, 13460],
      [13462, 13704],
      [13709, 14000],
      [14001, 14195],
      [14198, 14381],
      [14382, 14566],
      [14568, 14725],
      [14727, 14888],
      [14889, 15053],
      [15055, 15286],
      [15288, 15462],
      [15465, 15707],
      [15710, 15867],
      [15868, 16091],
      [16102, 16252],
      [16253, 16392],
      [16397, 16537],
      [16538, 16664],
      [16665, 16795],
      [16796, 16944],
      [16945, 17085],
      [17089, 17242],
      [17243, 17384],
      [17385, 17570],
      [17571, 17742],
      [17744, 17976],
      [17977, 18102],
      [18103, 18212],
      [18213, 18280],
      [18281, 18345],
      [18346, 18412],
      [18413, 18477],
      [18478, 18542],
      [18543, 18608],
      [18609, 18673],
      [18674, 18739],
      [18740, 18806],
      [18807, 18872],
      [18873, 18938],
      [18939, 19003],
      [19004, 19069],
      [19070, 19138],
      [19139, 19204],
      [19205, 19275],
      [19277, 19344],
      [19345, 99999],
    ],
    "2019": 
    [
      [1, 535],
      [542, 3231],
      [3291, 3819],
      [3825, 4218],
      [4221, 4605],
      [4622, 4965],
      [4969, 5233],
      [5237, 5501],
      [5514, 5937],
      [5940, 6183],
      [6184, 6383],
      [6387, 6640],
      [6645, 7030],
      [7031, 7244],
      [7245, 7470],
      [7473, 7766],
      [7767, 8080],
      [8081, 8380],
      [8381, 8572],
      [8577, 8721],
      [8728, 8942],
      [8945, 9123],
      [9128, 9378],
      [9381, 9622],
      [9626, 9862],
      [9864, 9993],
      [9994, 10145],
      [10158, 10302],
      [10303, 10469],
      [10470, 10635],
      [10636, 10798],
      [10802, 10982],
      [10984, 11164],
      [11165, 11264],
      [11266, 11387],
      [11391, 11530],
      [11531, 11673],
      [11676, 11847],
      [11848, 12013],
      [12014, 12176],
      [12178, 12359],
      [12360, 12516],
      [12517, 12651],
      [12652, 12762],
      [12763, 12876],
      [12877, 12997],
      [12999, 13125],
      [13126, 13266],
      [13269, 13389],
      [13396, 13510],
      [13511, 13616],
      [13617, 13750],
      [13751, 13899],
      [13900, 14029],
      [14033, 14172],
      [14174, 14312],
      [14314, 14417],
      [14418, 14507],
      [14508, 14614],
      [14615, 14703],
      [14705, 14798],
      [14799, 14883],
      [14887, 14975],
      [14976, 15084],
      [15085, 15191],
      [15192, 15296],
      [15297, 15396],
      [15397, 15494],
      [15495, 15612],
      [15614, 15720],
      [15721, 15831],
      [15832, 15947],
      [15953, 16075],
      [16076, 16173],
      [16174, 16242],
      [16243, 16314],
      [16316, 16383],
      [16384, 16450],
      [16451, 16515],
      [16516, 16580],
      [16581, 16646],
      [16647, 16712],
      [16713, 16777],
      [16778, 16842],
      [16843, 16907],
      [16908, 16973],
      [16974, 17038],
      [17039, 17103],
      [17104, 17168],
      [17169, 17233],
      [17234, 17299],
      [17300, 17365],
      [17366, 17431],
      [17432, 17498],
      [17499, 17563],
      [17564, 17628],
      [17629, 17693],
      [17694, 17759],
      [17760, 17824],
      [17825, 17889],
      [17890, 17975],
      [17976, 18043],
      [18044, 18109],
      [18110, 18174],
      [18175, 201902089],
    ]
  };

  void printYearlyTeamDivisions(int year) async{
    String? user = dotenv.env['USER'];
    String? token = dotenv.env['TOKEN'];
    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    var response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/$year/teams?page=1'), headers: {"Authorization": "Basic $encodedToken"});
    print( "[${(json.decode(response.body) as Map<String, dynamic>)['teams'][0]['teamNumber']}, ${(json.decode(response.body) as Map<String, dynamic>)['teams'][64]['teamNumber']}],");
    int totalPages = (json.decode(response.body) as Map<String, dynamic>)['pageTotal'];

    for(var i = 2; i <= totalPages; i++){
      response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/$year/teams?page=$i'), headers: {"Authorization": "Basic $encodedToken"});
      if(i != totalPages){
        print("[${(json.decode(response.body) as Map<String, dynamic>)['teams'][0]['teamNumber']}, ${(json.decode(response.body) as Map<String, dynamic>)['teams'][64]['teamNumber']}],");
      }else{
        int teamCountPage = (json.decode(response.body) as Map<String, dynamic>)['teamCountPage'] - 1;
        print("[${(json.decode(response.body) as Map<String, dynamic>)['teams'][0]['teamNumber']}, ${(json.decode(response.body) as Map<String, dynamic>)['teams'][teamCountPage]['teamNumber']}],");
      }
    }
  }

  //COULD MAKE THIS MORE EFFICIENT
  static int getPageNum(String year, int teamNum){
    List? divisions = YearlyTeamDivisions.map[year];
    for(var i = 0; i < divisions!.length; i++){
      if(teamNum >= divisions[i][0] && teamNum <= divisions[i][1]){
        return i + 1;
      }
    }
    return -1;
  }
}