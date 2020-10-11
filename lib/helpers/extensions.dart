import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

extension StringExtensions on String {
  bool get isInt => int.tryParse(this) != null;
  String stripLeading(String pattern) {
    var that = this;
    if ((that ?? '').isEmpty ||
        (pattern ?? '').isEmpty ||
        pattern.length > that.length) return that;

    while (this.startsWith(pattern)) {
      that = that.substring(pattern.length);
    }
    return that;
  }

  String stripTrailing(String pattern) {
    var that = this;
    if ((that ?? '').isEmpty ||
        (pattern ?? '').isEmpty ||
        pattern.length > that.length) return that;

    while (that.endsWith(pattern)) {
      that = that.substring(0, that.length - pattern.length);
    }
    return that;
  }

  String trim(String pattern) {
    return this.stripLeading(pattern).stripTrailing(pattern);
  }

  DateTime toDateTime() => DateTime.tryParse(this);
}

extension NumExtensions on num {
  double toCountFontSize() {
    if (this >= 0 && this < 100) {
      return 112;
    } else if (this >= 100 && this < 1000) {
      return 90;
    } else if (this >= 1000 && this < 10000) {
      return 70;
    } else if (this >= 10000 && this < 100000) {
      return 50;
    }
    return 20;
  }
}

extension IntExtensions on int {
  double toTranscriptFontSize() {
    return this > Get.context.mediaQuerySize.width
        ? 6.6 * (this / Get.context.mediaQuerySize.width)
        : 18;
  }
}

extension WidgetExtensions on Widget {
  String get text {
    if (this is Text) {
      return (this as Text).data;
    } else if (this is Obx) {
      final w = (this as Obx).builder();
      return w.text;
    } else {
      throw UnimplementedError();
    }
  }
}

extension GenericListExtensions<T> on Iterable<T> {
  TResult whereElse<TResult>(
    bool Function(T) predicate, {
    TResult Function(Iterable list) exists,
    TResult noElement,
  }) {
    if (this != null) {
      final list = this.where(predicate);
      return list.length > 0 ? exists(list) : noElement;
    } else {
      return noElement;
    }
  }
}

extension ObjectExtensions<T> on T {
  T ifNull({@required T elseThen}) {
    return this == null ? elseThen : this;
  }
}

extension IAPErrorExtensions on IAPError {
  bool get itemAlreadyOwned =>
      this.message == "BillingResponse.itemAlreadyOwned";
}

extension DateTimeExtensions on DateTime {
  bool get isToday {
    final today = DateTime.now();
    return today.isSameDate(this);
  }

  bool isSameDate(DateTime date) {
    return date.day.isEqual(this.day) &&
        date.month.isEqual(this.month) &&
        date.year.isEqual(this.year);
  }
}
