document.addEventListener("DOMContentLoaded", () => {
    const toggle = document.getElementById("darkToggle");

    // Setzen des Darkmode-Status bei Start
    if (localStorage.getItem("darkmode") === "true") {
        document.body.classList.add("darkmode");
    }

    toggle.addEventListener("click", () => {
        document.body.classList.toggle("darkmode");
        localStorage.setItem("darkmode", document.body.classList.contains("darkmode"));
    });
});
