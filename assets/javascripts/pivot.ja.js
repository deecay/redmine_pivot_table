(function() {
  var callWithJQuery;

  callWithJQuery = function(pivotModule) {
    if (typeof exports === "object" && typeof module === "object") {
      return pivotModule(require("jquery"));
    } else if (typeof define === "function" && define.amd) {
      return define(["jquery"], pivotModule);
    } else {
      return pivotModule(jQuery);
    }
  };

  callWithJQuery(function($) {
    var jaFmt, jaFmtInt, jaFmtPct, nf, tpl, c3r;
    nf = $.pivotUtilities.numberFormat;
    tpl = $.pivotUtilities.aggregatorTemplates;
    c3r = $.pivotUtilities.c3_renderers;
    jaFmt = nf({
      thousandsSep: ",",
      decimalSep: ".",
      showZero: true
    });
    jaFmtInt = nf({
      digitsAfterDecimal: 0,
      thousandsSep: ",",
      decimalSep: ".",
      showZero: true
    });
    jaFmtPct = nf({
      digitsAfterDecimal: 1,
      scaler: 100,
      suffix: "%",
      thousandsSep: ",",
      decimalSep: ".",
      showZero: true
    });
    $.pivotUtilities.locales.ja = {
      localeStrings: {
        renderError: "表示エラーが発生しました。",
        computeError: "集計エラーが発生しました。",
        uiRenderError: "UI表示エラーが発生しました。",
        selectAll: "全て選択",
        selectNone: "全て選択解除",
        tooMany: "(値が多すぎます)",
        filterResults: "フィルタ",
        totals: "合計",
        vs: "対",
        by: "by",
        apply: "適用",
        cancel: "キャンセル"
      },
      aggregators: {
        "カウント": tpl.count(jaFmtInt),
        "カウント（ユニーク）": tpl.countUnique(jaFmtInt),
        "リスト（ユニーク）": tpl.listUnique(", "),
        "合計": tpl.sum(jaFmt),
        "合計（整数）": tpl.sum(jaFmtInt),
        "平均": tpl.average(jaFmt),
        "最小": tpl.min(jaFmt),
        "最大": tpl.max(jaFmt),
        "合計/合計": tpl.sumOverSum(jaFmt),
        "80%　上限": tpl.sumOverSumBound80(true, jaFmt),
        "80%　下限": tpl.sumOverSumBound80(false, jaFmt),
        "総計に対する数量比率": tpl.fractionOf(tpl.sum(), "total", jaFmtPct),
        "行合計に対する数量比率": tpl.fractionOf(tpl.sum(), "row", jaFmtPct),
        "列合計に対する数量比率": tpl.fractionOf(tpl.sum(), "col", jaFmtPct),
        "総計に対するカウント比率": tpl.fractionOf(tpl.count(), "total", jaFmtPct),
        "行合計に対するカウント比率": tpl.fractionOf(tpl.count(), "row", jaFmtPct),
        "列合計に対するカウント比率": tpl.fractionOf(tpl.count(), "col", jaFmtPct)
      },
      renderers: {
        "表形式": $.pivotUtilities.renderers["Table"],
        "表＋棒グラフ": $.pivotUtilities.renderers["Table Barchart"],
        "ヒートマップ": $.pivotUtilities.renderers["Heatmap"],
        "行ヒートマップ": $.pivotUtilities.renderers["Row Heatmap"],
        "列ヒートマップ": $.pivotUtilities.renderers["Col Heatmap"]
      }
    };
    if (c3r) {
      $.pivotUtilities.locales.ja.c3_renderers = {
        "折れ線グラフ": c3r["Line Chart"],
        "棒グラフ": c3r["Bar Chart"],
        "積み上げ棒グラフ": c3r["Stacked Bar Chart"],
        "面グラフ": c3r["Area Chart"],
        "散布図": c3r["Scatter Chart"]
      };
    }
    return $.pivotUtilities.locales.ja;
  });

}).call(this);

//# sourceMappingURL=pivot.fr.js.map
