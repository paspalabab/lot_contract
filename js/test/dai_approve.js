const { expect } = require("chai");
const { ethers } = require("hardhat");

const {
  MintDai,
  PushDaiExample,
  ApproveDai,
  TransferFromDai,
} = require('./dai_libbehavior');

describe("LotteryShop Auto Testing", function () {
  it("Approve...", async function () {

    //getsigners
    //console.log('------------getsigners--------------');
    const accounts = await ethers.getSigners();
    /*
    for (const account of accounts) {
        console.log('0x..'+account.address.slice(38));
    }
    const theWard = accounts[0];*/

    const Daijson= require('./DaiAddress.json'); 
    const DaiArtifact= require('../artifacts/contracts/Dai.sol/Dai.json'); 
    console.log("Address of Dai Deployed: " + Daijson.Dai);

    dai = new ethers.Contract(
      Daijson.Dai,
      DaiArtifact.abi,
      accounts[0]
    );
    await dai.deployed();

    const Lotjson= require('./LotAddress.json');  
    console.log("Address of Lot Deployed: " + Lotjson.Lot);        

    ApproveDai(dai,accounts[1],Lotjson.Lot,10000);
    ApproveDai(dai,accounts[2],Lotjson.Lot,10000);
    ApproveDai(dai,accounts[3],Lotjson.Lot,10000);
    ApproveDai(dai,accounts[4],Lotjson.Lot,10000);

  });
});
