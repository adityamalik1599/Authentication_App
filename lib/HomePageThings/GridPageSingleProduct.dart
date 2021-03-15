import 'package:authentication_app/ProductPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridPageSingleProduct extends StatelessWidget {
   String product_name;
   String product_discountedPrice;
   String product_price;
   String ISBN;
 GridPageSingleProduct(
      {Key key, @required this.product_name, @required this.product_discountedPrice,  this.product_price,@required this.ISBN})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          Navigator.push(context,  MaterialPageRoute(builder: (context) =>
         ProductPage(product_discountedPrice: product_discountedPrice,product_name: product_name,product_price: product_price,ISBN: ISBN)));
        },
        child: Card(
          color: Colors.grey,
          child: GridTile(
            child: Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Icon(Icons.book,
              size: 48.0,),
            ),
            footer: Container(
                color: Colors.blue,
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                        children:<Widget>[ Text(product_discountedPrice,
                          style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 20.0
                          ),
                        ),
                        Text(product_price,
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough
                          ),

                        )
                        ]
                    )
                )
            ),
            header: Container(
              color: Colors.blue,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                    child: Text(product_name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:15.0
                      ),
                    )
                )
            ),
            ),
        ),
        ),
      );
  }
}
