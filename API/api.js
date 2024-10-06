const express = require("express");
const app = express();
const cors = require('cors');
app.use(cors());
app.use(express.json());
const axios = require('axios');

const multer = require('multer');
const upload = multer({ storage: multer.memoryStorage() });
const FormData = require('form-data');

const dotenv = require("dotenv");
dotenv.config();
const port = process.env.PORT || 3000;


app.post("/mint", upload.single('file'), async ( req, res) => {
    if (!req.file) return res.status(400).send('No file uploaded received');
    if (!req.body) return res.status(400).send('No vehicle data received');

    const vehicleOwnerAddress = req.body.vehicleOwnerAddress;   //  remove minting-time vehicle owner address, ownership will be tracked by ERC721 contract state variable
    delete req.body.vehicleOwnerAddress;

    const {vehicleManufacturer, vehicleModel, year, vin, color} = req.body;
    const imageIPFSHash = await deployImageIPFS(req.file, res);
    const metadataIPFSHash = await deployMetadataIPFS(imageIPFSHash, vehicleManufacturer, vehicleModel, year, vin, color);
    console.log(metadataIPFSHash);
    res.status(201).send({imageIPFSHash});
        /*
        const vehicleId = mintNFT(vehicleOwnerAddress, vehicleManufacturer, vehicleModel, year, vin, color, getIPFSUri(metadataIPFSHash));   //  use ethers.js to return get the id returned
        const openseaUrl = getOpenSeaURL(vehicleId);
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

const getIPFSUri = (_metadataIPFSHash) => {
    return `ipfs://${_metadataIPFSHash}`;
}

const mintNFT = (_metadataIPFSHash, _vehicleOwnerAddress) => {
    try{

    } catch(error){
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
    console.log("Server running at port: "+port);
})