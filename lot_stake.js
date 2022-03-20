const { expect } = require("chai");
const { ethers } = require("hardhat");

const {
  lot_accounting,
} = require('./lot_libbehavior.js');

describe("LotteryShop Auto Testing", function () {
  it("begin...", async function () {

    //getsigners
    const accounts = await ethers.getSigners();
    /*
    for (const account of accounts) {
        console.log('0x..'+account.address.slice(38));
    }
    const theWard = accounts[0];*/

    const Daijson= require('./DaiAddress.json'); 
    console.log("Address of Dai Deployed: " + Daijson.Dai);

    const Lotjson= require('./LotAddress.json'); 
    const LotArtifact= require('../artifacts/contracts/Lot.sol/Lot.json'); 
    console.log("Address of Lot Deployed: " + Lotjson.Lot);

    lot = new ethers.Contract(
      Lotjson.Lot,
      LotArtifact.abi,
      accounts[0]
    );
    await lot.deployed();

    console.log('-----------LotteryShop stake-----------------');
    let txLot = await lot.connect(accounts[1]).Stake(1,20);
    await txLot.wait();   
    txLot = await lot.connect(accounts[2]).Stake(1,20);
    await txLot.wait();   
    txLot = await lot.connect(accounts[3]).Stake(0,20);
    await txLot.wait();   
    txLot = await lot.connect(accounts[4]).Stake(0,20);
    await txLot.wait();    
  });
});
