const dotenv = require("dotenv");
const multer = require('multer');
const FormData = require('form-data');
const ethers = require('ethers');
const cors = require('cors');
const axios = require('axios');
const bodyParser = require('body-parser');
const swaggerUi = require('swagger-ui-express');
const swaggerFile = require('./swagger-output.json');
const express = require("express");

const app = express();
app.use(cors());
app.use(express.json());
app.use(bodyParser.json());
app.use('/docs', swaggerUi.serve, swaggerUi.setup(swaggerFile));

dotenv.config();
const port = process.env.PORT || 3000;
const upload = multer({ storage: multer.memoryStorage() });
const abi = require('../AutoNFT-X/out/AutoNFT.sol/AutoNFT.json');

app.post("/mint", upload.single('file'), async (req, res) => {
    if (!req.file) return res.status(400).send('No file uploaded received');
    if (!req.body) return res.status(400).send('No vehicle data received');

    const vehicleOwnerAddress = req.body.vehicleOwnerAddress;   //  remove minting-time vehicle owner address, ownership will be tracked by ERC721 contract state variable
    delete req.body.vehicleOwnerAddress;

    const { vehicleManufacturer, vehicleModel, year, vin, color } = req.body;
    const imageIPFSHash = await deployImageIPFS(req.file, res);
    const metadataIPFSHash = await deployMetadataIPFS(imageIPFSHash, vehicleManufacturer, vehicleModel, year, vin, color);

    const vehicleId = mintNFT(metadataIPFSHash, vehicleOwnerAddress, vehicleManufacturer, vehicleModel, year, vin, color, abi);   //  use ethers.js to return get the id returned
    res.status(201).send({ imageIPFSHash });
    /*const openseaUrl = getOpenSeaURL(vehicleId);
    const etherscanVehicleIdURL = getEtherscanVehicleIdURL();
 
    res.status(201).send({vehicleId, vehicleOwnerAddress, etherscanVehicleIdURL, contractAddress, metadataIPFSHash, openseaUrl});
    */
});

const deployImageIPFS = async (_file, res) => {
    try {
        const data = new FormData();
        data.append("file", _file.buffer, _file.originalname);

        const response = await axios.post('https://api.pinata.cloud/pinning/pinFileToIPFS', data, {
            headers: {
                "pinata_api_key": process.env.PINATA_API_KEY,
                "pinata_secret_api_key": process.env.PINATA_API_SECRET
            }
        });

        return response.data.IpfsHash;
    } catch (err) {
        console.log(err);
        res.status(500).send("Failed deploying image to IPFS");
    }
}

const deployMetadataIPFS = async (_imageCID, _vehicleManufacturer, _vehicleModel, _year, _vin, _color) => {
    try {
        const metadata = {
            name: `${_vehicleManufacturer} ${_vehicleModel}`,
            description: `${_year} ${_vehicleManufacturer} ${_vehicleModel}`,
            image: `ipfs://${_imageCID}`,
            attributes: [
                { trait_type: "Manufacturer", value: _vehicleManufacturer },
                { trait_type: "Model", value: _vehicleModel },
                { trait_type: "Year", value: _year },
                { trait_type: "VIN", value: _vin },
                { trait_type: "Color", value: _color }
            ]
        };

        const response = await fetch("https://api.pinata.cloud/pinning/pinJSONToIPFS", {
            method: "POST",
            headers: {
                'Content-Type': 'application/json',
                "pinata_api_key": process.env.PINATA_API_KEY,
                "pinata_secret_api_key": process.env.PINATA_API_SECRET
            },
            body: JSON.stringify(metadata),
        });

        const result = await response.json();
        return result.IpfsHash;
    } catch (error) {
        console.log(error);
        res.status(500).send("Failed deploying metadata to IPFS");
    }
}

const mountIPFSUri = (_metadataIPFSHash) => {
    return `ipfs://${_metadataIPFSHash}`;
}

const mintNFT = async (_metadataIPFSHash, _vehicleOwnerAddress, _vehicleManufacturer, _vehicleModel, _year, _vin, _color, _abi) => {
    try {
        const provider = new ethers.JsonRpcProvider(process.env.LOCAL_PROVIDER);
        const wallet = new ethers.Wallet(process.env.PRIVATE_KEY);
        const signer = wallet.connect(provider);

        //get address e abi
        //definir essa geração de dados .env e uso do docker. o cliente precisa setar os dados antes de deployar contrato e interagir via API
        const contract = new ethers.Contract(process.env.CONTRACT_ADDRESS, _abi, signer);
        const tx = await contract.safeMint(_vehicleOwnerAddress, _metadataIPFSHash);
        await tx.wait();
        return tx.hash;
    } catch (error) {
        console.log(error);
        res.status(500).send("Failed minting NFT");
    }
}

const getOpenSeaURL = (_vehicleId) => {

}

const getEtherscanVehicleIdURL = () => {

}

//http
app.listen(port, () => {
    console.log("Server running at port: " + port);
})