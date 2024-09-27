const express = require("express");

const dotenv = require("dotenv");
dotenv.config();
const port = process.env.PORT || 3000;

const app = express();
app.use(express.json());

const multer = require("multer");
const storage = multer.memoryStorage();
const upload = multer({storage: storage});

app.post("/mint", upload.single('image') ,(req, res) => {
    
        if (!req.file) return res.status(400).send('No file uploaded received');
        if (!req.body) return res.status(400).send('No vahicle data was received');

        //  remove first vehicle owner address for NFT contract metadata deploy
        const vehicleOwnerAddress = req.body.vehicleOwnerAddress;
        delete req.body.vehicleOwnerAddress;

        const imageIPFSHash = deployImageIPFS(req.file);
        const metadataIPFSHash = deployMetadataIPFS(imageIPFSHash, req.body);
        const vehicleId = mintNFT(metadataIPFSHash, vehicleOwnerAddress);   //  use ethers.js
        const openseaUrl = getOpenSeaURL(vehicleId);
        const etherscanVehicleIdURL = getEtherscanVehicleIdURL();
    
        res.status(201).send({vehicleId, vehicleOwnerAddress, etherscanVehicleIdURL, contractAddress, metadataIPFSHash, openseaUrl});
    })

const deployImageIPFS = (_file) => {
    const file = _file;
}

const deployMetadataIPFS = (_file, _body) => {
    const {vehicleOwnerAddress, vehicleManufacturer,_vehicleModel, year, vin, color} = _body;

    //mount pattern -> data + image? 
}

const mintNFT = (_metadataIPFSHash, _vehicleOwnerAddress) => {
    try{

    } catch(error){
        res.status(500).send("Failed minting NFT");
    }
}

const getOpenSeaURL = (_vehicleId) => {
    
}

const getEtherscanVehicleIdURL = () => {

}

//turn to https?
app.listen(port, () => {
    console.log("Server running at port: "+port);
})