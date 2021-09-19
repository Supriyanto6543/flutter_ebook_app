import 'package:ebook_app/contoller/con_latest.dart';
import 'package:ebook_app/model/ebook/model_ebook.dart';
import 'package:ebook_app/view/detail/ebook_detail.dart';
import 'package:ebook_app/widget/ebook_routers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Library extends StatefulWidget {

  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {

  Future<List<ModelEbook>>? getLatest;
  List<ModelEbook> listLatest = [];

  @override
  void initState() {
    super.initState();
    getLatest = fetchLatest(listLatest);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0,
        title: Text('Library', style: TextStyle(
            color: Colors.black
        ),),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: getLatest,
            builder: (BuildContext context, AsyncSnapshot<List<ModelEbook>> snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              child: Image.network(
                                '${listLatest[index].photo}',
                                height: 20.0.h,
                                width: 30.0.w,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            SizedBox(width: 0.8.h,),
                            Container(
                              child:Text('${listLatest[index].title}', style: TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.w500
                              ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                              width: 30.0.w,
                            ),
                          ],
                        ),
                      ),
                      onTap: (){
                        pushPage(context, EbookDetail(ebookId: listLatest[index].id, status: listLatest[index].statusNews));
                      },
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 5.5 / 9.0,
                  ),
                );
              }else{
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.6, color: Colors.blue,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
