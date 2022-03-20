const { expect } = require("chai");
const { ethers } = require("hardhat");

const {
  MintDai,
  PushDaiExample,
  ApproveDai,
  TransferFromDai,
} = require('./dai_libbehavior');

describe("LotteryShop Auto Testing", function () {
  it("begin...", async function () {

    //getsigners
    //console.log('------------getsigners--------------');
    const accounts = await ethers.getSigners();
    /*
    for (const account of accounts) {
        console.log('0x..'+account.address.slice(38));
    }*/
    const theWard = accounts[0];

    const Daijson= require('./DaiAddress.json'); 
    const DaiArtifact= require('../artifacts/contracts/Dai.sol/Dai.json'); 
    console.log("Address of Dai Deployed: " + Daijson.Dai);

    dai = new ethers.Contract(
      Daijson.Dai,
      DaiArtifact.abi,
      accounts[0]
    );
    console.log("dai object address: " + dai.address);

    //console.log('-----------Dai Deployment-----------------');
    //const Dai = await ethers.getContractFactory("Dai");
    //const dai = await Dai.deploy(1337);
    await dai.deployed();
    console.log('Dai ERC20 Contract Address: ' + dai.address);
    expect(await dai.name()).to.equal("Dai Stablecoin");
    expect(await dai.symbol()).to.equal("DAI");
    expect(await dai.version()).to.equal('1');
    expect(await dai.decimals()).to.equal(18);
    console.log('name: ' + await dai.name());
    console.log('symbol: ' + await dai.symbol());
    console.log('version: ' + await dai.version());
    console.log('decimals: ' + await dai.decimals());
    expect(await dai.wards(theWard.address)).to.equal(1);
    expect(await dai.wards(accounts[1].address)).to.equal(0);
    expect(await dai.wards(accounts[2].address)).to.equal(0);
    expect(await dai.wards(accounts[3].address)).to.equal(0);
    expect(await dai.wards(accounts[4].address)).to.equal(0);   
    
    //mint test
    MintDai(dai,accounts,0,10000,10000,10000,10000 );
     
    //push test
    //PushDaiExample(dai,accounts);
    
    //Tranfer test
    //TransferFromDai(dai,accounts[1],accounts[1],accounts[2],1);
    //ApproveDai(dai,accounts[1],accounts[3].address,1);
    //TransferFromDai(dai,accounts[3],accounts[1],accounts[2],1);
    //TransferFromDai(dai,accounts[3],accounts[1],accounts[2],1);

    /*
    console.log('-----------LotteryShop Deployment-----------------');
    const LotteryShop = await ethers.getContractFactory("LotteryShop");
    const lotteryShop = await LotteryShop.deploy(jsonData.Dai);
    await lotteryShop.deployed();
    console.log('LotteryShop Contract Address: ' + lotteryShop.address);

    console.log('-----------LotteryShop Get Dai Reserv-----------------');
    console.log('dai reserv: ' + await lotteryShop.getDaiReserve());*/    
  });
});
