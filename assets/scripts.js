window.addEventListener("DOMContentLoaded", () => {
  const mainNav = document.getElementById("mainNav");
  if (mainNav) {
    let scrollPos = 0;
    const headerHeight = mainNav.clientHeight;

    window.addEventListener("scroll", () => {
      const currentTop = document.body.getBoundingClientRect().top * -1;

      if (currentTop < scrollPos) {
        if (currentTop > 0 && mainNav.classList.contains("is-fixed")) {
          mainNav.classList.add("is-visible");
        } else {
          mainNav.classList.remove("is-visible", "is-fixed");
        }
      } else {
        mainNav.classList.remove("is-visible");
        if (currentTop > headerHeight && !mainNav.classList.contains("is-fixed")) {
          mainNav.classList.add("is-fixed");
        }
      }

      scrollPos = currentTop;
    });
  }

  const essay = document.querySelector(".essay-sdtwin");
  if (!essay) return;

  essay.querySelectorAll("table").forEach((table) => {
    let wrapper = table.parentElement;
    if (!wrapper || !wrapper.classList.contains("table-shell")) {
      wrapper = document.createElement("div");
      wrapper.className = "table-shell";
      table.parentNode.insertBefore(wrapper, table);
      wrapper.appendChild(table);
    }

    const firstRow = table.querySelector("tr");
    const cols = firstRow ? firstRow.children.length : 0;

    wrapper.dataset.cols = String(cols);
    table.dataset.cols = String(cols);

    if (cols >= 7) {
      wrapper.classList.add("table-ultra-wide");
    } else if (cols >= 5) {
      wrapper.classList.add("table-wide");
    } else {
      wrapper.classList.add("table-regular");
    }
  });

  essay.querySelectorAll(".highlighter-rouge").forEach((block) => {
    const code = block.querySelector("code");
    if (!code) return;

    const trimmed = code.textContent.replace(/\n$/, "");
    const lines = trimmed ? trimmed.split("\n").length : 0;
    block.dataset.lines = String(lines);

    if (lines >= 18) {
      block.classList.add("code-extended");
    }
    if (lines >= 28) {
      block.classList.add("code-dense");
    }
  });
});
