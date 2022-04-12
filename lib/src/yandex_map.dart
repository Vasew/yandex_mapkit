part of yandex_mapkit;

class YandexMap extends StatefulWidget {
  /// A `Widget` for displaying Yandex Map
  const YandexMap({
    Key key,
    this.onMapCreated,
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
    }  else if(kIsWeb) {
      DivElement frame = DivElement();
      StyleElement styleElement = StyleElement();
      styleElement.type = "text/css";
      styleElement.innerHtml = """ html, body { height: 100% } #map { height: 100% } a { color: #04b; text-decoration: none; } a:visited { color: #04b; } a:hover { color: #f50000; } """;   // here css style
      frame.append(styleElement); 
      DivElement divElement = DivElement();
      divElement.id = "map";
      frame.append(divElement);
      ScriptElement scriptElement = new ScriptElement();
      var script = """  function init () {
            var myMap = new ymaps.Map('map', {
                    center: [55.76, 37.64],
                    zoom: 10
                }, {
                    searchControlProvider: 'yandex#search'
                }),
                objectManager = new ymaps.ObjectManager({
                    clusterize: true,
                    gridSize: 32,
                    clusterDisableClickZoom: true
                });
        
            objectManager.objects.options.set('preset', 'islands#greenDotIcon');
            objectManager.clusters.options.set('preset', 'islands#greenClusterIcons');
            myMap.geoObjects.add(objectManager);
        
            \$.ajax({
                url: "data.json"
            }).done(function(data) {
                objectManager.add(data);
            });
        
        }
        
        """;
      scriptElement.innerHtml = script;
      frame.append(scriptElement);

      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(
          'yandex_mapkit',
              (int viewId) => frame);
      return HtmlElementView(viewType: 'yandex_mapkit');
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
