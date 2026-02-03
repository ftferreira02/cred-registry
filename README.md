# Credential Registry

A blockchain-based credential registry for issuing and verifying document credentials on Ethereum.

## Overview

This project provides a decentralized solution for credential management, allowing authorized issuers to register document hashes on-chain and enabling anyone to verify their authenticity.

## Project Structure

```
├── contracts/     # Solidity smart contracts (Hardhat 3)
└── frontend/      # React + Vite web interface
```

## Smart Contract

The `CredentialRegistry` contract provides:

- **Role-based access control** - Admin and Issuer roles
- **Issue credentials** - Register document hashes on-chain
- **Revoke credentials** - Mark credentials as revoked
- **Verify credentials** - Check if a document hash is valid and not revoked

## Getting Started

### Contracts

```bash
cd contracts
npm install
npx hardhat test
```

### Frontend

```bash
cd frontend
npm install
npm run dev
```

## License

MIT
