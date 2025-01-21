class CommonFunctions{


  static bool getCheckforGridShow({required bool isEditPressedYellow,required bool hideImage,required bool hideTitle}){
    if(!isEditPressedYellow){
      if(hideImage ==true&&hideTitle==true){
        return false;
      }
    }
  return true;
  }
}