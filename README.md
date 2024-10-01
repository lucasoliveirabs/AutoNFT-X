# About

**AutoNFT-X** is a tokenization solution designed to provide ownership and state tracking of vehicles using NFTs. The solution consists of an ERC721-based NFT contract deployed on the Ethereum mainnet and an express.js API to interact with the smart contract.

## Features

The API will provide following functionalities:

1. **Mint a new NFT** – Creates an NFT representing a vehicle, storing its metadata on IPFS.
   1. **Receive form data and image via POST request** – The API accepts the vehicle data and an image file from a client-side form submission.
   2. **Upload image to IPFS via Pinata** – The image is stored on the decentralized file system IPFS through Pinata service.
   3. **Upload metadata (vehicle data + image hash) to IPFS via Pinata** – The vehicle's metadata, along with the IPFS hash of the image, is uploaded to IPFS.
   4. **Mint a new NFT based on the provided data** – The API interacts with the ERC721 smart contract to mint a new token representing the vehicle.
   5. **Publish NFT on OpenSea** – The minted NFT is listed and made available for viewing on the OpenSea marketplace.
2. **Transfer NFT** – Facilitates the transfer of the NFT from one owner to another.
3. **Get vehicle data by ID** – Retrieves vehicle information linked to the specific NFT ID.
4. **Get vehicle history by ID** – Provides historical data of a vehicle's changes over time.

<br>

AutoNFT-X contract inherits and exposes the functions of [ERC721](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol), [ERC721URIStorage](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol), [ERC721Pausable](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Pausable.sol), [Ownable](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol), and [ERC721Burnable](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Burnable.sol).

# Configuration

The owner's (deployer) private key, which is used for signing transactions, must be configured separately for contract deployment and each API interaction.
<br>
We assume the same private key, owner's, is used for both configurations. As a result, the gas costs for deploying the contract and for each API call will be deducted from the balance of the address associated with this private key.

### Contracts

1. Create './AutoNFT-X/.env' and paste/fill in:

   > CHAIN_ID=1<br>
   > MAINNET_NODE_RPC_URL=[infura-cloud-endpoint](https://docs.infura.io/api/network-endpoints)<br>
   > PRIVATE_KEY=[0x...b2](https://support.metamask.io/pt-br/managing-my-wallet/secret-recovery-phrase-and-private-keys/how-to-export-an-accounts-private-key/). PS: Add '0x' as the example<br>
   > ETHERSCAN_API_KEY=[owner-etherscan-api-key](https://docs.etherscan.io/getting-started/viewing-api-usage-statistics)<br>

### API

<br>

---

# Ethereum mainnet deployment

At './AutoNFT-X/':

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
forge --version
forge build --via-ir
forge script script/AutoNFT.s.sol:AutoNFTScript --via-ir --rpc-url $MAINNET_NODE_RPC_URL --broadcast --verify
```

Two transaction hashes will be logged: contract deployment one and first AutoNFT minting one. Go to [etherscan](https://etherscan.io/) and query the hashes to confirm deployment success.
