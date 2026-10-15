/* 交互示意图 stepper —— 把课件的分步揭示动画搬进笔记。
   不依赖 fetch：SVG 与步骤清单都由 Python 预生成时内联进 HTML，
   因此 file:// 双击打开与 GitHub Pages 下都能用。
   分步构建型图用「下一步」；并列对比型图（multihead-intuition）
   改为默认全显 + 鼠标悬停高亮某一行。 */
(function () {
  var HEADS = [
    "Head 1 · Referent?（指代）→ 权重 0.60 落在 Noa（位置 0），回答「she 指谁」",
    "Head 2 · Description?（描述）→ 权重 0.58 落在 annoying（位置 3），回答「她什么样」",
    "Head 3 · Contrast?（转折）→ 权重 0.60 落在 but（位置 4），回答「语义在哪转弯」"
  ];
  var DEFAULT_NOTE = "同一个 she 查询、同一组可用位置，三个 head 各自给出一套权重。"
    + "把鼠标移到某一行，看它把权重集中在哪个 token 上。";

  function show(box, rows) {
    var note = document.createElement("p");
    note.className = "ihover-note";
    note.textContent = DEFAULT_NOTE;
    box.appendChild(note);
    rows.forEach(function (row, k) {
      row.style.cursor = "pointer";
      row.addEventListener("mouseenter", function () {
        rows.forEach(function (r) { r.classList.add("mh-dim"); });
        row.classList.remove("mh-dim");
        note.textContent = HEADS[k] || DEFAULT_NOTE;
      });
      row.addEventListener("mouseleave", function () {
        rows.forEach(function (r) { r.classList.remove("mh-dim"); });
        note.textContent = DEFAULT_NOTE;
      });
    });
  }

  function boot() {
    var STEPS = window.IDIAGRAM_STEPS || {};
    var FIGURES = window.IPLOT_FIGURES || {};

    document.querySelectorAll(".idiagram").forEach(function (box) {
      var svg = box.querySelector("svg");
      if (!svg) return;
      svg.removeAttribute("width");
      svg.removeAttribute("height");
      svg.setAttribute("width", "100%");

      var frags = Array.prototype.slice.call(box.querySelectorAll(".fragment"));
      var list = (STEPS[box.dataset.diagram] || {}).steps || [];
      var cur = 0;

      function revealAll() {
        frags.forEach(function (f) {
          var g = f.querySelector("[data-appear]");
          if (g) g.setAttribute("visibility", "visible");
        });
      }

      /* 并列对比型：不掩、不分步，默认全显 + 行 hover */
      if (box.dataset.diagram === "multihead-intuition") {
        revealAll();
        show(box, Array.prototype.slice.call(box.querySelectorAll("g[data-illustrative-head]")));
        return;
      }

      frags.forEach(function (f) {
        var g = f.querySelector("[data-appear]");
        if (g) g.setAttribute("visibility", "hidden");
      });

      if (!list.length) {
        revealAll();
        var note = document.createElement("p");
        note.className = "istatic";
        note.textContent = "课件原图（无分步动画）";
        box.appendChild(note);
        return;
      }

      var bar = document.createElement("div");
      bar.className = "ibar";
      bar.innerHTML =
        '<div class="ibar-row">' +
        '<button type="button" class="ibtn" data-act="prev">上一步</button>' +
        '<button type="button" class="ibtn ibtn-main" data-act="next">下一步</button>' +
        '<button type="button" class="ibtn" data-act="reset">重置</button>' +
        '<span class="istatus"></span>' +
        "</div>" +
        '<p class="ilabel"></p>';
      box.appendChild(bar);

      var prev = bar.querySelector('[data-act="prev"]');
      var next = bar.querySelector('[data-act="next"]');
      var reset = bar.querySelector('[data-act="reset"]');
      var status = bar.querySelector(".istatus");
      var label = bar.querySelector(".ilabel");

      function render() {
        frags.forEach(function (f) {
          var idx = Number(f.getAttribute("data-fragment-index"));
          var g = f.querySelector("[data-appear]");
          if (g) g.setAttribute("visibility", idx < cur ? "visible" : "hidden");
        });
        status.textContent = list.length ? ("第 " + cur + " / " + list.length + " 步") : "";
        label.textContent = cur > 0 && list[cur - 1] && list[cur - 1].label
          ? list[cur - 1].label
          : "点「下一步」开始，或点「重置」看完整图。";
        prev.disabled = cur === 0;
        next.disabled = cur === list.length;
        box.dataset.step = String(cur);
      }

      prev.addEventListener("click", function () { if (cur > 0) { cur -= 1; render(); } });
      next.addEventListener("click", function () { if (cur < list.length) { cur += 1; render(); } });
      reset.addEventListener("click", function () { cur = 0; render(); });
      render();
    });

    document.querySelectorAll(".iplot").forEach(function (box) {
      var fig = FIGURES[box.dataset.figure];
      if (!fig || typeof Plotly === "undefined") return;
      var layout = Object.assign({
        paper_bgcolor: "#fbfbf9",
        plot_bgcolor: "#fbfbf9",
        font: { family: "Arial, sans-serif", size: 14, color: "#202b38" },
        margin: { l: 70, r: 30, t: 25, b: 60 },
        colorway: ["#20578c", "#28673f", "#a85a29"]
      }, fig.layout || {}, { width: 900, height: 340 });
      Plotly.newPlot(box, fig.data || [], layout, Object.assign(
        { displaylogo: false, responsive: true, scrollZoom: false },
        fig.config || {}
      ));
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", boot);
  } else {
    boot();
  }
})();
