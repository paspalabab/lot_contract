const { expect } = require("chai");
const { deployMockContract } = require("ethereum-waffle");
const { ethers } = require("hardhat");


function lot_accounting (round) {
    describe("lot accounting", function () {
        it("accounting", async function () {     
    
            //getsigners
            const accounts = await ethers.getSigners();
            const Lotjson= require('./LotAddress.json'); 
            const LotArtifact= require('../artifacts/contracts/Lot.sol/Lot.json'); 
            //console.log("Address of Lot Deployed: " + Lotjson.Lot);

            lot = new ethers.Contract(
                Lotjson.Lot,
                LotArtifact.abi,
                accounts[0]
            );
            //console.log("lot object address: " + lot.address);
            await lot.deployed();

            const _game_round = await lot.GameRound();
            console.log("game round: " + _game_round);
            for (let i = 1; i <= _game_round; i++) {
                await lot.Test_view(i);
                console.log(accounts[1] + " Bingo? "+await lot.connect(accounts[1]).Bingo(i));
                console.log(accounts[2] + " Bingo? "+await lot.connect(accounts[2]).Bingo(i));
                console.log(accounts[3] + " Bingo? "+await lot.connect(accounts[3]).Bingo(i));
                console.log(accounts[4] + " Bingo? "+await lot.connect(accounts[4]).Bingo(i));    
            }

            //await lot.connect(accounts[0]).RefundCommission(accounts[0].address,100);
            //await lot.connect(accounts[3]).CollectBonus(1);
            //await lot.connect(accounts[4]).CollectBonus(2);
            //await lot.connect(accounts[1]).CollectBonus(2);
            //await lot.connect(accounts[2]).CollectBonus(2);


        });
    });
}

module.exports = {
    lot_accounting,
}
