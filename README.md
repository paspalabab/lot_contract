# lot_contract
A number puzzle lottery game,settled by Dai ERC20 token

在Hardhat平台实现，工程包含solidity合约和测试部署用js脚本。
The project implementation based on hardhat platform， include 
1) main solidity contract Lot.solidity;
2) accompanying contract such as Dai\Ownable\context;
3) test and deployment js; 

用solidity语言实现一个彩票系统的智能合约，使MetaMask钱包部署到Ropsten测试测试网，至少需
包含如下功能：
1. 增加了奖金累计功能，上一轮未产生中奖，奖金累计到新一轮;
2. 具备管理员和参与者两种身份，管理员发起彩票活动，并设置彩票开奖时间，参与者在彩票发起⾄
彩票开奖间可参与购买彩票；
3. 每个参与者每次投资5DAI（实际代码实现可设置）购买一注彩票，一个参与者可购买多注彩票；
4. 彩票中奖数字由4位0-9之间的数字构成(实际支持难度可设置，支持数字由0~N之间的数字组成，且N可设置)，中奖数字随机⽣成，中奖者按购买对应数字的注数平分彩
票池，平台收取20%（实际实现可设置）的⼿续费；
5. 管理员可多次发起彩票活动，但是同一时间仅支持一个彩票活动存在；
6. 需提供接⼝查询往期彩票的中奖数字和中奖者；

Implement a smart contract for a lottery system in solidity language, so that the MetaMask wallet is deployed to the Ropsten test network, at least
Contains the following functions:
1. With two identities as administrator and participant, the administrator initiates the lottery activity and sets the lottery draw time, and the participant can participate in the purchase of lottery tickets;
2. Each participant invests 5DAI（configurable） to buy one lottery ticket, and one participant can buy multiple lottery tickets;
3. The lottery winning numbers are composed of numbers between 0-9999（configurable）, the winning numbers are randomly generated, and the winners will divide the lottery equally according to the bet number of the corresponding numbers in Ticket pool, the platform charges a 20%（configurable） handling fee;
4. The administrator can initiate a lottery activity multiple times, but only one lottery activity is supported at the same time;
5. It is necessary to provide an interface to query the winning numbers and winners of previous lottery tickets;


Basic Test Procedure:
1) compiling: npx hardhat compile
2) start a node service : npx hardhat node
3) <img width="484" alt="image" src="https://user-images.githubusercontent.com/93688560/159164726-199a4ecb-476f-4876-947d-acdde9f87ff4.png">

4) Deploy npx hardhat run path/deploydai.js --network localhost  npx hardhat run path/deploylot.js  --network localhost
    -----------Dai Deployment-----------------
Dai ERC20 Contract Address: 0x5FbDB2315678afecb367f032d93F642f64180aa3
path: /home/devin/sambashare/LotteryGame/scripts/../test/DaiAddress.json

-----------LotteryShop Deployment-----------------
Lot Contract Address: 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
path: /home/devin/sambashare/LotteryGame/scripts/../test/LotAddress.json

5) mint dai

<img width="619" alt="image" src="https://user-images.githubusercontent.com/93688560/159164887-6dcbf48a-c857-44f6-a9bd-8ac05582c99a.png">

6) approve the allowance to the lot address to faciliate  later test
 <img width="635" alt="image" src="https://user-images.githubusercontent.com/93688560/159165016-8b466443-840c-4f5d-a6c0-6e8197db0a30.png">

7)luanch a new round of gambling

<img width="665" alt="image" src="https://user-images.githubusercontent.com/93688560/159165186-4ae159cf-1c41-469e-a041-f56431a25083.png">

8) stake
<img width="636" alt="image" src="https://user-images.githubusercontent.com/93688560/159165297-aff73372-c613-4a57-aa1c-5f82035ece95.png">

9) note accounting check
<img width="635" alt="image" src="https://user-images.githubusercontent.com/93688560/159165499-1068b590-cb70-4073-9532-f4e53cf04f05.png">
<img width="506" alt="image" src="https://user-images.githubusercontent.com/93688560/159165525-fe0eac6b-3679-4fd6-963f-d015eb66637d.png">

note that I purposedly to lower the difficulty to 1, too easy too guess. but a good choice for test

10) end this round of gambling and check the winner. the first two player very luck
<img width="641" alt="image" src="https://user-images.githubusercontent.com/93688560/159165617-60a7b4a7-378d-42c7-9d52-2a868e902506.png">
<img width="476" alt="image" src="https://user-images.githubusercontent.com/93688560/159165699-96849aa7-8160-4b85-bac5-5f5be07bacec.png">

11) luanch a second round and stake more
 <img width="413" alt="image" src="https://user-images.githubusercontent.com/93688560/159165772-49ab9ef3-8950-46ce-ac69-fcce8e127e43.png">
 <img width="479" alt="image" src="https://user-images.githubusercontent.com/93688560/159165794-0a80569b-7e2d-49ae-b8a7-2ae38384ece6.png">
 <img width="494" alt="image" src="https://user-images.githubusercontent.com/93688560/159165818-53316f7c-d311-4db4-887e-532df40cfc0f.png">
 
 12)end the second round, but too early before the expiration,so the game keep on.owner have no right to end the game in advance!
 <img width="484" alt="image" src="https://user-images.githubusercontent.com/93688560/159165893-2bf0b4c4-3465-48d5-8c1f-c0eea961ce56.png">
 
 13）end at last and see,first round, 1st and 2nd player winned. second round, 3rd and 4th player winned.bunus number is 1 in round 1, and 0 in round 2.
 
 <img width="443" alt="image" src="https://user-images.githubusercontent.com/93688560/159165963-9cd19f0d-7b16-4cfc-96f7-cfe1bf8293b2.png">
 <img width="485" alt="image" src="https://user-images.githubusercontent.com/93688560/159166011-1c7978ee-a110-4686-bea1-95ee398af57e.png">
 <img width="496" alt="image" src="https://user-images.githubusercontent.com/93688560/159166019-ea5766dd-098a-455f-ae4e-01205fe1d60c.png">
 
 14)the 2 winners collect the fund
 
   <img width="404" alt="image" src="https://user-images.githubusercontent.com/93688560/159166213-5fc8d7d1-21c0-4a81-a6fd-6e985d03cabb.png">
   <img width="505" alt="image" src="https://user-images.githubusercontent.com/93688560/159166246-56907649-c6ab-4dd1-aea4-dc8802eb7816.png">
   <img width="488" alt="image" src="https://user-images.githubusercontent.com/93688560/159166263-ed98bd3a-a1fe-46d5-b2bb-88640c7b5d03.png">
   
 15)the owner or runner refund part of commissions,that is 100 Dai,see
 
  <img width="539" alt="image" src="https://user-images.githubusercontent.com/93688560/159166360-25227963-c3cf-4ce2-a9c9-d04232d203eb.png">
  
 16) if no one win this round,the bonus will shift to next round automatically.
 
   ![截图](https://user-images.githubusercontent.com/93688560/159195031-72da7eb1-8ea4-4c2b-9b20-79fe67ca2982.png)

   ![截图](https://user-images.githubusercontent.com/93688560/159195062-932272d9-cff6-4c26-a3d1-d77d17fd8136.png)

