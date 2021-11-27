### 简介
通过绘制基本的线、路径、图形、曲线等。同时结合画布的旋转实现一个模拟时钟的组件。学习Flutter的基本绘制。
![屏幕录制2021-11-26 18.gif](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/123c9244135f45c7955d14f20fcd8684~tplv-k3u1fbpfcp-watermark.image?)
### Paint和Canvas
在画布上绘制前，需要有一支画笔：

```
final Paint mPaint = Paint()
  ..color = Colors.orange//设置画笔颜色
  ..style = PaintingStyle.stroke//设置画笔类型
  ..isAntiAlias = true//开启抗锯齿
  ..strokeWidth = 6;//设置画笔线宽
```
通过继承`CustomPainter `，然后重写`paint `方法获得`canvas `画布对象。之后便可以在画布上进行绘制。

```dart
class Custom extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    ///这里就是绘制的地方
    ///可以直接在canvas上绘制
  }

@override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
```
Paint和Canvas都提供了很多属性和方法，Canvas的方法在稍后分章节展示、这里简要讲解Paint的几个关键属性：


| Paint属性 | 数据类型 |简介 |
| --- | --- | --- |
|  color | Color | 画笔的颜色 |
|  strokeWidth | double | 画笔的线宽|
|  style | PaintingStyle | 画笔的类型（fill填充和stroke线条）|
|  strokeCap | StrokeCap | 线头类型 (butt、round和square) |

这里展示一下不同strokeCap的效果：

![1637982383883.jpg](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2ee3eee7e23e4450b3c7317019e4aaf4~tplv-k3u1fbpfcp-watermark.image?)

上图中依次是：round、square和butt。可以看到他们在线头处的不同效果。

###基础图形绘制

#### 点、线和路径的绘制
可以通过`drawPoints(PointMode pointMode, List<Offset> points, Paint paint)`批量绘制点，该方法接受三个参数：点的模式，点位和画笔。点的模式分三种：
1. points：点；
2. lines：线；
3. polygon：多边形；
分别对应如下效果：


| points |lines  |polygon|
| --- | --- |  --- |
| ![1637988681849.jpg](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b1638618db924721bab5e1869faba538~tplv-k3u1fbpfcp-watermark.image?) |![1637988673707.jpg](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/9a8aabd4147d41f38f62829fe4a167f1~tplv-k3u1fbpfcp-watermark.image?) |![1637988687184.jpg](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d3759b0cc9aa4f63aed38b0e8b7ecd20~tplv-k3u1fbpfcp-watermark.image?) |
另外还有一种绘制点的方法：`drawRawPoints(PointMode pointMode, Float32List points, Paint paint)`，两者的不同之处在于传递坐标的方式不同
Canvas提供两个方法`drawLine(Offset p1, Offset p2, Paint paint)`、`drawPath(Path path, Paint paint)`分别用来绘制直线和路径。

其中drawLine接受三个参数：起始点位置、终点位置和画笔。
上文中strokeCap的效果展示就是通过基础的画线实现的，它的代码如下：

```dart
///划线
void line(Canvas canvas) {
  canvas.drawLine(
      Offset(-60, -12), Offset(60, -12), mPaint..strokeCap = StrokeCap.round);
  canvas.drawLine(
      Offset(-60, 0), Offset(60, 0), mPaint..strokeCap = StrokeCap.square);
  canvas.drawLine(
      Offset(-60, 12), Offset(60, 12), mPaint..strokeCap = StrokeCap.butt);
}
```
drawPath接受两个参数：路径path和画笔。这里先讲一下路径Path的三类移动策略：
1. moveTo和relativeMoveTo：移动到某个位置，相当于落笔的位置
2.lineTo和relativeLineTo：画到某一位置，相当于画笔移动到的位置

含有relative的移动，是相对移动。传入的x，y是相对当前坐标的偏移量。而不含relative则是画布的绝对坐标。

```Dart
///画路径
void pathLine(Canvas canvas) {
  var path = Path()
    ..moveTo(-100.0, -100)
    ..lineTo(0.0, 0.0)
    ..lineTo(100.0, -100);
  canvas.drawPath(path, mPaint);

  var pathRelative = Path()
    ..moveTo(-100.0, 100)
    ..relativeLineTo(100.0, -100.0)
    ..relativeLineTo(100.0, 100.0);

  canvas.drawPath(pathRelative, mPaint..color = Colors.deepPurple);
}
```
上面的代码执行后效果如下：
![1637995989641.jpg](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a0e01bffa9674e26b370cac4195ccfc5~tplv-k3u1fbpfcp-watermark.image?)
Path不仅可以画直线路径，还可以绘制二阶贝塞尔曲线：

