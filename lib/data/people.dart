//* 1. Kelas Person
class Person {
  final String name;
  final String phone;
  final String picture;
  const Person(this.name, this.phone, this.picture);
}

//* 2. Variabel List dengan nama people yang memilii data bertipe object Person, yang merupakan
//* hasil mapping data list pada baris 14 ke bawah
final List<Person> people = _people
    .map((e) => Person(
        e['name'] as String, e['phone'] as String, e['picture'] as String))
    .toList(growable: false);

final List<Map<String, Object>> _people = [
  {
    "_id": "6501d0f0de76ea10b8192c51",
    "index": 0,
    "guid": "a71240b4-252a-4e63-9367-10cd3457968b",
    "isActive": true,
    "balance": "\$2,439.62",
    "picture": "http://placehold.it/32x32",
    "age": 29,
    "eyeColor": "blue",
    "name": "Jessie Jimenez",
    "gender": "female",
    "company": "TALENDULA",
    "email": "jessiejimenez@talendula.com",
    "phone": "+1 (999) 454-3654",
    "address": "644 Melba Court, Boling, Washington, 5927",
    "about":
        "Voluptate tempor aute pariatur enim. Aute consequat cillum eiusmod sint Lorem quis Lorem exercitation. Occaecat eiusmod qui consequat tempor sint nisi Lorem dolore. Est et sint esse magna laboris excepteur mollit pariatur ipsum esse consequat deserunt culpa. Veniam Lorem non quis dolor fugiat. Dolor laborum deserunt ipsum dolor proident anim qui. Commodo sint dolor ut reprehenderit irure pariatur.\r\n",
    "registered": "2023-08-29T11:46:19 -07:00",
    "latitude": -71.270046,
    "longitude": -88.615954,
    "tags": ["deserunt", "sint", "quis", "voluptate", "enim", "proident", "eu"],
    "friends": [
      {"id": 0, "name": "Tracie Hodge"},
      {"id": 1, "name": "Candy Harmon"},
      {"id": 2, "name": "Shelby Noel"}
    ],
    "greeting": "Hello, Jessie Jimenez! You have 2 unread messages.",
    "favoriteFruit": "apple"
  },
  {
    "_id": "6501d0f0fb7e37f9d0777396",
    "index": 1,
    "guid": "78f623b4-ae35-4e0b-bb77-3e8e24e05b5a",
    "isActive": false,
    "balance": "\$3,319.45",
    "picture": "http://placehold.it/32x32",
    "age": 27,
    "eyeColor": "blue",
    "name": "Fuentes Adams",
    "gender": "male",
    "company": "NAVIR",
    "email": "fuentesadams@navir.com",
    "phone": "+1 (960) 418-2900",
    "address": "444 Loring Avenue, Forbestown, Ohio, 1774",
    "about":
        "Labore est Lorem reprehenderit officia non exercitation ut. Cupidatat cupidatat aute commodo culpa esse. Incididunt ipsum labore veniam minim Lorem est velit dolore culpa. Adipisicing aliqua et amet qui in eiusmod.\r\n",
    "registered": "2023-02-09T03:43:45 -07:00",
    "latitude": -89.654412,
    "longitude": -155.146915,
    "tags": [
      "veniam",
      "cupidatat",
      "adipisicing",
      "culpa",
      "nostrud",
      "quis",
      "amet"
    ],
    "friends": [
      {"id": 0, "name": "Jeanie Durham"},
      {"id": 1, "name": "Melinda Douglas"},
      {"id": 2, "name": "Lana Graham"}
    ],
    "greeting": "Hello, Fuentes Adams! You have 1 unread messages.",
    "favoriteFruit": "strawberry"
  },
  {
    "_id": "6501d0f0575b16bb1e84b372",
    "index": 2,
    "guid": "7545989c-f964-413c-96f9-a88f6b2bf441",
    "isActive": true,
    "balance": "\$3,047.91",
    "picture": "http://placehold.it/32x32",
    "age": 30,
    "eyeColor": "brown",
    "name": "Bradley Brennan",
    "gender": "male",
    "company": "SNORUS",
    "email": "bradleybrennan@snorus.com",
    "phone": "+1 (814) 447-3927",
    "address": "882 Henry Street, Caron, Alaska, 3648",
    "about":
        "Aliquip adipisicing ullamco Lorem dolore ut nostrud. Ullamco fugiat eiusmod anim labore fugiat amet ut. Occaecat dolor eiusmod minim deserunt Lorem. Elit reprehenderit officia in eiusmod do laborum veniam mollit anim aliqua consectetur. Laborum fugiat magna officia qui ipsum eiusmod et. Commodo esse officia Lorem deserunt exercitation ut.\r\n",
    "registered": "2016-03-16T08:56:32 -07:00",
    "latitude": -2.412623,
    "longitude": -98.521379,
    "tags": [
      "culpa",
      "labore",
      "eiusmod",
      "excepteur",
      "fugiat",
      "quis",
      "laboris"
    ],
    "friends": [
      {"id": 0, "name": "Melendez Garcia"},
      {"id": 1, "name": "Bowman Pierce"},
      {"id": 2, "name": "Mcintosh Morin"}
    ],
    "greeting": "Hello, Bradley Brennan! You have 7 unread messages.",
    "favoriteFruit": "apple"
  },
  {
    "_id": "6501d0f05f26b18129dbedc4",
    "index": 3,
    "guid": "ca31e95f-7e90-410e-b006-8a265a75ff40",
    "isActive": false,
    "balance": "\$1,001.77",
    "picture": "http://placehold.it/32x32",
    "age": 37,
    "eyeColor": "green",
    "name": "Rosalyn Allison",
    "gender": "female",
    "company": "ATOMICA",
    "email": "rosalynallison@atomica.com",
    "phone": "+1 (933) 562-2721",
    "address": "381 Hopkins Street, Herlong, Guam, 4668",
    "about":
        "Aliquip consequat eu eu ad veniam ex enim sit voluptate deserunt occaecat. Eu id occaecat duis consectetur minim esse ex eiusmod est ut dolore adipisicing. Esse laborum proident laboris Lorem do voluptate esse pariatur incididunt.\r\n",
    "registered": "2021-12-31T04:00:48 -07:00",
    "latitude": -56.358866,
    "longitude": 64.025809,
    "tags": ["veniam", "eu", "est", "aliqua", "Lorem", "magna", "amet"],
    "friends": [
      {"id": 0, "name": "Thornton Moreno"},
      {"id": 1, "name": "Lynn Mullins"},
      {"id": 2, "name": "Dana Vazquez"}
    ],
    "greeting": "Hello, Rosalyn Allison! You have 6 unread messages.",
    "favoriteFruit": "strawberry"
  },
  {
    "_id": "6501d0f023d90875a610acd6",
    "index": 4,
    "guid": "8f7de251-b4b1-4205-8bc9-c237d0f8d8fb",
    "isActive": true,
    "balance": "\$3,799.13",
    "picture": "http://placehold.it/32x32",
    "age": 26,
    "eyeColor": "brown",
    "name": "Espinoza Strong",
    "gender": "male",
    "company": "ZOXY",
    "email": "espinozastrong@zoxy.com",
    "phone": "+1 (891) 521-3158",
    "address": "313 Catherine Street, Morriston, Minnesota, 8662",
    "about":
        "Non aliquip duis nulla qui cupidatat labore veniam velit incididunt. Et commodo aute veniam proident mollit. Tempor non incididunt dolore labore. Labore sit magna elit laborum anim Lorem ipsum laboris dolore nulla ut. Lorem dolor est reprehenderit consectetur et tempor ullamco ullamco elit adipisicing labore sunt. Amet irure eiusmod voluptate anim occaecat nulla aliquip ea anim aliquip tempor mollit nulla ea. Veniam est sunt ipsum in incididunt consequat minim eiusmod aliquip ea.\r\n",
    "registered": "2022-01-24T10:36:48 -07:00",
    "latitude": -66.006489,
    "longitude": 156.146712,
    "tags": ["dolor", "consequat", "enim", "nostrud", "elit", "ipsum", "sint"],
    "friends": [
      {"id": 0, "name": "Amalia Luna"},
      {"id": 1, "name": "Chavez Foreman"},
      {"id": 2, "name": "Natasha Brewer"}
    ],
    "greeting": "Hello, Espinoza Strong! You have 7 unread messages.",
    "favoriteFruit": "strawberry"
  },
  {
    "_id": "6501d0f05a2de00e1fb194b2",
    "index": 5,
    "guid": "7c170942-87b8-45c3-981a-eda37d0b45aa",
    "isActive": true,
    "balance": "\$3,306.68",
    "picture": "http://placehold.it/32x32",
    "age": 34,
    "eyeColor": "green",
    "name": "Ora Bentley",
    "gender": "female",
    "company": "VALREDA",
    "email": "orabentley@valreda.com",
    "phone": "+1 (959) 526-2900",
    "address": "590 Locust Avenue, Grapeview, Wisconsin, 3618",
    "about":
        "Ea est et eiusmod nulla consequat velit adipisicing. Do duis quis laboris dolore ex consectetur commodo non ea fugiat commodo irure et. Aliqua deserunt dolore elit sunt dolor laborum sint deserunt eu velit dolore labore fugiat fugiat. Reprehenderit laborum voluptate nostrud officia et reprehenderit mollit. Culpa occaecat elit Lorem excepteur. Consequat sit laboris laborum esse do. Id dolore occaecat fugiat culpa tempor adipisicing eu et dolore consectetur cillum id.\r\n",
    "registered": "2023-01-08T08:48:35 -07:00",
    "latitude": 51.773208,
    "longitude": -75.844442,
    "tags": [
      "tempor",
      "quis",
      "excepteur",
      "elit",
      "commodo",
      "laborum",
      "nulla"
    ],
    "friends": [
      {"id": 0, "name": "Addie Tanner"},
      {"id": 1, "name": "Lowe Cross"},
      {"id": 2, "name": "Casey Travis"}
    ],
    "greeting": "Hello, Ora Bentley! You have 4 unread messages.",
    "favoriteFruit": "strawberry"
  },
  {
    "_id": "6501d0f0165e480d15cee880",
    "index": 6,
    "guid": "8698a890-6785-40f8-991c-9199c84b0ca9",
    "isActive": true,
    "balance": "\$3,735.25",
    "picture": "http://placehold.it/32x32",
    "age": 25,
    "eyeColor": "blue",
    "name": "Castillo Huff",
    "gender": "male",
    "company": "FUTURIZE",
    "email": "castillohuff@futurize.com",
    "phone": "+1 (872) 529-2636",
    "address":
        "174 Claver Place, Neibert, Federated States Of Micronesia, 1021",
    "about":
        "Esse veniam exercitation laborum aute mollit exercitation in veniam irure do commodo commodo sint. Nostrud laborum enim anim aliquip. Labore aute aliquip ullamco deserunt. Nostrud commodo aliquip dolore Lorem nostrud aliqua excepteur nisi. Mollit irure consectetur excepteur ad voluptate et excepteur ea consequat reprehenderit amet aliqua.\r\n",
    "registered": "2020-07-27T01:55:10 -07:00",
    "latitude": -45.68054,
    "longitude": 66.085263,
    "tags": [
      "Lorem",
      "ullamco",
      "reprehenderit",
      "elit",
      "magna",
      "esse",
      "voluptate"
    ],
    "friends": [
      {"id": 0, "name": "Davis Browning"},
      {"id": 1, "name": "Nelson Ellison"},
      {"id": 2, "name": "Jacobs Castillo"}
    ],
    "greeting": "Hello, Castillo Huff! You have 5 unread messages.",
    "favoriteFruit": "apple"
  }
];
