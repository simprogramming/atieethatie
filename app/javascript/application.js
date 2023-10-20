// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import './components/sidebar';

// bootstrap
import * as bootstrap from "bootstrap"
window.Bootstrap = bootstrap; // Necessary for popper.js
