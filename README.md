# PowerClick for Google Tag Manager

Loads [PowerClick](https://powerclick.io) click attribution on your site. PowerClick sits between the ad click and everything
downstream: it captures every ad click on the first page, follows the visitor's journey and credits each sale to
the click that brought it, then sends cleaner signals to your server container, your ad platforms and your reports.

## Setup

1. Add the **PowerClick** tag from the Community Template Gallery.
2. Enter your **Account ID** from PowerClick onboarding.
3. Fire it on **Initialization - All Pages**, with no consent conditions: PowerClick reads Google Consent Mode itself
   and waits for consent where your PowerClick settings require it.
4. Optional, with the **PowerClick First-Party Proxy** client in your server container: set **First-party script URL**
   to `https://<your server container domain>/c/l.js` and add that domain to this template's *Injects scripts*
   permission, so the script loads from your own domain.

All tracking logic is hosted by PowerClick, so this tag rarely needs updating; settings change in your PowerClick
account and reach your site within minutes.

## Permissions

- **Injects scripts:** `https://js.powerclick.io/*` - the PowerClick loader for your account.
