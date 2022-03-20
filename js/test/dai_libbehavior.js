const { expect } = require("chai");
const { deployMockContract } = require("ethereum-waffle");
const { ethers } = require("hardhat");


function MintDai (dai, accounts,sharetheward,shareA,shareB,shareC,shareD) {
    describe("Dai Minting", function () {
        it("Minting", async function () {
           
          //mint
          let mintTx = await dai.mint(accounts[1].address,shareA);
          await mintTx.wait(); // wait until the transaction is mined
          mintTx = await dai.mint(accounts[2].address,shareB);
          await mintTx.wait();
          mintTx = await dai.mint(accounts[3].address,shareC);
          await mintTx.wait();
          mintTx = await dai.mint(accounts[4].address,shareD);
          await mintTx.wait();
          mintTx = await dai.mint(accounts[0].address,sharetheward);
          await mintTx.wait();

          console.log('-------------------Mint Test----------------------------');
          console.log('balanceOftheWard: ', await dai.balanceOf(accounts[0].address));
          console.log('balanceOfclient1: ', await dai.balanceOf(accounts[1].address));
          console.log('balanceOfclient2: ', await dai.balanceOf(accounts[2].address));
          console.log('balanceOfclient3: ', await dai.balanceOf(accounts[3].address));
          console.log('balanceOfclient4: ', await dai.balanceOf(accounts[4].address));
          console.log('totalsupply',await dai.totalSupply());  
          
        });
    });
}


function PushDaiExample (dai, accounts) {
    describe("Dai Push", function () {
        it("Pushing", async function () {
 
            TradeTx = await dai.push(accounts[1].address,100);
            await TradeTx.wait(); // wait until the transaction is mined
            
            console.log('-------------------Push Test----------------------------');
            console.log('balanceOftheWard: ', await dai.balanceOf(accounts[0].address));
            console.log('balanceOfclient1: ', await dai.balanceOf(accounts[1].address));
            console.log('balanceOfclient2: ', await dai.balanceOf(accounts[2].address));
            console.log('balanceOfclient3: ', await dai.balanceOf(accounts[3].address));
            console.log('balanceOfclient4: ', await dai.balanceOf(accounts[4].address));
            console.log('totalsupply',await dai.totalSupply());
          
        });
    });
}

function ApproveDai (dai, approver, to ,amount) {
    describe("Dai Approve", function () {
        it("Approving", async function () {
            
            const sender = await dai.connect(approver).cunrentsender();
            console.log('currentsender: 0x..' + sender);
            
            //before transfering       
            console.log('0x..' + approver.address.slice(38) + ' approve ' + amount + ' tokens to 0x..' + to.slice(38));
            console.log('before approving');
            console.log('balance of approver 0x..' + approver.address.slice(38) + ' is ' + await dai.balanceOf(approver.address));
            console.log('balance of approvee 0x..' + to.slice(38) + ' is ' + await dai.balanceOf(to));           
            
            //approving
            const TradeTx = await dai.connect(approver).approve(to, amount);
            TradeTx.wait(); // wait until the transaction is mined
            console.log('allowance from 0x..' + approver.address.slice(38) + 'to 0x..' 
                        + to.slice(38) + ' is ' + await dai.allowance(approver.address,to) + ' tokens'); 
            //transfered
            console.log('approved');
            console.log('balance of approver 0x..' + approver.address.slice(38) + ' is ' + await dai.balanceOf(approver.address));
            console.log('balance of approvee 0x..' + to.slice(38) + ' is ' + await dai.balanceOf(to));    
            
        });
    });
}

function TransferFromDai (dai, sender, from, to ,amount) {
    describe("Dai Transfer", function () {
        it("Transfering", async function () {
            
            console.log('-------------------Transfer Test----------------------------');
            console.log('currentsender: ' + await dai.connect(from).cunrentsender());
            
            //before transfering       
            console.log('0x..' + sender.address.slice(38) + ' sending ' + amount + ' tokens from 0x..' + from.address.slice(38) +  ' to 0x..' + to.address.slice(38));
            console.log('before sending');
            console.log('balance of sender 0x..' + sender.address.slice(38) + ' is ' + await dai.balanceOf(sender.address));
            console.log('balance of approver 0x..' + from.address.slice(38) + ' is ' + await dai.balanceOf(from.address));
            console.log('balance of reciever 0x..' + to.address.slice(38) + ' is ' + await dai.balanceOf(to.address));           
            
            //tranfering
            const TradeTx = await dai.connect(sender).transferFrom(from.address, to.address, amount);
            TradeTx.wait(); // wait until the transaction is mined

            //transfered
            console.log('sended');
            console.log('balance of sender 0x..' + sender.address.slice(38) + ' is ' + await dai.balanceOf(sender.address));
            console.log('balance of approver 0x..' + from.address.slice(38) + ' is ' + await dai.balanceOf(from.address));
            console.log('balance of reciever 0x..' + to.address.slice(38) + ' is ' + await dai.balanceOf(to.address));           
            
        });
    });
}


function dai_accounting (dai, accounts) {
    describe("Dai accounting", function () {
        it("accounting", async function () {

            const Lotjson= require('./LotAddress.json'); 
            const LotArtifact= require('../artifacts/contracts/Lot.sol/Lot.json'); 
            console.log("Address of Lot Deployed: " + Lotjson.Lot);        
            console.log("Address of Dai Deployed: " + dai.address);   
         
            console.log('-------------------Push Test----------------------------');
            console.log('totalsupply',await dai.totalSupply());    
            console.log('balance Of LotContract: ', await dai.balanceOf(Lotjson.Lot));
            console.log('balance Of Admin: ', await dai.balanceOf(accounts[0].address));
            console.log('balance Of client1: ', await dai.balanceOf(accounts[1].address));
            console.log('balance Of client2: ', await dai.balanceOf(accounts[2].address));
            console.log('balance Of client3: ', await dai.balanceOf(accounts[3].address));
            console.log('balance Of client4: ', await dai.balanceOf(accounts[4].address));
            console.log('allowance of contract by client1: ', await dai.allowance(accounts[1].address, Lotjson.Lot));
            console.log('allowance of contract by client2: ', await dai.allowance(accounts[2].address, Lotjson.Lot));
            console.log('allowance of contract by client3: ', await dai.allowance(accounts[3].address, Lotjson.Lot));
            console.log('allowance of contract by client4: ', await dai.allowance(accounts[4].address, Lotjson.Lot)); 
        });
    });
}

module.exports = {
    MintDai,
    PushDaiExample,
    ApproveDai,
    TransferFromDai,
    dai_accounting,
}
