# Tokenized Renewable Energy Certificate (REC) Trading System

## Overview

This project implements a blockchain-based system for the verification, issuance, and trading of Renewable Energy Certificates (RECs). By tokenizing RECs, we enable more transparent, efficient, and accessible renewable energy markets while reducing fraud and improving regulatory compliance.

## Problem Statement

Traditional REC systems face several challenges:
- Manual verification processes are slow and error-prone
- Tracking generation across distributed sources is difficult
- Certificate issuance often involves significant paperwork
- Trading occurs in fragmented, illiquid markets
- Regulatory compliance reporting is burdensome

Our solution leverages blockchain technology to automate and secure these processes, creating a more efficient marketplace for renewable energy credits.

## System Architecture

The system consists of five interconnected smart contracts:

1. **Generator Verification Contract**
2. **Production Tracking Contract**
3. **Certificate Issuance Contract**
4. **Trading Contract**
5. **Compliance Contract**

### Contract Interactions

```
┌─────────────────────┐      ┌─────────────────────┐      ┌─────────────────────┐
│  Generator          │      │  Production         │      │  Certificate        │
│  Verification       │───┬─▶│  Tracking           │─────▶│  Issuance           │
│  Contract           │   │  │  Contract           │      │  Contract           │
└─────────────────────┘   │  └─────────────────────┘      └──────────┬──────────┘
                          │                                          │
                          │                                          │
                          │                                          ▼
                          │                              ┌─────────────────────┐
                          │                              │  Trading            │
                          └─────────────────────────────▶│  Contract           │
                                                         │                     │
                                                         └──────────┬──────────┘
                                                                    │
                                                                    │
                                                                    ▼
                                                         ┌─────────────────────┐
                                                         │  Compliance         │
                                                         │  Contract           │
                                                         │                     │
                                                         └─────────────────────┘
```

## Smart Contracts

### 1. Generator Verification Contract

This contract validates and registers renewable energy producers on the blockchain.

**Key Features:**
- Verification of renewable energy generation facilities
- Storage of producer credentials and technical specifications
- Integration with external verification services (optional)
- Periodic re-verification requirements
- Multi-signature approval for verification

**Main Functions:**
- `registerGenerator()`: Register a new renewable energy producer
- `verifyGenerator()`: Verify a producer's credentials and equipment
- `updateGeneratorInfo()`: Update producer information
- `revokeVerification()`: Remove verification status for non-compliant generators

### 2. Production Tracking Contract

This contract records and verifies the actual production of renewable energy.

**Key Features:**
- Integration with IoT devices for real-time monitoring
- Secure data feeds from energy meters
- Validation of energy production claims
- Historical production data storage
- Anomaly detection for suspicious generation patterns

**Main Functions:**
- `recordProduction()`: Log new energy production data
- `verifyProduction()`: Validate production claims against meter readings
- `getProductionHistory()`: Retrieve historical production data
- `calculateTotalProduction()`: Calculate total energy produced over time periods

### 3. Certificate Issuance Contract

This contract creates tokenized RECs based on verified energy production.

**Key Features:**
- Automated certificate creation based on production data
- Unique token generation with production metadata
- Implementation of standardized REC attributes
- Certificate expiration and retirement mechanisms
- Support for different REC types (solar, wind, hydro, etc.)

**Main Functions:**
- `issueREC()`: Create new REC tokens based on verified production
- `batchIssueRECs()`: Issue multiple certificates at once
- `getCertificateDetails()`: Get metadata for a specific REC
- `verifyCertificate()`: Validate a certificate's authenticity
- `retireCertificate()`: Mark certificates as used for compliance

### 4. Trading Contract

This contract manages the buying, selling, and transferring of RECs.

**Key Features:**
- Peer-to-peer trading capabilities
- Auction mechanisms for price discovery
- Order book functionality
- Escrow services for secure transactions
- Price history tracking and transparency

**Main Functions:**
- `listForSale()`: Offer RECs for sale at a specified price
- `createBuyOrder()`: Place an order to purchase RECs
- `executeTradeOrder()`: Complete a trade between buyer and seller
- `transferREC()`: Transfer REC ownership directly to another address
- `getMarketPrice()`: Get current market price for specific REC types

### 5. Compliance Contract

This contract tracks and enforces regulatory compliance requirements.

**Key Features:**
- Automated compliance reporting
- Support for multiple regulatory frameworks
- Real-time compliance status tracking
- Proof of compliance generation
- Integration with regulatory authority systems

**Main Functions:**
- `registerComplianceObligation()`: Record a compliance requirement
- `submitComplianceReport()`: Submit RECs for compliance purposes
- `verifyCompliance()`: Check if an entity has met its requirements
- `generateComplianceReport()`: Create reports for regulatory authorities
- `setComplianceDeadline()`: Establish deadlines for regulatory compliance

## Getting Started

### Prerequisites

- Ethereum development environment (Hardhat, Truffle, or Foundry)
- Node.js and npm
- MetaMask or similar Ethereum wallet
- Access to an Ethereum network (local, testnet, or mainnet)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/tokenized-rec-trading.git
cd tokenized-rec-trading
```

2. Install dependencies:
```bash
npm install
```

3. Compile the smart contracts:
```bash
npx hardhat compile
```

4. Deploy the contracts:
```bash
npx hardhat run scripts/deploy.js --network <your-network>
```

### Configuration

1. Update the `.env` file with your specific configuration:
```
PRIVATE_KEY=your_private_key
INFURA_API_KEY=your_infura_api_key
ETHERSCAN_API_KEY=your_etherscan_api_key
```

2. Configure the network settings in `hardhat.config.js` for your target deployment environment.

## Usage

### For Energy Producers

1. Register your generation facility through the Generator Verification Contract
2. Connect your production monitoring equipment to the system
3. Automatically receive RECs as you generate renewable energy
4. Sell your RECs on the marketplace or hold them for compliance

### For Energy Consumers & Compliance Entities

1. Browse available RECs on the marketplace
2. Purchase RECs to meet your renewable energy targets
3. Submit RECs for compliance with regulatory requirements
4. Generate compliance reports for authorities

### For Regulators & Auditors

1. Monitor compliance status across multiple entities
2. Verify the authenticity of RECs and compliance claims
3. Access transparent records of energy production and certificate trading
4. Generate regulatory reports with verifiable blockchain data

## Development

### Running Tests

```bash
npx hardhat test
```

### Local Development

1. Start a local Ethereum node:
```bash
npx hardhat node
```

2. Deploy contracts to the local network:
```bash
npx hardhat run scripts/deploy.js --network localhost
```

3. Interact with the contracts using the Hardhat console:
```bash
npx hardhat console --network localhost
```

## Security Considerations

- All contracts should undergo thorough security audits before production deployment
- Implement proper access control mechanisms for administrative functions
- Consider using upgradeable contract patterns for critical components
- Implement circuit breakers and emergency pause functionality
- Ensure secure oracle integrations for external data feeds

## Roadmap

- **Phase 1:** Core contract development and testing
- **Phase 2:** UI development and integration
- **Phase 3:** Oracle integration for automated data feeds
- **Phase 4:** Cross-chain compatibility for inter-blockchain trading
- **Phase 5:** Integration with existing energy market systems

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Acknowledgments

- Renewable energy industry partners
- Ethereum development community
- Regulatory advisors and energy market experts
