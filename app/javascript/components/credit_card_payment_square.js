const appId = 'sandbox-sq0idb-c82Rx8uA5RNvDCMxGUKAsg';
const locationId = 'LJ8SPTZMQP6TS';
const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

async function initializeCard(payments) {
    const card = await payments.card();
    await card.attach('#card-container');
    return card;
}

document.addEventListener('DOMContentLoaded', async function () {
    if (!window.Square) {
        throw new Error('Square.js failed to load properly');
    }
    const payments = window.Square.payments(appId, locationId);
    let card;
    try {
        card = await initializeCard(payments);
    } catch (e) {
        console.error('Initializing Card failed', e);
        return;
    }

    const cardButton = document.getElementById(
        'card-button'
    );
    cardButton.addEventListener('click', async function (event) {
        await handlePaymentMethodSubmission(event, card, true);
    });

    // Step: create card payment
    async function handlePaymentMethodSubmission(event, paymentMethod, shouldVerify = false ) {
        event.preventDefault();

        try {
            // disable the submit button as we await tokenization and make a
            // payment request.
            cardButton.disabled = true;
            const token = await tokenize(paymentMethod);
            let verificationToken;
            if (shouldVerify) {
                verificationToken = await verifyBuyer(
                    payments,
                    token
                );
            }
            const paymentResults = await createPayment(token, verificationToken);
            if (paymentResults && paymentResults.success) {
                window.location.href = `/receipt/${paymentResults.payment_id}`;
            } else {
                throw new Error('Payment processing failed');
            }
        } catch (e) {
            cardButton.disabled = false;
            console.error(e.message);
        }
    }

});

async function tokenize(paymentMethod) {
    const tokenResult = await paymentMethod.tokenize();
    if (tokenResult.status === 'OK') {
        return tokenResult.token;
    } else {
        let errorMessage = `Tokenization failed-status: ${tokenResult.status}`;
        if (tokenResult.errors) {
            errorMessage += ` and errors: ${JSON.stringify(
                tokenResult.errors
            )}`;
        }
        throw new Error(errorMessage);
    }
}

async function verifyBuyer(payments, token) {
    const isBillingChecked = document.getElementById('billing-checkbox').checked;
    let address = isBillingChecked ? getShippingAddress() : getBillingAddress();

    // Get the total amount from the HTML
    const totalElement = document.getElementById('total_money');
    const totalText = totalElement.textContent || totalElement.innerText;
    const totalAmount = parseFloat(totalText.replace(/[^0-9.,]/g, '').replace(',', '.'));
    const amountString = totalAmount.toFixed(2).toString();

    const verificationDetails = {
        amount: amountString,
        currencyCode: 'CAD',
        intent: 'CHARGE',
        billingContact: {
            givenName: address.firstName,
            familyName: address.lastName,
            email: document.getElementById('email').value,
            addressLines: [address.address, address.apartment],
            city: address.city,
            state: address.province,
            countryCode: 'CA',
            postalCode: address.postalCode
        },
    };

    const verificationResults = await payments.verifyBuyer(token, verificationDetails);
    return verificationResults.token;
}



async function createPayment(token, verificationToken) {
    const email = document.getElementById('email').value;
    if (!validateEmail(email)) {
        displayEmailError("Please enter a valid email address. Veuillez entrer une adresse email valide.");

        return;
    }

    const shippingAddress = getShippingAddress();
    let billingAddress = {};
    const isBillingChecked = document.getElementById('billing-checkbox').checked;
    if (!isBillingChecked) {
        billingAddress = getBillingAddress();
    }

    const body = JSON.stringify({
        sourceId: token,
        verificationToken,
        shippingAddress,
        billingAddress,
        isBillingChecked
    });


    const paymentResponse = await fetch('/process_square_payment', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': csrfToken
        },
        body,
    });

    if (paymentResponse.ok) {
        displayPaymentResults('SUCCESS');
        return paymentResponse.json();
    }  else {
        const errorBody = await paymentResponse.json();
        displayPaymentResults('FAILURE');
        displayErrors(errorBody.errors);
        throw new Error('Payment processing failed');
    }
}

function displayErrors(errors) {
    // Clear existing errors
    document.querySelectorAll('.text-danger').forEach(el => el.textContent = '');

    // Display new errors
    for (const key in errors) {
        const errorElement = document.getElementById(`${key}-error`);
        if (errorElement) {
            errorElement.textContent = errors[key];
        }
    }
}

function displayPaymentResults(status) {
    const statusContainer = document.getElementById('payment-status-container');
    const statusMessageElement = document.getElementById('payment-status-message');

    if (status === 'SUCCESS') {
        statusContainer.classList.remove('is-failure');
        statusContainer.classList.add('is-success');
    } else {
        statusContainer.classList.remove('is-success');
        statusContainer.classList.add('is-failure');
        statusMessageElement.textContent = "Payment failed. Please try again."; // Add a failure message
    }

    statusContainer.style.visibility = 'visible';
}


function getShippingAddress() {
    return {
        email: document.getElementById('email').value,
        firstName: document.getElementById('shipping-first-name').value,
        lastName: document.getElementById('shipping-last-name').value,
        address: document.getElementById('shipping-address-line').value,
        company: document.getElementById('shipping-company').value,
        apartment: document.getElementById('shipping-apartment').value,
        city: document.getElementById('shipping-city').value,
        province: document.getElementById('shipping-province').value,
        postalCode: document.getElementById('shipping-postal-code').value,
        country: document.getElementById('shipping-country').value,
        phone: document.getElementById('shipping-phone').value
    };
}

function getBillingAddress() {
    return {
        firstName: document.getElementById('billing-first-name').value,
        lastName: document.getElementById('billing-last-name').value,
        address: document.getElementById('billing-address-line').value,
        company: document.getElementById('billing-company').value,
        apartment: document.getElementById('billing-apartment').value,
        city: document.getElementById('billing-city').value,
        province: document.getElementById('billing-province').value,
        postalCode: document.getElementById('billing-postal-code').value,
        country: document.getElementById('billing-country').value,
    };
}

function validateEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

function displayEmailError(errorMessage) {
    const errorElement = document.getElementById('shipping-email-error');
    if (errorElement) {
        errorElement.textContent = errorMessage;
    }
}
