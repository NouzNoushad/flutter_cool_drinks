import 'package:cool_drinks_ui/database/db.dart';
import 'package:cool_drinks_ui/home_page.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Db database = Db();
  List<Map> coolDrinksList = [];
  double shippingPrice = 0.8;
  @override
  void initState() {
    database.open();
    getCoolDrinksData();
    super.initState();
  }

  void getCoolDrinksData() {
    Future.delayed(const Duration(seconds: 1), () async {
      coolDrinksList = await database.db!.rawQuery("SELECT * FROM drinks");
      setState(() {});
      print(coolDrinksList);
    });
  }

  @override
  Widget build(BuildContext context) {
    num total = coolDrinksList.fold(0, (prev, value) => prev + value["price"]);
    return Scaffold(
      backgroundColor: Colors.white,
      bottomSheet: cartBottomSheet(total),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            cartAppBar(),
            Container(
              height: 350,
              width: double.infinity,
              // color: Colors.yellow,
              child: ListView(
                children: coolDrinksList.map((drinks) {
                  return Container(
                    height: 100,
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Stack(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 238, 227),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: coolDrinksCartDetails(drinks),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              await database.db!.rawDelete(
                                  "DELETE FROM drinks WHERE id = ? ", [
                                drinks["id"],
                              ]);
                              // pop up message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: Colors.white,
                                    content: Text(
                                      "Cool Drinks data deleted from the Cart",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 37, 0, 100),
                                      ),
                                    )),
                              );
                              getCoolDrinksData();
                            },
                            child: Transform(
                              transform: Matrix4.translationValues(8, -8, 0),
                              child: CircleAvatar(
                                backgroundColor: Colors.grey.shade300,
                                radius: 12,
                                child: const Icon(Icons.close,
                                    size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Container(
              height: 65,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1.2, color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Promo Code",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    width: 75,
                    height: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 37, 0, 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Apply",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sub Total: ",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "\$${total.toStringAsFixed(2)}", // find total and use here
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Shipping: ",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "\$$shippingPrice", // find total and use here
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 20,
                  color: Colors.grey.shade700,
                ),
              ],
            ),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }

  Widget cartBottomSheet(num total) => Container(
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
              "\$${(total + shippingPrice).toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            Container(
              height: 40,
              width: 180,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Proceed To Checkout",
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

  Widget coolDrinksCartDetails(Map<dynamic, dynamic> drinks) => Row(
        children: [
          Container(
            width: 80,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Center(
                  child: Image.asset(
                    "assets/${drinks["image"]}",
                    height: 90,
                    width: 30,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                drinks["name"],
                style: const TextStyle(
                  fontSize: 13.5,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "Volume: ${drinks["volume"]}",
                style: const TextStyle(
                  fontSize: 8.5,
                  letterSpacing: 0.5,
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "\$${drinks["price"]}",
                style: const TextStyle(
                  fontSize: 17,
                  color: Color.fromARGB(255, 37, 0, 100),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      );

  Widget cartAppBar() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              // navigate to home page
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            child: const Icon(
              Icons.arrow_back,
              size: 20,
            ),
          ),
          const Text(
            "My Cart",
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      );
}
