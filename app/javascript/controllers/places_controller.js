import { Controller } from "@hotwired/stimulus";
import PlacesAutocomplete from "stimulus-places-autocomplete";

export default class extends PlacesAutocomplete {
    connect() {
        this.countryValue = ["ca"];
        document.addEventListener("google-maps-callback", this.initAutocomplete.bind(this));
        super.connect();
    }

    disconnect() {
        document.removeEventListener("google-maps-callback", this.initAutocomplete.bind(this));
        super.disconnect();
    }

    initAutocomplete() {
        super.initAutocomplete();
        this.autocomplete.addListener('place_changed', () => {
            let place = this.autocomplete.getPlace();
            this.fillInAddress(place);
        });
    }

    fillInAddress(place) {
        // Réinitialiser tous les champs
        this.targets.find("address").value = "";
        this.targets.find("city").value = "";
        this.targets.find("province").value = "";
        this.targets.find("postalCode").value = "";
        this.targets.find("country").value = "";
        this.targets.find("apartment").value = "";

        // Parcourir tous les composants de l'adresse et les affecter aux champs
        for (const component of place.address_components) {
            const componentType = component.types[0];

            switch(componentType) {
                case "street_number": {
                    this.targets.find("address").value += component.long_name + " ";
                    break;
                }
                case "route": {
                    this.targets.find("address").value += component.long_name;
                    break;
                }
                case "locality": {
                    this.targets.find("city").value = component.long_name;
                    break;
                }
                case "administrative_area_level_1": {
                    this.targets.find("province").value = component.short_name;
                    break;
                }
                case "postal_code": {
                    this.targets.find("postalCode").value = component.long_name;
                    break;
                }
                case "country": {
                    this.targets.find("country").value = component.long_name;
                    break;
                }
                // Vous pouvez ajouter d'autres cas si nécessaire
            }
        }
    }
}
