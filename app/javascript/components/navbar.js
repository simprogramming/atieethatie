document.addEventListener("turbo:load", function() {
    const navbar = document.querySelector('.navbar');
    window.addEventListener('scroll', () => {
        if (navbar) {
            if (window.scrollY >= window.innerHeight*.05) {
                navbar.classList.add('navbar-white');
                navbar.classList.remove("py-5")
            } else {
                navbar.classList.remove('navbar-white');
                navbar.classList.add('py-5');

            }
        }
    });
});
