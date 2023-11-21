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
        await handlePaymentMethodSubmission(event, card);
    });

    // Step 5.2: create card payment
    async function handlePaymentMethodSubmission(event, paymentMethod) {
        event.preventDefault();

        try {
            // disable the submit button as we await tokenization and make a
            // payment request.
            cardButton.disabled = true;
            const token = await tokenize(paymentMethod);
            const paymentResults = await createPayment(token);
            if (paymentResults && paymentResults.success) {
                window.location.href = `/receipt/${paymentResults.payment_id}`;
            } else {
                throw new Error('Payment processing failed');
            }
            console.debug('Payment Success', paymentResults);
        } catch (e) {
            cardButton.disabled = false;
            // displayPaymentResults('FAILURE');
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

async function createPayment(token) {
    const body = JSON.stringify({
        sourceId: token
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
        // displayPaymentResults('SUCCESS');
        return paymentResponse.json();
    }
    const errorBody = await paymentResponse.text();
    throw new Error(errorBody);
}


// function displayPaymentResults(status) {
//     const statusContainer = document.getElementById(
//         'payment-status-container'
//     );
//     if (status === 'SUCCESS') {
//         statusContainer.classList.remove('is-failure');
//         statusContainer.classList.add('is-success');
//     } else {
//         statusContainer.classList.remove('is-success');
//         statusContainer.classList.add('is-failure');
//     }
//
//     statusContainer.style.visibility = 'visible';
// }
