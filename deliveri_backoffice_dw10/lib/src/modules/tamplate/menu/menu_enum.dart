enum Menu{
  
  paymentType(
    '/payment-type/',  
    'payment_type_ico.png',  
    'payment_type_ico_selected.png',
    'Admistrar Formas de Pagamento'  
  ),
  products(
    '/products/',  
    'product_ico.png',  
    'product_ico_selected.png',
    'Admistrar Produtos'
  ),
  orders(
    '/order/',  
    'order_ico.png',  
    'order_ico_selected.png',
    'Pedidos do dia'
  );

  final String route; 
  final String assetsIcon;
  final String assetsIconSelected;
  final String label;

  const Menu(this.route, this.assetsIcon, this.assetsIconSelected, this.label);





}