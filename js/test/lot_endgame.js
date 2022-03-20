const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("LotteryShop Auto Testing", function () {
  it("begin...", async function () {

    //getsigners
    //console.log('------------getsigners--------------');
    const accounts = await ethers.getSigners();
    /*for (const account of accounts) {
        console.log('0x..'+account.address.slice(38));
    }
    const theWard = accounts[0];*/

    const Lotjson= require('./LotAddress.json'); 
    const LotArtifact= require('../artifacts/contracts/Lot.sol/Lot.json'); 
    console.log("Address of Lot Deployed: " + Lotjson.Lot);

    lot = new ethers.Contract(
      Lotjson.Lot,
      LotArtifact.abi,
      accounts[0]
    );
    console.log("lot object address: " + lot.address);
    await lot.deployed();

    console.log('-----------LotteryShop cloase Game-----------------');
    const txLot = await lot.End();
    await txLot.wait();
    
  });
});
