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
        widget.mapObjectsWeb.removeAt(0);
        var address;
        var title;
        for (var element in widget.mapObjectsWeb) { 
          address = htmlEscape.convert(element['address']) ?? "";
          title = htmlEscape.convert(element['title']);
          arrayWeb = '$arrayWeb {"type": "Feature", "id": ${element['id']}, "geometry": {"type": "Point", "coordinates": [${element['latitude']}, ${element['longitude']}]}, "properties": {"balloonContentHeader": "", "balloonContentBody": "", "balloonContentFooter": "<strong>${title}</strong>", "clusterCaption": "${address}",	"hintContent": "<strong>Текст  <s>подсказки</s></strong>"}, "options":{"iconLayout": "default#image", "iconImageHref": "icons/location_mark.svg", "iconImageSize": [32, 32], "iconImageOffset": [-5, -38]}},'; 
        }
      } else {
        centerPoint = [55.76, 37.64];
      }

      Random random = new Random();
      int randomNumber = random.nextInt(100);
      String idMapRand = "map-$randomNumber";

      DivElement frame = DivElement();
      DivElement divElement = DivElement()
          ..id = idMapRand
          ..style.width = '100%'
          ..style.height = '100%';
      frame.append(divElement);

      var dataJson = """ { 
          "type": "FeatureCollection",
          "features": [   $arrayWeb   ] 
      } """;
      
      StyleElement styleElement = new StyleElement();
      
      var styleYaMaps = """
        ymaps .ymaps-2-1-79-zoom__plus,
        ymaps .ymaps-2-1-79-zoom__minus {
          border-radius: 50%;
          border: 1px solid #025232;
          width: 46px;
          height: 46px;
          box-shadow: none;
          background: rgba(255, 255, 255, 0.8)
        }
        ymaps .ymaps-2-1-79-zoom__plus .ymaps-2-1-79-zoom__icon {
          background: url(icons/maps_plus.svg) no-repeat center
        }
        ymaps .ymaps-2-1-79-zoom__minus .ymaps-2-1-79-zoom__icon {
          background: url(icons/maps_minus.svg) no-repeat center
        }
        ymaps .ymaps-2-1-79-zoom__plus .ymaps-2-1-79-zoom__icon,
        ymaps .ymaps-2-1-79-zoom__minus .ymaps-2-1-79-zoom__icon {
          width: 44px;
          height: 44px;
          border-radius: 50%;
          margin: 0;
          border: 0;
        }
        ymaps .ymaps-2-1-79-zoom {
          padding: 51px 0;
          width: 46px;
        }
        ymaps .ymaps-2-1-79-controls__control .ymaps-2-1-79-float-button {
          border-radius: 50%;
            border: 1px solid #025232;
            width: 46px;
            height: 46px;
            box-shadow: none;
            background: rgba(255, 255, 255, 0.8);
        }
        ymaps .ymaps8-1-79-float-button-icon_icon_geolocation {
          background: url(icons/maps_geolocation.svg) no-repeat center
          width: 44px;
            height: 44px;
            border-radius: 50%;
            margin: 0;
            border: 0;
        }
      """;
      
      ScriptElement scriptElement = new ScriptElement();
      var script = """
        setTimeout(function(){ ymaps.ready(init);
        var myMap;
        function init () {
            myMap = new ymaps.Map('$idMapRand', {
                    center: $centerPoint,
                    zoom: 10,
                    controls: []
                },
                {suppressMapOpenBlock: true}
                ),
                objectManager = new ymaps.ObjectManager({
                    clusterize: true,
                    gridSize: 32,
                    clusterDisableClickZoom: true
                });
            
            myMap.controls.add('zoomControl', {
                size: 'small',
                float: 'none',
                position: {
                    top: '24px',
                    right: '24px'
                }
            });
            //myMap.controls.add('rulerControl', { scaleLine: false });
            myMap.controls.add('geolocationControl', {
                position: {
                    bottom: '24px',
                    right: '24px'
                }
            });
        
            objectManager.objects.options.set('preset', 'islands#greenDotIcon');
            objectManager.clusters.options.set('preset', 'islands#greenClusterIcons');
            objectManager.add($dataJson);
            myMap.geoObjects.add(objectManager);
            
            myMap.setBounds(myMap.geoObjects.getBounds(),{checkZoomRange:true, zoomMargin:9});
        }},1000);
        """;
      scriptElement.innerHtml = script;
      styleElement.innerHtml = styleYaMaps;
      frame.append(scriptElement);
      frame.append(styleElement);
      
      String registerYandexMapId = "${YandexMap.viewType}_$randomNumber";

      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(
          registerYandexMapId,
              (int viewId) => frame);
      return HtmlElementView(viewType: registerYandexMapId);
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
