import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_app/bloc/bloc/images_bloc.dart';
import 'package:firebase_app/bloc/events/image_event.dart';
import 'package:firebase_app/bloc/states/image_state.dart';
import 'package:firebase_app/utils/context_extension.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({Key? key}) : super(key: key);

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ImagesBloc>(context).add(ReadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Images'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/upload_image_screen');
            },
            icon: Icon(Icons.camera),
          ),
        ],
      ),
      body: BlocConsumer<ImagesBloc, ImageState>(
        listenWhen: (previous, current) => current is ProcessState && current.processType == ProcessType.delete,
        listener: (context,state){
          state as ProcessState;
          context.showSnackBar(message: state.message, error: !state.success);
        },
        buildWhen: (previous,current) => current is LoadingState || current is ReadState,
        builder: (context, state){
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          }else if(state is ReadState && state.references.isNotEmpty){
            return GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                scrollDirection: Axis.vertical,
                itemCount: state.references.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        FutureBuilder<String>(
                          future: state.references[index].getDownloadURL(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasData) {
                              // return CachedNetworkImage(
                              //   cacheKey: snapshot.hashCode.toString(),
                              //   imageUrl: snapshot.data!,
                              //   placeholder: (context, url) => CircularProgressIndicator(),
                              //   errorWidget: (context, url, error) => Icon(Icons.error),
                              // );
                              return CachedNetworkImage(
                                imageUrl: snapshot.data!,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              );
                            } else {
                              return const Center(
                                child: Icon(
                                  Icons.image,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              );
                            }
                          }
                        ),

                        Align(
                          alignment: AlignmentDirectional.bottomCenter,
                          child: Container(
                            height: 50,
                            padding: EdgeInsetsDirectional.only(start: 10),
                            width: double.infinity,
                            color: Colors.black45,
                            child: Row(
                              children: [
                            Expanded(
                            child: Text(
                              state.references[index].name,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: (){
                                BlocProvider.of<ImagesBloc>(context).add(DeleteEvent(index));
                              },
                            icon: Icon(Icons.delete),
                          color: Colors.red.shade800,
                        ),
                      ],
                    ),
                  ),
                  )
                  ],
                  ),
                  );
                });
          } else {
            return Center(
              child: Text(
                'NO IMAGES',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
