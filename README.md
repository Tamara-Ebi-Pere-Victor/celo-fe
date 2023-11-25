# CELO-FE

## Table of Contents

- [Description](#description)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)

## Description

Welcome to Celo FrontEnd 101, a marketplace dapp enabling users to view, buy, add, update, and delete their own products in the marketplace. It provides a transaction history feature, showing users items they've bought and the number of times they've purchased each item. The Celo Eur stable currency is used for payment confirmation.

## Features

1. [View list of products in the marketplace](#view-list-of-products)
2. [Add new products](#add-new-products)
3. [Edit or delete your own product](#edit-or-delete-products)
4. [View items you've bought and purchase history](#view-purchase-history)

## Tech Stack

This web application uses the following tech stack:

- [Solidity](https://docs.soliditylang.org/) - A programming language for Ethereum smart contracts.
- [React](https://reactjs.org/) - A JavaScript library for building user interfaces.
- [Typescript](https://www.typescriptlang.org) - A strongly typed programming language that builds on JavaScript.
- [Rainbowkit-celo](https://docs.celo.org/developer/rainbowkit-celo) - React library for easy wallet connection to dapp.
- [Wagmi](https://wagmi.sh) - React Hooks for working with Ethereum.
- [Hardhat](https://hardhat.org/) - A tool for writing and deploying smart contracts.
- [TailwindCss](https://tailwindcss.com) - A CSS framework for styling.

## Installation

To run the application locally, follow these steps:

1. Clone the repository to your local machine using: `git clone https://github.com/Tamara-Ebi-Pere-Victor/celo-fe.git`
2. Move into the react-app folder: `cd celo-fe/packages/react-app`
3. Install dependencies: `npm install` or `yarn install`
4. Start the application: `npm run dev`
5. Open the application in your web browser at `http://localhost:3000`

## Usage

1. Install a wallet: [MetamaskExtensionWallet](https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn?hl=en).
2. Create a wallet.
3. Get tokens for the alfajores testnet at [https://faucet.celo.org/alfajores](https://faucet.celo.org/alfajores).
4. Switch to the alfajores testnet.
5. Connect your wallet to the app.
6. Create multiple products.
7. Try to edit or delete products.
8. Switch to another account and buy items.
9. Check your item dashboard to see the items you bought.

## Contributing

1. Fork this repository.
2. Create a new branch for your changes: `git checkout -b my-feature-branch`
3. Make your changes and commit them: `git commit -m "feat: create new feature"`
4. Push your changes to your fork: `git push origin my-feature-branch`
5. Open a pull request to this repository with a description of your changes.

Please ensure that your code follows the Solidity Style Guide and the React Style Guide. You can add tests for any new features or changes, and consider making the front-end more user-friendly. Contributions and feedback are welcome!
