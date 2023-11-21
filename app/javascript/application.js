// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import './components/sidebar';
import './components/navbar';
import './components/credit_card_payment_square';
import "trix"
import "@rails/actiontext"

// bootstrap
import * as bootstrap from "bootstrap"
window.Bootstrap = bootstrap; // Necessary for popper.js
