part of yandex_mapkit;

class YandexMap extends StatefulWidget {
  /// A `Widget` for displaying Yandex Map
  const YandexMap({
    Key key,
    this.onMapCreated,
    this.mapObjects = const [],
    this.mapObjectsWeb = const [],
    this.onMapTap,
    this.onMapLongTap,
    this.onMapSizeChanged,
    this.onMapRendered,
  }) : super(key: key);

  static const String viewType = 'yandex_mapkit/yandex_map';

  /// Callback method for when the map is ready to be used.
  ///
  /// Pass to [YandexMap.onMapCreated] to receive a [YandexMapController] when the
  /// map is created.
  final MapCreatedCallback onMapCreated;
  
  /// Map objects to show on map
  final List<MapObject> mapObjects;
  
  /// Map objects to show on map web
  final List<dynamic> mapObjectsWeb;

  /// Called once when [YandexMap] is first rendered on screen.
  ///
  /// The difference between [YandexMap.onMapCreated] and this callback
  /// is that [YandexMap.onMapCreated] is called before the map is actually rendered.
  ///
  /// This happens because native view creation is asynchronous.
  /// Our widget is created before flutter sizes and paints the corresponding native view.
  final GenericCallback onMapRendered;

  /// Called every time a [YandexMap] is resized.
  final ArgumentCallback<MapSize> onMapSizeChanged;

  /// Called every time a [YandexMap] is tapped.
  final ArgumentCallback<Point> onMapTap;

  /// Called every time a [YandexMap] is long tapped.
  final ArgumentCallback<Point> onMapLongTap;

  @override
  _YandexMapState createState() => _YandexMapState();
}

class _YandexMapState extends State<YandexMap> {
  YandexMapController _controller;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: YandexMap.viewType,
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
          Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
        ].toSet(),
      );
    } else if(kIsWeb) {
      var centerPoint;
      var arrayWeb = "";
      if(widget.mapObjectsWeb.isNotEmpty){
        centerPoint = [widget.mapObjectsWeb.first['latitude'], widget.mapObjectsWeb.first['longitude']];
        for (var element in widget.mapObjectsWeb) { arrayWeb = '$arrayWeb {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": ${element.toString()}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},'; }
      } else {
        centerPoint = [55.76, 37.64];
      }

      DivElement frame = DivElement();
      DivElement divElement = DivElement()
          ..id = "map"
          ..style.width = '100%'
          ..style.height = '100%';
      frame.append(divElement);

      var dataJson = """ { 
          "type": "FeatureCollection",
          "features": [
              {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": {latitude: 55.75222, longitude: 37.61556}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}, {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": {latitude: 55.75222, longitude: 37.61556}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}, {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": {latitude: 55.75222, longitude: 37.61556}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}, {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": {latitude: 55.75222, longitude: 37.61556}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}, {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": {latitude: 55.7410897, longitude: 37.6143385}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}, {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": {latitude: 55.7410897, longitude: 37.6143385}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}, {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": {latitude: 55.7410897, longitude: 37.6143385}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}, {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": {latitude: 55.7896079, longitude: 37.7525343}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}, {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": {latitude: 55.781743, longitude: 37.705139}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}, {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": {latitude: 55.788576, longitude: 37.678685}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}, {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": {latitude: 55.815245, longitude: 37.7376415}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}, {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": {latitude: 55.604529, longitude: 37.356648}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}, {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": {latitude: 55.718142, longitude: 37.7840895}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}, {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": {latitude: 55.729833, longitude: 37.731021}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}, {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": {latitude: 55.709946, longitude: 37.74419}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}, {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": {latitude: 55.733954, longitude: 37.665713}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}, {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": {latitude: 55.685891, longitude: 37.853848}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}, {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": {latitude: 55.6587246, longitude: 37.741903}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}, {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": {latitude: 55.678764, longitude: 37.781669}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}, {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": {latitude: 55.747363, longitude: 37.707098}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}, {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": {latitude: 55.750874, longitude: 37.819927}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}, {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": {latitude: 55.767053, longitude: 37.829108}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}, {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": {latitude: 55.734658, longitude: 37.831021}}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
              {"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": $centerPoint}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}
          ] 
      } """;
      //var dJson = dataJson.toJson();

        print("!!! Map init web $dataJson");
      
      ScriptElement scriptElement = new ScriptElement();
      var script = """ setTimeout(function(){ ymaps.ready(init);
        function init () {
            var myMap = new ymaps.Map('map', {
                    center: $centerPoint,
                    zoom: 10,
                    controls: ['zoomControl']
                },
                {suppressMapOpenBlock: true}
                ),
                objectManager = new ymaps.ObjectManager({
                    clusterize: true,
                    gridSize: 32,
                    clusterDisableClickZoom: true
                });
        
            objectManager.objects.options.set('preset', 'islands#greenDotIcon');
            objectManager.clusters.options.set('preset', 'islands#greenClusterIcons');
            myMap.geoObjects.add(objectManager);
            objectManager.add($dataJson);
        }
        },1000);
        """;
      scriptElement.innerHtml = script;
      frame.append(scriptElement);

      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(
          YandexMap.viewType,
              (int viewId) => frame);
      return HtmlElementView(viewType: YandexMap.viewType);
    } else {
      return UiKitView(
        viewType: YandexMap.viewType,
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
          Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
        ].toSet(),
      );
    }
  }

  void _onPlatformViewCreated(int id) {
    _controller = YandexMapController.init(id, this);

    if (widget.onMapCreated != null) {
      widget?.onMapCreated(_controller);
    }
  }

  void onMapRendered() {
    if (widget.onMapRendered != null) {
      widget.onMapRendered();
    }
  }

  void onMapSizeChanged(MapSize size) {
    if (widget.onMapSizeChanged != null) {
      widget.onMapSizeChanged(size);
    }
  }

  void onMapTap(Point point) {
    if (widget.onMapTap != null) {
      widget.onMapTap(point);
    }
  }

  void onMapLongTap(Point point) {
    if (widget.onMapLongTap != null) {
      widget.onMapLongTap(point);
    }
  }
}
