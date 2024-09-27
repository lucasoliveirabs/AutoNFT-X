# About

why
how
what

The project consists in a vehicle NFT ERC721-based for Ethereum and it's relational API. The API exposes POST("/nft) which receives form data + image file and responds the deployed contract address and its owner address.
<br>

<br>
The NFT contract inherits and exposes the functions of [ERC721](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol), [ERC721URIStorage](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol), [ERC721Pausable](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Pausable.sol), [Ownable](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol), and [ERC721Burnable](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Burnable.sol).
<br>
The main functionalities are the ones related to 
# Ethereum mainnet configuration

Owner's private key, responsible for transaction signing, must be configured deparately for contract deployment and for every API interaction.

Following description considers the same private key for both configurations, so the gas cost of contract deployment and of every API call will be discounted of this private key's address.

## Contracts

1. Create './AutoNFT-X/.env' and paste/fill in:

   > CHAIN_ID=1
   > MAINNET_NODE_RPC_URL=[infura-cloud-endpoint](https://docs.infura.io/api/network-endpoints)
   > PRIVATE_KEY=[0x...b2](https://support.metamask.io/pt-br/managing-my-wallet/secret-recovery-phrase-and-private-keys/how-to-export-an-accounts-private-key/). PS: Add '0x' as the example
   > ETHERSCAN_API_KEY=[owner-etherscan-api-key](https://docs.etherscan.io/getting-started/viewing-api-usage-statistics)

## API

---

# Ethereum mainnet deployment

At './AutoNFT-X/':

```
curl -L https://foundry.paradigm.xyz | bash
foundryup
forge --version
forge build --via-ir
forge script script/AutoNFT.s.sol:AutoNFTScript --via-ir --rpc-url $MAINNET_NODE_RPC_URL --broadcast --verify
```

Two transaction hashes will be logged: the first of contract's deployment and the second of first AutoNFT minting. Go to [etherscan](https://etherscan.io/) and query the hashes to confirm the success.
