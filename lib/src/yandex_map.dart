part of yandex_mapkit;

class YandexMap extends StatefulWidget {
  /// A `Widget` for displaying Yandex Map
  const YandexMap({
    Key key,
    this.mapObjects = const [],
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
  
  /// Map objects to show on map
  final List<MapObject> mapObjects

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
              {"type": "Feature", "id": 0, "geometry": {"type": "Point", "coordinates": $centerPoint}, "properties": {"balloonContentHeader": "<font size=3><b><a target='_blank' href='https://yandex.ru'>Здесь может быть ваша ссылка</a></b></font>", "balloonContentBody": "<p>Ваше имя: <input name='login'></p><p><em>Телефон в формате 2xxx-xxx:</em>  <input></p><p><input type='submit' value='Отправить'></p>", "balloonContentFooter": "<font size=1>Информация предоставлена: </font> <strong>этим балуном</strong>", "clusterCaption": "<strong><s>Еще</s> одна</strong> метка", "hintContent": "<strong>Текст  <s>подсказки</s></strong>"}}
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
