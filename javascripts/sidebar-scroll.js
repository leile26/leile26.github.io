(function () {
  const sidebar = document.querySelector('header');
  if (!sidebar) return;

  const desktopLike = window.matchMedia('(min-width: 961px) and (hover: hover) and (pointer: fine)');

  function onWheel(event) {
    if (!desktopLike.matches) return;

    const canScroll = sidebar.scrollHeight > sidebar.clientHeight;
    if (!canScroll) return;

    const atTop = sidebar.scrollTop <= 0;
    const atBottom = Math.ceil(sidebar.scrollTop + sidebar.clientHeight) >= sidebar.scrollHeight;
    const scrollingUp = event.deltaY < 0;
    const scrollingDown = event.deltaY > 0;

    if ((scrollingUp && !atTop) || (scrollingDown && !atBottom)) {
      event.preventDefault();
      sidebar.scrollTop += event.deltaY;
    }
  }

  sidebar.addEventListener('wheel', onWheel, { passive: false });
})();
