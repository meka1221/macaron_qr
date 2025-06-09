class Menu{

  String? title;
  String? category;
  String? price;
  String? image;
  String? description;
  String? rating;

  Menu(this.category,this.title,this.price,this.image,this.description,this.rating);

  String get name => title ?? '';

  static List<Menu> Cappuccino  =[
    Menu('Cappuccino', 'With Oat Milk', '4.20', 'assets/images/1.jpg','Cappuccino is an espresso-based coffee drink that originated in Italy,and is traditionally prepared with equal parts double espresso, steamed milk, and steamed milk foam.','4.8'),
    Menu('Cappuccino', 'With Chocolate', '3.14', 'assets/images/2.jpg','Cappuccino is an espresso-based coffee drink that originated in Italy,and is traditionally prepared with equal parts double espresso, steamed milk, and steamed milk foam.','4.7'),

  ];
  static List<Menu> hotCoffee =[
    Menu('Hot Coffee', 'Arabic coffee', '5.45', 'images/coffee.png','Hot coffee is a classic and popular beverage made by brewing roasted coffee beans with hot water. It can be enjoyed black or with milk and sugar.','4.9'),
    Menu('Hot Coffee', 'With nothing', '2.45', 'images/hotCoffee2.png','Hot coffee is a classic and popular beverage made by brewing roasted coffee beans with hot water. It can be enjoyed black or with milk and sugar.','4.5'),
    Menu('Hot Coffee', 'With milk', '3.45', 'images/hotCoffee3.png','Hot coffee is a classic and popular beverage made by brewing roasted coffee beans with hot water. It can be enjoyed black or with milk and sugar.','4.8'),

  ];
  static List<Menu> latte =[
    Menu('Latte', 'With Cow Milk', '2.8', 'images/latte.png','Latte is a coffee drink made with espresso and steamed milk.It is often topped with a small amount of milk foam.','5'),
    Menu('Latte', 'Iced latte coffee', '2.8', 'images/latte2.png','Latte is a coffee drink made with espresso and steamed milk.It is often topped with a small amount of milk foam.','4.8'),
    Menu('Latte', 'Iced latte coffee', '2.8', 'images/latte3.png','Latte is a coffee drink made with espresso and steamed milk.It is often topped with a small amount of milk foam.','4.9'),
    Menu('Latte', 'With Cow Milk', '2.8', 'images/latte4.png','Latte is a coffee drink made with espresso and steamed milk.It is often topped with a small amount of milk foam.','4.75'),
    Menu('Latte', 'Iced Vanilla Latte Recipe', '2.8', 'images/latte5.png','Latte is a coffee drink made with espresso and steamed milk.It is often topped with a small amount of milk foam.','4.3'),

  ];
  static List<Menu> coldCoffee =[
    Menu('Cold Coffee', 'With Cow Milk', '2.8', 'images/coldCoffee1.png','Cold coffee, also known as iced coffee, is a refreshing beverage made by chilling brewed coffee and serving it over ice. It can be sweetened and flavored to taste.','4.8'),
    Menu('Cold Coffee', 'With Cow Milk ', '2.8', 'images/coldCoffee2.png','Cold coffee, also known as iced coffee, is a refreshing beverage made by chilling brewed coffee and serving it over ice. It can be sweetened and flavored to taste.','4.55'),
    Menu('Cold Coffee', 'With Oreo', '2.8', 'images/coldCoffee3.png','Cold coffee, also known as iced coffee, is a refreshing beverage made by chilling freshly brewed coffee and serving it over ice. Perfect for hot summer days or as a revitalizing pick-me-up, cold coffee offers the familiar taste of coffee with a cool and invigorating twist. Whether enjoyed black or with a splash of milk and sweetener, cold coffee provides a delightful burst of flavor and refreshment','4.5'),

  ];
  static List<Menu> cakes  =[
    Menu('Cake', 'Cake with milk and strawberries', '8.20', 'images/cake.png','A strawberry cake is a light and fluffy sponge cake infused with the sweetness of strawberries. Layers of moist cake are filled with fresh strawberry filling and frosted with creamy frosting, creating a deliciously indulgent treat. Perfect for any celebration, its topped with fresh strawberries for a delightful finish.','4'),
    Menu('Cake', 'With chocolate', '5.14', 'images/cake2.png','Chocolate cake is a decadent dessert made with chocolate, flour, sugar, eggs,and other ingredients. It can be layered with chocolate frosting and decorated with chocolate shavings or sprinkles.','4.9'),
    Menu('CupCake', 'With Caramel', '6.14', 'images/CupCake.png','A cupcake is a small cake designed to serve one person, usually baked in a small,thin paper or aluminum cup. They are often topped with frosting and decorative sprinkles.','4.6'),
    Menu('Brownies', 'With Chocolate', '10.14', 'images/brownies.png','Brownies are dense, fudgy, and rich squares of chocolate goodness. '
        'They are typically made with cocoa powder, flour, sugar, eggs, butter, and chocolate chips or chunks.','4.7'),
    Menu('Donut', 'With Chocolate', '10.14', 'images/donut.png','A donut is a type of fried dough confection or dessert food. '
        'It is popular in many countries and is prepared in various forms as a sweet snack that can be homemade or purchased in bakeries.','4.8'),

  ];
  static List<Menu>popularList=[
    Menu('Cappuccino', 'With Oat Milk', '4.20', 'images/capp.png','Cappuccino is an espresso-based coffee drink that originated in Italy,and is traditionally prepared with equal parts double espresso, steamed milk, and steamed milk foam.','4.8'),
    Menu('Cold Coffee', 'With Cow Milk', '2.8', 'images/coldCoffee1.png',' Cold coffee, also known as iced coffee, is a refreshing beverage made by chilling brewed coffee and serving it over ice. It can be sweetened and flavored to taste. ','4.5'),
    Menu('Latte', 'With Cow Milk', '2.8', 'images/latte4.png','Latte is a coffee drink made with espresso and steamed milk.It is often topped with a small amount of milk foam.','4.87'),
    Menu('Hot Coffee', 'With milk', '3.45', 'images/hotCoffee3.png','Hot coffee is a classic and popular beverage made by brewing roasted coffee beans with hot water. It can be enjoyed black or with milk and sugar.','4.8'),
    Menu('Latte', 'Iced Vanilla Latte Recipe', '2.8', 'images/latte5.png','Latte is a coffee drink made with espresso and steamed milk.It is often topped with a small amount of milk foam.','4.6'),
    Menu('Cold Coffee', 'With Oreo', '2.8', 'images/coldCoffee3.png','Cold coffee, also known as iced coffee, is a refreshing beverage made by chilling brewed coffee and serving it over ice. It can be sweetened and flavored to taste. ','4.9'),
  ];

}