```dart
///贝塞尔曲线
void bezierQuadratic(Canvas canvas, Size size) {
  var first = Offset(size.width / -4, 0);
  var second = Offset(0, -200);
  var third = Offset(size.width / 4, 0);
  Path path = Path()
    ..moveTo(first.dx, first.dy)
    ..quadraticBezierTo(second.dx, second.dy, third.dx, third.dy);
  canvas.drawPath(path, mPaint);
  canvas.drawPath(
      Path()
        ..moveTo(first.dx, first.dy)
        ..lineTo(second.dx, second.dy)
        ..lineTo(third.dx, third.dy),
      mPaint..strokeWidth = 1);
}
```
效果如图：

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/52fda692e17b4de59e74119ee26d9430~tplv-k3u1fbpfcp-watermark.image?)

三阶贝塞尔曲线：

```Dart
///贝塞尔曲线
void bezierCubic(Canvas canvas, Size size) {
  var first = Offset(size.width / -4, 0);
  var second = Offset(size.width / -4, -200);
  var third = Offset(size.width / 4, -200);
  var four = Offset(size.width / 4, 0);
  Path path = Path()
    ..moveTo(first.dx, first.dy)
    ..cubicTo(second.dx, second.dy, third.dx, third.dy, four.dx, four.dy);
  canvas.drawPath(path, mPaint);
  canvas.drawPath(
      Path()
        ..moveTo(first.dx, first.dy)
        ..lineTo(second.dx, second.dy)
        ..lineTo(third.dx, third.dy)
        ..lineTo(four.dx, four.dy),
      mPaint..strokeWidth = 1);
}
```
![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/851c1f8475164db2bbf758a7e801a6f7~tplv-k3u1fbpfcp-watermark.image?)

二阶和三阶贝塞尔曲线却别在于前置需要三个点确定位置，而后者需要四个点。但是两者接受的点位分别是2和3个，这是因为它们都以Path目前所处的点位为第一个点。

### 绘制图形
Canvas提供基本的集合图形绘制，包括圆矩形以及扇形等。
#### 绘制圆：
```dart
///画圆形
void shapeCircle(Canvas canvas) {
  canvas.drawCircle(Offset(-60, 0), 60, mPaint);
  canvas.drawCircle(Offset(60, 0), 60, mPaint..style = PaintingStyle.fill);
}
```
方法很简单，只需要传入远点坐标和半径即可。效果如图：
![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ce69faef6cd94c52a9805bb585c83c46~tplv-k3u1fbpfcp-watermark.image?)
#### 绘制矩形

```dart
///画矩形
void shapeRect(Canvas canvas) {
 ///四条边的位置，以及圆角弧度
  var rrect = RRect.fromLTRBR(-60, -60, 60, 60, Radius.circular(5));
  canvas.drawRRect(rrect, mPaint);
}
```
效果如图：

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/06a9d9225eed40db807648b65f3fa719~tplv-k3u1fbpfcp-watermark.image?)

矩形稍微负责一点，需要确定矩形方位。RRect提供了数种构造方法用来确定矩形方位，上图中通过矩形四条边的位置确定需要绘制的区域。
#### 绘制扇形
```dart

///画圆弧
void pathArc(Canvas canvas) {
  var rect = Rect.fromPoints(Offset(-120, -120), Offset(120, 120));
  canvas.drawArc(rect, 0, pi, false, mPaint);

  canvas.drawArc(
      rect, pi / -3, pi / -2, true, mPaint..color = Colors.deepPurple);
}
```
效果如图:

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a2a94ffd92044449874a1fa40a7b4e34~tplv-k3u1fbpfcp-watermark.image?)
扇形的绘制也需要先确定方位，然后需要确定起始角度和结束角度。

#### 绘制阴影

```dart
///绘制阴影
void shadow(Canvas canvas) {
  var pathRelative = Path()
    ..moveTo(-100.0, 100)
    ..relativeLineTo(100.0, -100.0)
    ..relativeLineTo(100.0, 100.0);
  canvas.drawShadow(pathRelative, Colors.orange, 3, false);
}
```

效果如图：


![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5fdcba2d8cb846a69072c535741efcd1~tplv-k3u1fbpfcp-watermark.image?)

### 画布的变换
画布的变换包含平移、旋转和缩放三种。这里主要讲一下常用的平移的旋转。
translate:将画布移动到指定位置
rotate:将画布旋转一定的角度
注意。在变换之后，画布的坐标和角度都会变化。如果想要回复，则需要在变换前调用save方法，之后使用restore复原。
我们直接使用时钟的绘制来展示旋转的效果：

