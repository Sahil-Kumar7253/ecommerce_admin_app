String discountPercent(int oldPrice,int newPrice){
  if(oldPrice == 0){
    return "0";
  }
  else{
    double percentage = ((oldPrice - newPrice) / oldPrice * 100);
    return percentage.toInt().toString();
  }
}