document.addEventListener("DOMContentLoaded", function () {
  const header = document.querySelector("header");

  if (!header) {
    console.error("Header element not found");
    return;
  }

  window.addEventListener("scroll", function () {
    const scrollTop = window.pageYOffset;

    if (scrollTop > 100) {
      header.classList.add("shrunk");
    } else {
      header.classList.remove("shrunk");
    }
  });
});
