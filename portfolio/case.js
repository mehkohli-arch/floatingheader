// Shared behavior for case study pages
(function () {
  var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  // Reading progress bar
  var bar = document.querySelector('.progress');
  if (bar) {
    var onScroll = function () {
      var h = document.documentElement.scrollHeight - innerHeight;
      bar.style.transform = 'scaleX(' + (h > 0 ? Math.min(scrollY / h, 1) : 0) + ')';
    };
    addEventListener('scroll', onScroll, { passive: true }); onScroll();
  }

  // Fade sections in as they scroll into view
  var els = document.querySelectorAll('.rv');
  if (reduce || !('IntersectionObserver' in window)) { els.forEach(function (e) { e.classList.add('in'); }); return; }
  var io = new IntersectionObserver(function (entries) {
    entries.forEach(function (en) { if (en.isIntersecting) { en.target.classList.add('in'); io.unobserve(en.target); } });
  }, { threshold: .12 });
  els.forEach(function (e) { io.observe(e); });
})();
