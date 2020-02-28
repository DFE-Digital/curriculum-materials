function initAutoPrint() {
  let autoPrint = window.location.href.search('[?&]auto_print') != -1
  if (autoPrint) {
    window.print();
  }
}

window.addEventListener('load', () => {
  initAutoPrint()
})
