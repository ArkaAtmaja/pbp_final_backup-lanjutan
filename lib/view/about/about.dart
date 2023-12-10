import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Tambahkan SingleChildScrollView di sini
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildAboutCard('Tentang News PBP ', 'News PBP adalah aplikasi berita yang inovatif dan intuitif yang dirancang untuk memberikan pengguna akses cepat dan mudah ke berita terbaru dari seluruh dunia. Aplikasi ini dirancang dengan fokus pada pengalaman pengguna yang nyaman dan menyediakan berbagai fitur yang memungkinkan pengguna tetap terinformasi dengan mudah dan efisien.'),
              SizedBox(height: 16.0),
              Text('Tim Kami:',
                        style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 12.0),
              buildAboutCard('Charli Palangan', 'Frontend Developer', 'https://static.promediateknologi.id/crop/0x0:0x0/750x500/webp/photo/p1/664/2023/10/22/22-10-23-Klarifikasi-Hansen-Vendi-Agus-atas-tuduhan-penipuan-yang-pernah-menjeratnya-di-masa-lalu-2112099953.jpeg'),
              SizedBox(height: 16.0),
              buildAboutCard('AG Arka Atmaja', 'Frontend Developer', 'https://img.okezone.com/content/2023/03/24/33/2786670/sukses-berbisnis-ivan-gunawan-ungkap-sosok-yang-membuatnya-optimis-jalani-hidup-Lc1gmp038v.jpg'),
              SizedBox(height: 16.0),  
              buildAboutCard('Julius Fajar Fernando Seran aka Fuxy', 'Backend Developer', 'https://asset-a.grid.id/crop/177x0:1649x1080/x/photo/2020/10/27/55872995.png'),
              SizedBox(height: 16.0),
              buildAboutCard('Yohanes Beryan Fernando Putra', 'Backend Developer', 'https://i.pinimg.com/1200x/47/b8/68/47b8687e1a612547846960c69381aaaa.jpg'),
              SizedBox(height: 16.0),
              buildAboutCard('Ayub Stefanus dau Shynora', 'Backend Developer', 'https://pbs.twimg.com/media/Fyk6rLmacAAQ_1i.jpg'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAboutCard(String name, String description, [String? photoUrl]) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (photoUrl != null) ...[
              CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(photoUrl),
              ),
              SizedBox(width: 16.0),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(ResponsiveSizer(builder: (context, orientation, screenType) {
    return MaterialApp(
      home: AboutPage(),
    );
  }));
}
