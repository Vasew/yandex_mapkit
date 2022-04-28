part of yandex_mapkit;

class YandexMap extends StatefulWidget {
  /// A `Widget` for displaying Yandex Map
  const YandexMap({
    Key key,
    this.onMapCreated,
    this.mapObjects = const [],
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
      if(widget.mapObjects.isNotEmpty){
        var mapObjectsJson = widget.mapObjects.first.toJson();
        centerPoint = [mapObjectsJson['point']['latitude'], mapObjectsJson['point']['longitude']];
        print("!!! Map init ${centerPoint}");
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
              {"type": "Feature", "id": 0, "geometry": {"type": "Point", "coordinates": [55.74733106245,37.628620694442]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 1, "geometry": {"type": "Point", "coordinates": [55.73192067419,37.611633992729]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 2, "geometry": {"type": "Point", "coordinates": [55.722581944124,37.560337240405]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 3, "geometry": {"type": "Point", "coordinates": [55.685587962597,37.621657321426]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 4, "geometry": {"type": "Point", "coordinates": [55.816303,37.574363]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 5, "geometry": {"type": "Point", "coordinates": [55.755813989771,37.40201210416]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 6, "geometry": {"type": "Point", "coordinates": [55.73765394535,37.618482167428]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 7, "geometry": {"type": "Point", "coordinates": [55.777690972592,37.6435405159]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 8, "geometry": {"type": "Point", "coordinates": [55.73765394535,37.618482167428]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 9, "geometry": {"type": "Point", "coordinates": [55.678615,37.781596]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 10, "geometry": {"type": "Point", "coordinates": [55.700162,37.506496]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 11, "geometry": {"type": "Point", "coordinates": [55.815413,37.738045]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 12, "geometry": {"type": "Point", "coordinates": [55.682189,37.868198]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 13, "geometry": {"type": "Point", "coordinates": [55.929177,37.520653]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 14, "geometry": {"type": "Point", "coordinates": [55.611963,37.537586]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 15, "geometry": {"type": "Point", "coordinates": [55.611963,37.537586]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 16, "geometry": {"type": "Point", "coordinates": [55.901945,37.585682]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 17, "geometry": {"type": "Point", "coordinates": [55.918404553613,37.724993839264]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 18, "geometry": {"type": "Point", "coordinates": [55.738044,37.84667]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 19, "geometry": {"type": "Point", "coordinates": [55.734658,37.831021]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 20, "geometry": {"type": "Point", "coordinates": [55.641239,37.35981]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 21, "geometry": {"type": "Point", "coordinates": [55.641229,37.656173]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 22, "geometry": {"type": "Point", "coordinates": [55.547036,37.543237]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 23, "geometry": {"type": "Point", "coordinates": [55.586405,37.648205]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 24, "geometry": {"type": "Point", "coordinates": [55.893935,37.525163]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 25, "geometry": {"type": "Point", "coordinates": [55.798055825134,37.985142539672]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 26, "geometry": {"type": "Point", "coordinates": [55.805827,37.515146]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 27, "geometry": {"type": "Point", "coordinates": [55.822493,37.823358]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 28, "geometry": {"type": "Point", "coordinates": [55.619574,37.752149]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 29, "geometry": {"type": "Point", "coordinates": [55.682752592791,37.722895399278]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 30, "geometry": {"type": "Point", "coordinates": [55.647041,37.411741]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 31, "geometry": {"type": "Point", "coordinates": [55.917006,37.997147]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 32, "geometry": {"type": "Point", "coordinates": [55.766486,37.622333]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 33, "geometry": {"type": "Point", "coordinates": [55.898654,37.629322]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 34, "geometry": {"type": "Point", "coordinates": [55.793227,37.559883]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 35, "geometry": {"type": "Point", "coordinates": [55.709028,37.620761]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 36, "geometry": {"type": "Point", "coordinates": [55.767053,37.829108]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.670133,37.552427]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.683097,37.549175]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.733954,37.665713]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.852809,37.585817]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.707431,37.591656]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.658835,37.741899]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.766668,37.381585]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.61813,37.507484]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.93123532166,37.494496322754]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.891772988455,37.749017631815]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.706409,37.020969]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.789608,37.752481]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.630223,37.474507]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.669929,37.871344]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.686685,37.305767]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.692125,37.896508]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.588262,37.724357]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.718096,37.784066]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.750515,37.819514]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.625171948386,37.761224149292]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.853496,38.440681]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.424285569285,37.538242]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.853245942035,37.351462733292]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.761583617133,37.568341959035]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.864183,37.397822]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.916002,37.846301]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.877344,37.559191]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.58201428,37.9122195]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.551587,37.70259]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.887604,37.67845]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.709946,37.74419]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.655453,37.57201]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.885154,37.406598]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.805976,38.435684]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.869208,37.663018]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.663527,37.48685]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.708151,37.359549]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.59461078,37.59913]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.81911,37.338205]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.72978434,37.73093467]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.80840128,38.9882935]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.60967528,37.720106]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.683752,37.491063]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.498974,37.567905]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.752211472311,37.88752008532]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.653278834177,37.843904910381]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.991040656076,37.219373396184]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.637564518147,37.75770699186]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.897630522321,37.667340876429]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.916746971461,37.757688404885]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.863918191891,37.54552072122]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.857186759866,37.431861689314]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.983691417119,37.142190149569]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.60342550825,37.490597119933]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.810631429433,37.383176924554]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.911155243299,37.395751120415]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.840151929207,37.491280676689]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.624490521941,37.709119671874]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.912596772375,37.584259858732]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.743733,37.507951]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.999563643422,37.88191112361]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.781671,37.705238]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.809401037978,37.464568749511]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.640933106733,37.530669108472]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.74796,37.706907]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.653142550391,37.645820926182]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.523913,37.517274]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.788480726235,37.678618978015]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.707591193361,37.386773179523]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.451967,37.763207]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.545216,37.69927]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.686098,37.85331]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.653644,37.620698]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.710692,37.675109]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.865531,37.704889]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.604529,37.356648]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.695875,37.664905]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.630461,37.658652]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.885575,37.602166]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}},
{"type": "Feature", "id": 37, "geometry": {"type": "Point", "coordinates": [55.803818,37.800541]}, "properties": {"balloonContentHeader": "", "balloonContentBody": ""}}

          ] 
      } """;
      //var dJson = dataJson.toJson();

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
