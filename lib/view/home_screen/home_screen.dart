import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:machine_test/controller/home_screen_controller.dart';
import 'package:machine_test/model/data_model.dart';
import 'package:machine_test/services/data_list_service.dart';
import 'package:machine_test/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DataModel> dataLists = [];
  bool isLoading = true;
  String from = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchHiveData();
    });
  }

  Future<void> fetchHiveData() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.none)) {
      // online fetch from api
      try {
        final result = await DataListService.fetchDataLists();
        setState(() {
          dataLists = result;
          isLoading = false;
          from = "API";
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {
      // offline mode
      final fetchHiveData = await HomeScreenController.fetchDatas();
      setState(() {
        dataLists = fetchHiveData;
        isLoading = false;
        from = "Hive";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text("List of data from $from", style: TextStyle(
                color: Colors.white
              ),),
              centerTitle: true,
              elevation: 1,
              backgroundColor: primaryColor,
            ),
        body: isLoading 
        ? Center(
          child: CircularProgressIndicator(),
        )
        :dataLists.isEmpty
        ? Center(child: Text("No data found"))
        
        : Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ListView.separated(
              itemBuilder: (context, index){
                final data = dataLists[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: primaryColor,
                        
                      )
                    ),
                    child: ExpansionTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name: ${data.name ?? "n/a"}",
                          style: Theme.of(context).textTheme.titleMedium,),
                          Text("Email: ${data.email ?? "n/a"}"),
                        ],
                      ),
                      childrenPadding: EdgeInsets.symmetric(horizontal: 15),
                      
                      
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Description",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                            ),),
                          ],
                        ),
                        Text(data.body ?? "No description")
                      ],),
                  ),
                );
              }, separatorBuilder: (context, index){
                return const SizedBox(
                  height: 20,
                );
              }, itemCount: dataLists.length),
          ),
        ),
      )),
    );
  }
}
