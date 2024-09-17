const express = require("express");
const FormData = require("form-data");

const dotenv = require("dotenv");
dotenv.config();
const port = process.env.PORT || 3000;

const app = express();
app.use(express.json());

const multer = require("multer");
const storage = multer.memoryStorage();
const upload = multer({storage: storage});

app.post("/nft", upload.single('image') ,(req, res) => {
    
        if (!req.file) return res.status(400).send('No file uploaded received');
        if (!req.body) return res.status(400).send('No vahicle data was received');

        //receives: form data + image + deployer data 

        //mountFormData         
        //deployIPFS
        //createNFT
        //deployNFT
        //deployOpenSea

        //why formdata?
        const FormData = new FormData();
        FormData.append('file', req.file.buffer, {
            filename: req.body.vin,
            contentType: req.file.mimetype
        });
    
        //res.status(201).send("Photo hash, deployed contract address, owner address");      
})

const mountFormData = () => {
    try {
    
    } catch(error) {
        res.status(500).send("Failed uploading file");
    }  
}

const deployIPFS = () => {

}

const createNFT = () => {
    try{

    } catch(error){
        res.status(500).send("Failed creating NFT");
    }
}

const deployNFT = () => {

}

const deployOpenSea = () => {

}
//turn to https?
app.listen(port, () => {
    console.log("Server running at port: "+port);
})