```dart
///绘制时钟
void canvasRotateTranslate(Canvas canvas) {
  ///画表圈
  canvas.drawCircle(Offset(0, 0), 122, mPaint..style = PaintingStyle.stroke);
  ///绘制刻度
  ///将表盘六十等分
  for (var i = 1; i <= 60; i++) {
    ///旋转画布
    canvas.rotate(pi / 30);
    ///每五个小刻度绘制一个大刻度
    if (i % 5 == 0) {
      canvas.drawLine(Offset(0, -120), Offset(0, i % 3 == 0 ? -105 : -108),
          mPaint..strokeWidth = i % 3 == 0 ? 6 : 4);
    } else {
      canvas.drawLine(
          Offset(0, -120), Offset(0, -115), mPaint..strokeWidth = 3);
    }
  }
  ///绘制时刻
  TextPainter textPainter = new TextPainter(
      textAlign: TextAlign.left, textDirection: TextDirection.ltr);
  for (var i = 0; i < 12; i++) {
    canvas.save();
    ///移动画布，使得时刻刚好处在刻度旁边
    canvas.translate(0, -95);
    ///画布旋转一定角度，使得时刻数组竖直显示
    canvas.rotate(-pi / 6 * i);
    ///绘制文字
    textPainter.text = TextSpan(
        style: new TextStyle(color: Colors.deepOrange, fontSize: 22),
        text: "${i == 0 ? 12 : i}");
    textPainter.layout();
    textPainter.paint(
        canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
    canvas.restore();
    ///旋转角度，使时刻处在正确的位置
    canvas.rotate(pi / 6);
  }

  var hours = DateTime.now().hour % 12;
  var minutes = DateTime.now().minute;
  var seconds = DateTime.now().second;

  ///绘制时分秒针
  canvas.save();
  ///计算时针位置需要旋转的角度
  canvas.rotate(
      (hours * pi / 6) + (pi / 6) * minutes / 60 + (pi / 6) * seconds / 3600);
  canvas.drawLine(Offset.zero, Offset(0, -40), mPaint..strokeWidth = 3);
  canvas.restore();
  canvas.save();
  ///计算分针位置需要旋转的角度
  canvas.rotate(((minutes * pi / 30) + seconds / 60 * pi / 30));
  canvas.drawLine(Offset.zero, Offset(0, -60), mPaint..strokeWidth = 3);
  canvas.restore();
  canvas.save();
  ///计算秒针位置需要旋转的角度
  canvas.rotate((seconds * pi / 30));
  canvas.drawLine(
      Offset.zero,
      Offset(0, -80),
      mPaint
        ..strokeWidth = 2
        ..color = Colors.red);
  canvas.restore();
  canvas.drawCircle(Offset(0, 0), 5, mPaint..style = PaintingStyle.fill);
}
```
效果如图：

![屏幕录制2021-11-26 18.gif](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/123c9244135f45c7955d14f20fcd8684~tplv-k3u1fbpfcp-watermark.image?)

### 最后
贝塞尔曲线实现波浪线效果：

```dart
     
void wave(Canvas canvas, Size size) {
  canvas.save();
  var waveWidth = size.width / 8;
  canvas.translate(-size.width / 2 * 3, 0);
  Path path = Path()..moveTo(0, 0);
  ///确定曲线路径
  for (var i = 1, j = -1; i < 16; i += 2) {
    path.quadraticBezierTo(size.width * value + waveWidth * i, j * waveHeight,
        size.width * value + waveWidth * (i + 1), 0);
    j = -j;
  }
  path..lineTo(waveWidth * 16, 60)..lineTo(0, 60)..lineTo(0, 0);
  canvas.drawPath(
      path,
      mPaint
        ..style = PaintingStyle.fill
        ..color = Colors.orange);
  canvas.restore();
}
```
```

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Draw Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  Timer timer;
  int value = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
     timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
       setState(() {
         value++;
         if(value >=10){
           value = 0;
         }
       });
     });
   });

  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('$hours:$minutes:$seconds:${DateTime.now().millisecond}'),
      ),
      body: CustomPaint(
        painter: KarlPainter(value*0.1),
        size: MediaQuery.of(context).size,
      ),
    );
  }
}
```
效果如图：

![屏幕录制2021-11-27 15.gif](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/93ed870dc03d4f738d9d86d89c34ba90~tplv-k3u1fbpfcp-watermark.image?)










