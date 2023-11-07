import Toybox.Lang;

using Shared.Log;
using Shared.Util;
using Toybox.Application.Properties;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Time;
using Toybox.WatchUi as Ui;

(:graph)
module Shared {
class Graph extends Ui.Drawable {
  private const TAG = "Graph";
  private const TIME_RANGE_SEC = 120 * 60;
  private const HR_SAMPLING_PERIOD_SEC = 5 * 60;
  private const MIN_HEART_RATE = 30;
  private const MAX_HEART_RATE = 160;
  private const MINOR_X_AXIS_SEC = 30 * 60;

  private var glucoseBarWidthSec = 5 * 60;
  private var glucoseBarPadding = 2;
  private var initialXOffset as Number;
  private var initialWidth as Number;
  private var glucoseBarWidth as Number?;
  private var firstValueIdx = 0;
  private var xOffset = 3;
  private var yOffset = 120;
  var width;
  var height = 86;
  private var glucoseBuffer as Shared.DateValues = new Shared.DateValues(null, 2);
  private var maxGlucose;
  private var circular;
  var isMmolL as Boolean?;
  private var bgColor;
  private var hrColor;
  private var axisColor;

  function initialize(params) {
    Drawable.initialize(params);
    me.circular = Sys.getDeviceSettings().screenShape == Sys.SCREEN_SHAPE_ROUND;
    me.initialXOffset = params.get(:x).toNumber();
    me.yOffset = params.get(:y).toNumber();
    me.initialWidth = params.get(:width).toNumber();
    me.width = initialWidth;
    me.height = params.get(:height).toNumber();
    setAppearanceLight();
  }

  function valueCount() {
    return TIME_RANGE_SEC / glucoseBarWidthSec; 
  }

  function setAppearanceLight() {
    bgColor = Gfx.COLOR_WHITE;
    axisColor = Gfx.COLOR_LT_GRAY;
    hrColor = Gfx.COLOR_DK_GRAY;
  }

  function setAppearanceDark() {
    bgColor = Gfx.COLOR_BLACK;
    axisColor = Gfx.COLOR_DK_GRAY;
    hrColor = Gfx.COLOR_LT_GRAY;
  }

  function setReadings(glucoseBuffer as Shared.DateValues) as Void {
    // Log.i(TAG, "setReadings " + glucoseBuffer.size() + " values");
    glucoseBarWidthSec = Properties.getValue("GlucoseValueFrequencySec");
    glucoseBarPadding = glucoseBarWidthSec < 300 ? 0 : 2;
    me.glucoseBuffer = glucoseBuffer;
    var startSec = Util.nowSec() - TIME_RANGE_SEC;
    maxGlucose = 180;
    firstValueIdx = 0;
    for (var i = 0; i < glucoseBuffer.size(); i++) {
      if (glucoseBuffer.getDateSec(i) >= startSec) {
        maxGlucose = Util.max(maxGlucose, glucoseBuffer.getValue(i));
      } else {
        firstValueIdx++;
      }
    }
    var leftOffset = 0;
    var rightOffset = 0;
    if (firstValueIdx < glucoseBuffer.size()) {
      leftOffset = getBorderOffset(glucoseBuffer.getValue(firstValueIdx));
      rightOffset = getBorderOffset(glucoseBuffer.getLastValue());
    }
    xOffset = initialXOffset + leftOffset;
    width = initialWidth - leftOffset - rightOffset;
    var totalPadding = glucoseBarPadding * (valueCount() - 1);
    glucoseBarWidth = Math.ceil((width - totalPadding) / valueCount());
    var totalBarWidth = glucoseBarWidth * valueCount() + totalPadding;
    xOffset = xOffset - Util.max(0, totalBarWidth - width);
    Log.i(
        TAG, 
        "graph dimensions: " + { 
            "leftOffset"=>leftOffset,
            "rightOffset"=> rightOffset, 
            "xOffset" => xOffset,
            "width" => width, 
            "glucoseBarWidth" => glucoseBarWidth,
            "valueCount" => valueCount()});
  }

  private function getBorderOffset(value) {
    if (!circular) { return 0; }
    var y = Util.min(height, getYForGlucose(value));
    var r = initialWidth / 2;
    var o = r - Math.sqrt(r*r - y*y);  // Pythagoras' theorem
    return Math.ceil(o);
  }

  private function getX(startSec as Number, dateSec as Number) as Number {
    var rel = (dateSec - startSec) / glucoseBarWidthSec * (glucoseBarPadding + glucoseBarWidth);
    return rel;
  }

  private function getYForGlucose(glucose as Number) as Number {
    return height * (maxGlucose - glucose) / (maxGlucose - 40);
  }

  private function getYForHR(hr as Number) as Number {
    return height * (MAX_HEART_RATE - hr) / (MAX_HEART_RATE - MIN_HEART_RATE);
  }

  private function formatValue(value as Number) as String {
    if (isMmolL) {
      var valMmolL = value / 18.0;
      if (valMmolL < 10.0) {
        return valMmolL.format("%0.1f");
      } else {
        return valMmolL.format("%0.0f");
      }
    } else {
      return value.toLong().toString();
    }
  }

  private function drawValue(dc, startSec, i) {
    var x = getX(startSec, glucoseBuffer.getDateSec(i));
    var y = getYForGlucose(glucoseBuffer.getValue(i));
    var justification;

    if (i < firstValueIdx + 3) {
      justification = Gfx.TEXT_JUSTIFY_LEFT;
    } else if (i > glucoseBuffer.size() - 3) {
      justification = Gfx.TEXT_JUSTIFY_RIGHT;
      x += glucoseBarWidth - 5;
    } else {
      justification = Gfx.TEXT_JUSTIFY_CENTER;
      x += glucoseBarWidth / 2;
    }

    if (y > height / 2) {
      y -= 25;
    }

    dc.drawText(
        xOffset + x, yOffset + y,
        Gfx.FONT_TINY,
        formatValue(glucoseBuffer.getValue(i)),
        justification);
  }

