document.addEventListener("turbo:load", function() {
    const navbar = document.querySelector('.navbar');
    window.addEventListener('scroll', () => {
        if (navbar) {
            if (window.scrollY >= window.innerHeight*.05) {
                navbar.classList.add('navbar-white');
            } else {
                navbar.classList.remove('navbar-white');
            }
        }
    });
});
