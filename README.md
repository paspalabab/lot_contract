# lot_contract
A number puzzle lottery game,settled by Dai ERC20 token

在Hardhat平台实现，工程包含solidity合约和测试部署用js脚本。
The project implementation based on hardhat platform， include 
1) main solidity contract Lot.solidity;
2) accompanying contract such as Dai\Ownable\context;
3) test and deployment js; 

用solidity语言实现一个彩票系统的智能合约，使MetaMask钱包部署到Ropsten测试测试网，至少需
包含如下功能：
1. 具备管理员和参与者两种身份，管理员发起彩票活动，并设置彩票开奖时间，参与者在彩票发起⾄
彩票开奖间可参与购买彩票；
2. 每个参与者每次投资5DAI（实际代码实现可设置）购买一注彩票，一个参与者可购买多注彩票；
3. 彩票中奖数字由4位0-9之间的数字构成(实际支持难度可设置，支持数字由0~N之间的数字组成，且N可设置)，中奖数字随机⽣成，中奖者按购买对应数字的注数平分彩
票池，平台收取20%（实际实现可设置）的⼿续费；
4. 管理员可多次发起彩票活动，但是同一时间仅支持一个彩票活动存在；
5. 需提供接⼝查询往期彩票的中奖数字和中奖者；

Implement a smart contract for a lottery system in solidity language, so that the MetaMask wallet is deployed to the Ropsten test network, at least
Contains the following functions:
1. With two identities as administrator and participant, the administrator initiates the lottery activity and sets the lottery draw time, and the participant can participate in the purchase of lottery tickets;
2. Each participant invests 5DAI（configurable） to buy one lottery ticket, and one participant can buy multiple lottery tickets;
3. The lottery winning numbers are composed of numbers between 0-9999（configurable）, the winning numbers are randomly generated, and the winners will divide the lottery equally according to the bet number of the corresponding numbers in Ticket pool, the platform charges a 20%（configurable） handling fee;
4. The administrator can initiate a lottery activity multiple times, but only one lottery activity is supported at the same time;
5. It is necessary to provide an interface to query the winning numbers and winners of previous lottery tickets;
