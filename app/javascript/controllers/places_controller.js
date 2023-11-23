import { Controller } from "@hotwired/stimulus";
import PlacesAutocomplete from "stimulus-places-autocomplete";

export default class extends PlacesAutocomplete {
    connect() {
        super.connect();
        this.countryValue = ["ca"];
        this.initShippingAutocomplete();
        this.initBillingAutocomplete();
    }

    initShippingAutocomplete() {
        this.shippingAutocomplete = new google.maps.places.Autocomplete(
            document.getElementById('shipping-address-line'),
            {
                types: ['geocode'],
                componentRestrictions: { country: 'ca' }
            }
        );
        this.shippingAutocomplete.setFields(['address_component']);
        this.shippingAutocomplete.addListener('place_changed', () => {
            let place = this.shippingAutocomplete.getPlace();
            this.fillInAddress(place, "shipping");
        });
    }

    initBillingAutocomplete() {
        this.billingAutocomplete = new google.maps.places.Autocomplete(
            document.getElementById('billing-address-line'),
            {
                types: ['geocode'],
                componentRestrictions: { country: 'ca' }
            }
        );
        this.billingAutocomplete.setFields(['address_component']);
        this.billingAutocomplete.addListener('place_changed', () => {
            let place = this.billingAutocomplete.getPlace();
            this.fillInAddress(place, "billing");
        });
    }

    disconnect() {
        // Détacher les écouteurs d'événements de l'autocomplétion pour les adresses de livraison et de facturation
        if (this.shippingAutocomplete) {
            google.maps.event.clearInstanceListeners(this.shippingAutocomplete);
        }
        if (this.billingAutocomplete) {
            google.maps.event.clearInstanceListeners(this.billingAutocomplete);
        }
    }


    fillInAddress(place, type) {
        // Réinitialiser tous les champs concernés avant de les remplir
        if (type === "shipping") {
            document.getElementById("shipping-address-line").value = "";
            document.getElementById("shipping-city").value = "";
            document.getElementById("shipping-province").value = "";
            document.getElementById("shipping-postal-code").value = "";
            document.getElementById("shipping-country").value = "";
        } else if (type === "billing") {
            document.getElementById("billing-address-line").value = "";
            document.getElementById("billing-city").value = "";
            document.getElementById("billing-province").value = "";
            document.getElementById("billing-postal-code").value = "";
            document.getElementById("billing-country").value = "";
        }

        // Parcourir tous les composants de l'adresse et les affecter aux champs appropriés
        for (const component of place.address_components) {
            const componentType = component.types[0];

            switch(componentType) {
                case "street_number": {
                    const streetNumber = component.long_name;
                    document.getElementById(`${type}-address-line`).value += streetNumber + " ";
                    break;
                }
                case "route": {
                    const route = component.long_name;
                    document.getElementById(`${type}-address-line`).value += route;
                    break;
                }
                case "locality": {
                    const city = component.long_name;
                    document.getElementById(`${type}-city`).value = city;
                    break;
                }
                case "administrative_area_level_1": {
                    const province = component.short_name;
                    document.getElementById(`${type}-province`).value = province;
                    break;
                }
                case "postal_code": {
                    const postalCode = component.long_name;
                    document.getElementById(`${type}-postal-code`).value = postalCode;
                    break;
                }
                case "country": {
                    const country = component.long_name;
                    document.getElementById(`${type}-country`).value = country;
                    break;
                }
            }
        }
    }
}
