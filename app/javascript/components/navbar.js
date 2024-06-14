document.addEventListener("turbo:load", function() {
    const navbar = document.querySelector('.navbar');
    const navbarToggler = document.querySelector('.navbar-toggler');
    const navbarCollapse = document.getElementById('navbarNav');

    const handleNavbarColor = () => {
        if (navbar) {
            if (window.scrollY >= window.innerHeight * 0.05 || navbarCollapse.classList.contains('show')) {
                navbar.classList.add('navbar-white');
                navbar.classList.remove("py-5");
            } else {
                navbar.classList.remove('navbar-white');
                navbar.classList.add('py-5');
            }
        }
    };

    window.addEventListener('scroll', handleNavbarColor);

    navbarToggler.addEventListener('click', () => {
        // Toggle class based on collapse state
        navbarCollapse.addEventListener('shown.bs.collapse', handleNavbarColor);
        navbarCollapse.addEventListener('hidden.bs.collapse', handleNavbarColor);
    });

    // Handle the initial state when the page loads
    handleNavbarColor();
});
