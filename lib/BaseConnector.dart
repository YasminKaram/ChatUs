import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class BaseConnector{

  showLoading();
  showMessage(String Message);
  hideLoading();
}


class BaseViewModel <Con extends BaseConnector >extends ChangeNotifier{

  Con? connector;


}

abstract class BaseView <VM extends BaseViewModel,S extends StatefulWidget> extends State<S>
    implements BaseConnector{
  late VM viewModel;
  VM initMyViewModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel=initMyViewModel();
  }



  @override
  hideLoading() {
    Navigator.pop(context);
  }

  @override
  showLoading() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.transparent,
          title: Center(child: CircularProgressIndicator()),
        ));
  }

  @override
  showMessage(String Message) {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(

          title: Text("Message"),
          content: Text(Message),
          actions: [
            ElevatedButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("OK"))
          ],
        ));
  }

}