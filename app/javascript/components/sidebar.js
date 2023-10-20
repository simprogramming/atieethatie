document.addEventListener("turbo:load", function() {
    const menuToggle = document.getElementById("menu-toggle");
    if (menuToggle) {
        menuToggle.onclick = function(e) {
            e.preventDefault();

            const wrapper = document.getElementById('wrapper');

            if (wrapper) {
                wrapper.classList.toggle('sidebar-toggled')
            }
        }
    }
});