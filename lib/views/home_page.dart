import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:my_project/services/storage_service.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  StorageService _storageService = StorageService();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: widget._storageService.getproductdata(null),
        builder: (context, snapshot) {
          var data = snapshot.data;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Data Found'));
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 200, // Carousel height
              child: Swiper(
                itemCount: snapshot.data!.length > 3 ? 3 : snapshot.data!.length ,

                autoplay: true,
                autoplayDelay: 3000, // 3 seconds

                pagination: SwiperPagination(
                  alignment: Alignment.bottomCenter,
                  builder: DotSwiperPaginationBuilder(
                    color: Colors.grey, // inactive dot color
                    activeColor: Colors.blue, // active dot color
                    size: 8.0,
                    activeSize: 12.0,
                  ),
                ),

                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16), // rounded corners
                    child: Container(
                      
                      color: Colors.amber,
                      // decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(url))),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
