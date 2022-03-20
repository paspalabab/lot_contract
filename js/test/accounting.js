const { expect } = require("chai");
const { ethers } = require("hardhat");

const {
  lot_accounting,
} = require('./lot_libbehavior');

const {
  dai_accounting,
} = require('./dai_libbehavior');

describe("LotteryShop Auto Testing", function () {
  it("begin...", async function () {

    //getsigners
  
    const accounts = await ethers.getSigners();
    const Daijson= require('./DaiAddress.json'); 
    const DaiArtifact= require('../artifacts/contracts/Dai.sol/Dai.json'); 

    dai = new ethers.Contract(
      Daijson.Dai,
      DaiArtifact.abi,
      accounts[0]
    );
    await dai.deployed();
    
    //accounting
    dai_accounting(dai, accounts);
    lot_accounting(1);
    
  });
});
