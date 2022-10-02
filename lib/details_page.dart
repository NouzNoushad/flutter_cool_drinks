import 'package:cool_drinks_ui/cart_page.dart';
import 'package:cool_drinks_ui/database/db.dart';
import 'package:cool_drinks_ui/model/cool_drinks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CoolDrinksDetails extends StatefulWidget {
  final CoolDrinks drinks;
  const CoolDrinksDetails({super.key, required this.drinks});

  @override
  State<CoolDrinksDetails> createState() => _CoolDrinksDetailsState();
}

class _CoolDrinksDetailsState extends State<CoolDrinksDetails> {
  Db database = Db();
  @override
  void initState() {
    database.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomSheet: coolDrinksBottomSheet(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            detailsAppBar(),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 320,
              width: double.infinity,
              // color: Colors.yellow,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipPath(
                      clipper: CustomPath(),
                      child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              widget.drinks.color,
                              Colors.black,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      "assets/${widget.drinks.image}",
                      height: 310,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.drinks.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      "Volume: ${widget.drinks.volume}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                RatingBar.builder(
                  onRatingUpdate: (value) {},
                  itemCount: 5,
                  itemSize: 18,
                  allowHalfRating: true,
                  initialRating: widget.drinks.rating,
                  unratedColor: Colors.grey.shade400,
                  itemBuilder: (contex, index) {
                    return const Icon(Icons.star,
                        color: Color.fromARGB(255, 37, 0, 100));
                  },
                ),
              ],
            ),
            Divider(
              color: Colors.grey.shade700,
              height: 30,
            ),
            const Text(
              'Product Description',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Soft drink, any of a class of nonalcoholic drinks, not carbonated, normally containing a natural or artificial sweetening agent, edible acids, natural or artificial flavours and sometimes juice. Natural flavours are derived from fruits, nuts, berries, roots, herbs and other plant sources",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget coolDrinksBottomSheet() => Container(
        height: 100,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 37, 0, 100),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "\$${widget.drinks.price}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              height: 30,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(20),
                  right: Radius.circular(20),
                ),
                border: Border.all(width: 1, color: Colors.white),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (widget.drinks.count <= 1) {
                          return;
                        } else {
                          widget.drinks.count--;
                        }
                      });
                    },
                    child: const Icon(
                      Icons.remove,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.drinks.count.toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.drinks.count++;
                      });
                    },
                    child: const Icon(
                      Icons.add,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              width: 60,
              child: ElevatedButton(
                onPressed: () async {
                  await database.db!.rawInsert(
                      "INSERT INTO drinks (name, image, volume, price) VALUES (?, ?, ?, ?);",
                      [
                        widget.drinks.name,
                        widget.drinks.image,
                        widget.drinks.volume,
                        widget.drinks.price,
                      ]);
                  // pop up message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: Colors.white,
                        content: Text(
                          "Cool Drinks data added to the Cart",
                          style: TextStyle(
                            color: Color.fromARGB(255, 37, 0, 100),
                          ),
                        )),
                  );
                  // navigate to the cart page
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Cart",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color.fromARGB(255, 37, 0, 100),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget detailsAppBar() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              size: 20,
            ),
          ),
          const Icon(Icons.segment),
        ],
      );
}

class CustomPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double width = size.width;
    double height = size.height;

    path.moveTo(50, 0); // (start point)
    path.quadraticBezierTo(20, 0, 20, 35); // (middle point, end point)

    path.lineTo(0, height - 40); // (start point)
    path.quadraticBezierTo(0, height, 50, height); // (middle point, end point)

    path.lineTo(width - 50, height); // (start point)
    path.quadraticBezierTo(
        width, height, width, height - 40); // (middle point, end point)

    path.lineTo(width - 20, 35); // (start point)
    path.quadraticBezierTo(
        width - 20, 0, width - 50, 0); // (middle point, end point)

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
