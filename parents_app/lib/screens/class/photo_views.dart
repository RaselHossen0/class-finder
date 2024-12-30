import 'package:cached_network_image/cached_network_image.dart';
import 'package:class_finder/models/class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interactiveviewer_gallery_plus/hero_dialog_route.dart';
import 'package:interactiveviewer_gallery_plus/interactiveviewer_gallery_plus.dart';
import 'package:video_player/video_player.dart';

import 'display_gesture.dart';
import 'live_photo_player.dart';

class DemoSourceEntity {
  int id;
  String url;
  String? previewUrl;
  String type;

  DemoSourceEntity(this.id, this.type, this.url, {this.previewUrl});
}

class InteractiveviewDemoPage extends StatefulWidget {
  static final String sName = "/";
  final ClassModel classModel;

  const InteractiveviewDemoPage({super.key, required this.classModel});

  @override
  _InteractiveviewDemoPageState createState() =>
      _InteractiveviewDemoPageState();
}

class _InteractiveviewDemoPageState extends State<InteractiveviewDemoPage> {
  List<DemoSourceEntity> sourceList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sourceList = widget.classModel.media
        .map((e) => DemoSourceEntity(
            e.id,
            e.type == 'photo'
                ? 'image'
                : e.type == 'video'
                    ? 'video'
                    : 'video',
            e.url,
            previewUrl: e.url))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        title: Text('Class Photos and Videos'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Wrap(
          children: sourceList.map((source) => _buildItem(source)).toList(),
        ),
      ),
    );
  }

  Widget _buildItem(DemoSourceEntity source) {
    return Hero(
      tag: source.id,
      placeholderBuilder: (BuildContext context, Size heroSize, Widget child) {
        // keep building the image since the images can be visible in the
        // background of the image gallery
        return child;
      },
      child: GestureDetector(
        onTap: () => _openGallery(source),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CachedNetworkImage(
              imageUrl:
                  source.type == 'video' ? source.previewUrl! : source.url,
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
            source.type == 'video'
                ? Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  void _openGallery(DemoSourceEntity source) {
    Navigator.of(context).push(
      HeroDialogRoute<void>(
        // DisplayGesture is just debug, please remove it when use
        builder: (BuildContext context) => DisplayGesture(
          child: InteractiveviewerGalleryPlus<DemoSourceEntity>(
            sources: sourceList,
            initIndex: sourceList.indexOf(source),
            itemBuilder: itemBuilder,
            onPageChanged: (int pageIndex) {
              print("nell-pageIndex:$pageIndex");
            },
          ),
        ),
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index, bool isFocus) {
    DemoSourceEntity sourceEntity = sourceList[index];
    if (sourceEntity.type == 'video') {
      return DemoVideoItem(
        sourceEntity,
        isFocus: isFocus,
      );
    } else if (sourceEntity.type == 'live') {
      return Center(
        child: Hero(
          tag: sourceEntity.id,
          child: LivePhotoWrapper(
            key: ValueKey(sourceEntity.url),
            liveUrl:
                'https://quandaoimages.fixtime.com/caf69670-8584-11ef-b197-f5d39dc8e39e.MOV',
            height: MediaQuery.of(context).size.width * 0.85,
            markSize: const Size(57, 24),
            width: MediaQuery.of(context).size.width,
            canVideoAutoPlay: true,
            coverPic: CachedNetworkImage(
              imageUrl: sourceEntity.url,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    }
    {
      return DemoImageItem(sourceEntity);
    }
  }
}

class DemoImageItem extends StatefulWidget {
  final DemoSourceEntity source;

  DemoImageItem(this.source);

  @override
  _DemoImageItemState createState() => _DemoImageItemState();
}

class _DemoImageItemState extends State<DemoImageItem> {
  @override
  void initState() {
    super.initState();
    print('initState: ${widget.source.id}');
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose: ${widget.source.id}');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: Center(
        child: Hero(
          tag: widget.source.id,
          child: CachedNetworkImage(
            imageUrl: widget.source.url,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class DemoVideoItem extends StatefulWidget {
  final DemoSourceEntity source;
  final bool? isFocus;

  DemoVideoItem(this.source, {this.isFocus});

  @override
  _DemoVideoItemState createState() => _DemoVideoItemState();
}

class _DemoVideoItemState extends State<DemoVideoItem> {
  VideoPlayerController? _controller;
  late VoidCallback listener;
  String? localFileName;

  _DemoVideoItemState() {
    listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
  }

  @override
  void initState() {
    super.initState();
    print('initState: ${widget.source.id}');
    init();
  }

  init() async {
    _controller = VideoPlayerController.network(widget.source.url);
    // loop play
    _controller!.setLooping(true);
    await _controller!.initialize();
    setState(() {});
    _controller!.addListener(listener);
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose: ${widget.source.id}');
    _controller!.removeListener(listener);
    _controller?.pause();
    _controller?.dispose();
  }

  @override
  void didUpdateWidget(covariant DemoVideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isFocus! && !widget.isFocus!) {
      // pause
      _controller?.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _controller!.value.isInitialized
        ? Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _controller!.value.isPlaying
                        ? _controller!.pause()
                        : _controller!.play();
                  });
                },
                child: Hero(
                  tag: widget.source.id,
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                ),
              ),
              _controller!.value.isPlaying == true
                  ? SizedBox()
                  : IgnorePointer(
                      ignoring: true,
                      child: Icon(
                        Icons.play_arrow,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
            ],
          )
        : Theme(
            data: ThemeData(
                cupertinoOverrideTheme:
                    CupertinoThemeData(brightness: Brightness.dark)),
            child: CupertinoActivityIndicator(radius: 30));
  }
}