  private function drawGlucose(dc, startSec) {
    if (glucoseBuffer == null || glucoseBuffer.size() <= firstValueIdx) {
      return;
    }
    for (var i = firstValueIdx; i < glucoseBuffer.size(); i++) {
      var x = getX(startSec, glucoseBuffer.getDateSec(i));
      var w = (x + glucoseBarWidth).toNumber() - x.toNumber();
      var y = getYForGlucose(glucoseBuffer.getValue(i));
      var h = height - y;
//      Log.i(TAG, "draw " + glucoseBuffer.getValue(i)
//          + " x=" + x + " y=" + y + " h=" + h);
      dc.setColor(Gfx.COLOR_DK_BLUE, bgColor);
      dc.fillRectangle(xOffset + x, yOffset + y, w, h);
      dc.setColor(Gfx.COLOR_BLUE, bgColor);
      dc.fillRectangle(xOffset + x, yOffset + y, w, 3);
    }
  }

  private function drawTimeAxis(dc, startSec) {
    dc.setColor(axisColor, Gfx.COLOR_TRANSPARENT);
    dc.setPenWidth(2);
    dc.drawLine(0, yOffset, initialWidth, yOffset);
    dc.drawLine(xOffset, yOffset + height, xOffset + width, yOffset + height);
    var lineWidth = Util.max(2, glucoseBarPadding);
    dc.setPenWidth(lineWidth);
    for (var dateSec = (startSec-1) / MINOR_X_AXIS_SEC * MINOR_X_AXIS_SEC;
         dateSec < startSec + TIME_RANGE_SEC;
         dateSec += MINOR_X_AXIS_SEC) {
      var x = getX(startSec, dateSec);
      dc.drawLine(
          x + xOffset - lineWidth, yOffset + height + 5,
          x + xOffset - lineWidth, yOffset + height);
      dc.drawLine(
          x + xOffset - lineWidth, yOffset + 15,
          x + xOffset - lineWidth, yOffset);
    }
  }

  private function drawHeartRate(dc, startSec, nowSec) {
    if (!(Toybox has :SensorHistory)) {
      return;
    }
    var it = SensorHistory.getHeartRateHistory({
        :period => new Time.Duration(TIME_RANGE_SEC),
        :order => SensorHistory.ORDER_OLDEST_FIRST });
    var val;
    do {
      val = it.next();
      if (val == null) {
        Log.i(TAG, "no heart rate values");
        return;
      }
    } while (val.data == null );
    var prevX = getX(startSec, val.when.value());
    var prevY = getYForHR(val.data);
    dc.setColor(hrColor, bgColor);
    dc.setPenWidth(2);
    var count = 0;
    var sum = 0;
    var minute = val.when.value() / 60;
    var minuteSum = val.data;
    var minuteCount = 1;
    for (val = it.next(); val != null; val = it.next()) {
      if (val.data == null) {
        continue;
      }
      minuteCount++;
      minuteSum += val.data;
      if (val.when.value() / 60 == minute) {
        continue;
      }
      if (val.when.value() + HR_SAMPLING_PERIOD_SEC > nowSec) {
        count += minuteCount;
        sum += minuteSum;
      }
      var x = getX(startSec, 60  * minute);
      var y = getYForHR(minuteSum / minuteCount);
//      Log.i(TAG, "draw HR " + val.data
//               + " prevX=" + prevX + " prevY=" + prevY
//               + " x=" + x + " y=" + y);
      dc.drawLine(xOffset + prevX, yOffset + prevY, xOffset + x, yOffset + y);
      prevX = x;
      prevY = y;
      minute = val.when.value() / 60;
      minuteCount = 0;
      minuteSum = 0;
    }
    if (count > 0) {
      Properties.setValue("HeartRateStartSec", nowSec - HR_SAMPLING_PERIOD_SEC);
      Properties.setValue("HeartRateLastSec", nowSec);
      Properties.setValue("HeartRateAvg", sum / count);
    }
  }

  function drawMinMax(dc, startSec) {
    if (glucoseBuffer == null || glucoseBuffer.size() <= firstValueIdx) {
      return;
    }
    var minIdx = 0;
    var maxIdx = 0;
    for (var i = firstValueIdx; i < glucoseBuffer.size(); i++) {
      if (glucoseBuffer.getValue(minIdx) > glucoseBuffer.getValue(i)) {
        minIdx = i;
      } else if (glucoseBuffer.getValue(maxIdx) < glucoseBuffer.getValue(i)) {
        maxIdx = i;
      }
    }
    dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
    drawValue(dc, startSec, minIdx);
    drawValue(dc, startSec, maxIdx);
  }

  function draw(dc) {
    glucoseBarWidthSec = Properties.getValue("GlucoseValueFrequencySec");
    glucoseBarPadding = glucoseBarWidthSec < 300 ? 0 : 2;
    if (glucoseBuffer.size() == 0) {
      return;
    }
    var nowSec = Util.nowSec();
    var startSec = nowSec - TIME_RANGE_SEC;
    if (firstValueIdx < glucoseBuffer.size()) {
      glucoseBuffer.getDateSec(firstValueIdx);
      if (nowSec - TIME_RANGE_SEC < startSec - 300) {
        startSec = nowSec - TIME_RANGE_SEC;
      }
    }

    drawTimeAxis(dc, startSec);
    drawGlucose(dc, startSec);
    drawHeartRate(dc, startSec, nowSec);
    drawMinMax(dc, startSec);
  }
}}
