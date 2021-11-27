import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Author: Karl
/// Date: 2021/11/23 上午9:53
/// Description:
final double grid = 30.0;



class KarlPainter extends CustomPainter {
  final Paint mPaint = Paint()
    ..color = Colors.orange//设置画笔颜色
    ..style = PaintingStyle.stroke//设置画笔类型
    ..isAntiAlias = true//开启抗锯齿
    ..strokeWidth = 6;//设置画笔线宽
  final double value;

  KarlPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    ///这里就是绘制的地方
    ///可以直接在canvas上绘制
    checkerboard(canvas, size);
    ///point(canvas);
    ///line(canvas);
    ///pathLine(canvas);
    ///pathArc(canvas);
    ///shapeCircle(canvas);
    ///shapeRect(canvas);
    ///shadow(canvas);
    ///canvasRotateTranslate(canvas);
    ///bezierQuadratic(canvas, size);
    ///bezierCubic(canvas, size);
    wave(canvas, size);
  }

  ///绘制点
  void point(Canvas canvas){
    List<Offset> offsets = [Offset(-60,120),Offset(0,0),Offset(60,120),Offset(120, 0)];
    canvas.drawPoints(PointMode.polygon,offsets,mPaint..strokeCap = StrokeCap.round);
    canvas.drawRawPoints(PointMode.points,Float32List.fromList([-120,0,60,0,30,100]),mPaint..strokeCap = StrokeCap.round);
  }
  ///划线
  void line(Canvas canvas) {
    canvas.drawLine(
        Offset(-60, -12), Offset(60, -12), mPaint..strokeCap = StrokeCap.round);
    canvas.drawLine(
        Offset(-60, 0), Offset(60, 0), mPaint..strokeCap = StrokeCap.square);
    canvas.drawLine(
        Offset(-60, 12), Offset(60, 12), mPaint..strokeCap = StrokeCap.butt);
  }

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

  ///画圆弧
  void pathArc(Canvas canvas) {
    var rect = Rect.fromPoints(Offset(-120, -120), Offset(120, 120));
    canvas.drawArc(rect, 0, pi, false, mPaint);

    canvas.drawArc(
        rect, pi / -3, pi / -2, true, mPaint..color = Colors.deepPurple);
  }

  ///画圆形
  void shapeCircle(Canvas canvas) {
    canvas.drawCircle(Offset(-60, 0), 60, mPaint);
    canvas.drawCircle(Offset(60, 0), 60, mPaint..style = PaintingStyle.fill);
  }

  ///画矩形
  void shapeRect(Canvas canvas) {
    var rrect = RRect.fromLTRBR(-60, -60, 60, 60, Radius.circular(5));
    canvas.drawRRect(rrect, mPaint);
  }

  ///绘制阴影
  void shadow(Canvas canvas) {
    var pathRelative = Path()
      ..moveTo(-100.0, 100)
      ..relativeLineTo(100.0, -100.0)
      ..relativeLineTo(100.0, 100.0);
    canvas.drawShadow(pathRelative, Colors.orange, 3, false);
  }

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

  final double waveHeight = 20;

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

  ///绘制底部网格
  void checkerboard(Canvas canvas, Size size) {
    var width = size.width;
    var height = size.height;

    ///为了绘制效果，将画布起点移到屏幕中心
    canvas.translate(size.width / 2, size.height / 2);
    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;

    ///绘制竖线
    var w = width ~/ grid;
    for (var i = 0; i <= w; i++) {
      canvas.drawLine(
          Offset(-i * grid, height / -2), Offset(-i * grid, height), paint);
      canvas.drawLine(
          Offset(i * grid, height / -2), Offset(i * grid, height), paint);
    }
    canvas.drawLine(Offset(0, height / -2), Offset(0, height / 2),
        paint..color = Colors.cyan);

    ///绘制横线
    var h = height ~/ grid;
    paint.color = Colors.grey;
    for (var i = 0; i <= h; i++) {
      canvas.drawLine(
          Offset(height / -2, -i * grid), Offset(height / 2, -i * grid), paint);
      canvas.drawLine(
          Offset(height / -2, i * grid), Offset(height / 2, i * grid), paint);
    }
    canvas.drawLine(Offset(width / -2, 0), Offset(width / 2, 0),
        paint..color = Colors.cyan);
    canvas.drawCircle(Offset.zero, 3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
