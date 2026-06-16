import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clothing_shop/clothing_shop_module/models/product_model.dart';
import 'package:clothing_shop/clothing_shop_module/services/cloth_service.dart';
import 'package:clothing_shop/clothing_shop_module/states_logics/gridview_logic.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ClothScreen extends StatefulWidget {
  const ClothScreen({super.key});

  @override
  State<ClothScreen> createState() => _ClothScreenState();
}

class _ClothScreenState extends State<ClothScreen> {
  bool _isGridView = true;
  final _scroller = ScrollController();
  bool _showUpIcon = false;

  @override
  void initState() {
    super.initState();
    _scroller.addListener(() {
      if (_scroller.position.pixels > 500) {
        setState(() {
          _showUpIcon = true;
        });
      } else {
        setState(() {
          _showUpIcon = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isGridView = context.watch<GridviewLogic>().isGridView;

    return Scaffold(
      appBar: AppBar(
        title: Text("Products", style: GoogleFonts.battambang(fontSize: 25)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("settings");
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      floatingActionButton: _showUpIcon ? _buildFloating() : null,
      body: _buildBody(),
    );
  }

  Widget _buildFloating() {
    return FloatingActionButton(
      shape: CircleBorder(),
      onPressed: () {
        _scroller.animateTo(
          0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
      child: Icon(Icons.arrow_upward),
    );
  }

  final _clothService = ClothService();

  late Future<List<ProductModel>> _apiData = _clothService.getCloths();

  Widget _buildBody() {
    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _apiData = _clothService.getCloths();
          });
        },
        child: FutureBuilder<List<ProductModel>>(
          future: _apiData,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error: ${snapshot.error.toString()}"),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _apiData = _clothService.getCloths();
                        });
                      },
                      child: Text("Retry"),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return _buildGrideView(snapshot.data!);
            }
            return _buildSkeleton(snapshot.data);
          },
        ),
      ),
    );
  }

  Widget _buildSkeleton(List<ProductModel>? items) {
    if (items == null || items.isEmpty) {
      return Icon(Icons.list);
    }
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    double screenWidth = MediaQuery.of(context).size.width;

    return Skeletonizer(
      child: ListView(
        controller: _scroller,
        children: [
          SizedBox(height: 10),
          _buildSlideShow(items),
          SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth > 1200 ? (screenWidth - 1200) / 2 : 8,
              vertical: 10,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _isGridView
                  ? (isLandscape ? 4 : 2)
                  : (isLandscape ? 2 : 1),
              childAspectRatio: _isGridView ? 3 / 5 : 4 / 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: item.image,
                          width: double.maxFinite,
                          height: double.maxFinite,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(color: Colors.grey[300]),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        style: TextStyle(fontWeight: FontWeight.bold),
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "USD ${item.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGrideView(List<ProductModel>? items) {
    if (items == null || items.isEmpty) {
      return Icon(Icons.list);
    }
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    double screenWidth = MediaQuery.of(context).size.width;

    return ListView(
      controller: _scroller,
      children: [
        SizedBox(height: 10),
        _buildSlideShow(items),
        SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth > 1200 ? (screenWidth - 1200) / 2 : 8,
            vertical: 10,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _isGridView
                ? (isLandscape ? 4 : 2)
                : (isLandscape ? 2 : 1),
            childAspectRatio: _isGridView ? 3 / 5 : 4 / 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return InkWell(
              onTap: () {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed('detail', arguments: item);
              },
              child: Card(
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: item.image,
                          width: double.maxFinite,
                          height: double.maxFinite,
                          fit: BoxFit.scaleDown,
                          placeholder: (context, url) =>
                              Container(color: Colors.grey[300]),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        style: TextStyle(fontWeight: FontWeight.bold),
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "USD ${item.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSlideShow(List<ProductModel> items) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        viewportFraction: 0.9,
        aspectRatio: 2.1,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        pauseAutoPlayOnTouch: true,
      ),
      itemCount: items.length,
      itemBuilder: (context, index, viewIndex) {
        final item = items[index];

        return InkWell(
          onTap: () {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed('detail', arguments: item);
          },
          child: Card(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.image,
                        width: double.maxFinite,
                        height: double.maxFinite,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item.title,
                    style: GoogleFonts.battambang(fontSize: 15),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
