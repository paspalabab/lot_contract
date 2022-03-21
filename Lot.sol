//SPDX-License-Identifier: Unlicense
/**
 * Author:    Devin Nie (Nie Xudong)
 * Created:   21.03.2022
 **/

pragma solidity ^0.8.0;

import "./utilities/Ownable.sol";
import "./IERC20.sol";
import "hardhat/console.sol";

abstract contract LotNote is Ownable {
     
    //fund pool
    uint256 public lot_balance; 
    uint256 public bonus_pool;
    uint256 public commission_pool;

    //store total amount of stake on one number. 
    mapping(bytes32 => uint256) public total_of_stake;

    //store one client's amount of stake on one number.  
    mapping(bytes32 => uint256) public amount_of_stake;

    //store the status if the expected bonus collected.
    mapping(bytes32 => bool) public if_bonus_collected;

    //Reward Record of one game round
    struct TGameRoundRec{
        uint256 total_bonus;  //total bonus generated
        uint256 total_bonus_collected_bywinners; //amount of bonus collected 
        uint256 expiration;  //deadline of the current round of game
        bool IfNowInGame;    //if the current game still valid to join in
        uint16 difficulty;  //1~65535, adjust based on the trade volume, market response, sales promotion policies or other reasons
        uint16 bonusNumber;  //the luck number revealed last 
        uint56 StakePrice;   //designated by admin or owner, based on opt policies as difficulty
        uint80 ratio_commission_numerator;     //ratio devision of commision .designated by admin or owner, based on opt policies as difficulty
        uint80 ratio_commission_denominator;   //ratio devision of commision.designated by admin or owner, based on opt policies as difficulty
    }
    TGameRoundRec[] public gameRoundlist;

    //get the index of latest game round 
    function GameRound() public view returns(uint256){
        return gameRoundlist.length;
    }
 
    //check if the latest round of game still joinable now
    function IfNowInGame() public view returns(bool){
        uint256 _round = GameRound();
        if(_round == 0){ return false; }
        return gameRoundlist[_round-1].IfNowInGame;
    }     

    //check the stake price of the latest round of game
    function StakePrice() public view returns(uint256){
        uint256 _round = GameRound();
        return uint256(gameRoundlist[_round-1].StakePrice);
    } 

    //check the difficulty of the latest round of game
    function checkDifficulty() public view returns(uint16){
        uint256 _round = GameRound();
        return gameRoundlist[_round-1].difficulty;
    }       

    //create a new round game
    function createNextRound(
        uint16 para_difficulty,
        uint256 para_expiration,
        uint56 para_StakePrice,  
        uint80 para_ratio_commission_numerator,
        uint80 para_ratio_commission_denominator  
    ) internal{
        uint256 _round_prev = GameRound();
        TGameRoundRec memory _game_round_rec = TGameRoundRec(0,0,para_expiration,true
                                                ,para_difficulty,0xffff,para_StakePrice,
                                                para_ratio_commission_numerator
                                                ,para_ratio_commission_denominator);
        gameRoundlist.push(_game_round_rec);
        assert(IfNowInGame() == true);
        assert(GameRound() == _round_prev+1);
        if(_round_prev == 0) return;

        //accumulate all unwinned bonus to this round
        if(getTotalStakeAmount(_round_prev, CheckBonusNumber(_round_prev)) == 0 ){ 
            //have no stake on the bingo number
            gameRoundlist[_round_prev].total_bonus = gameRoundlist[_round_prev-1].total_bonus;
            gameRoundlist[_round_prev-1].total_bonus = 0;
        }
    }

    //psudo-random num generator
    //put off the prediction of puzzle answer to the last minute 
    function rand() internal view returns(uint16)
    {
        uint256 seed = uint256(keccak256(abi.encodePacked(
            block.timestamp + block.difficulty +
            ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (block.timestamp)) +
            block.gaslimit + 
            ((uint256(keccak256(abi.encodePacked(_msgSender())))) / (block.timestamp)) +
            block.number
        )));
        uint16 _difficulty = checkDifficulty();
        assert(_difficulty > 0);
        return uint16(seed - ((seed / _difficulty) * _difficulty));
    }

    //Seal and solidify the outcome of the current running game round
    //owners or clients all have opptunity to trig the seal operation
    function trySealCurRound() internal {
        if(IfNowInGame() == false) {return;} 
        uint256 _round = GameRound();
        if(gameRoundlist[_round-1].expiration > block.timestamp){return;}

        gameRoundlist[_round-1].bonusNumber = rand();//rand bonus number
        assert(gameRoundlist[_round-1].bonusNumber<checkDifficulty()); //bonus number range
        gameRoundlist[_round-1].IfNowInGame = false; //end the game
    }

    //hash pointer to total stake
    function total_stake_hash(
        uint256 para_round,
        uint16 para_number
    ) 
    internal pure
    returns(bytes32){
        return keccak256(abi.encode(para_round,para_number));
    }

    //incre the total stake 
    function increTotalStake(
        uint256 para_round,
        uint16 para_number,
        uint256 para_amount) 
    internal{
        total_of_stake[total_stake_hash(para_round, para_number)] += para_amount;
    }

    //check the total stake
    function getTotalStakeAmount(
        uint256 para_round,
        uint16 para_number 
        )  
    internal view returns(uint256 amount){
        return total_of_stake[total_stake_hash(para_round, para_number)];
    }

    //hash pointer to a stake by one player
    function stake_hash(
        address para_player,
        uint256 para_round,
        uint16 para_number 
        ) 
    internal pure
    returns(bytes32){
        return keccak256(abi.encode(para_player, para_round, para_number));
    }

    //increment the stake
    function increStake(
        uint256 para_round,
        uint16 para_number, 
        uint256 para_amount
        ) 
    internal {
        amount_of_stake[stake_hash(_msgSender(), para_round, para_number)] += para_amount;
    }  

    //check the stake
    function getStakeAmount(
        uint256 para_round,
        uint16 para_number 
        )  
    internal view returns(uint256 amount){
        return amount_of_stake[stake_hash(_msgSender(),para_round, para_number)];
    }

    //mark if the bonus collected
    function markIfCollected(
        uint256 para_round,
        uint16 para_number, 
        bool para_if_collected
        ) 
    internal {
        if_bonus_collected[stake_hash(_msgSender(), para_round, para_number)] = para_if_collected;
    }  

    //check if the bonus collected
    function checkIfCollected(
        uint256 para_round,
        uint16 para_number 
        )  
    internal view returns(bool){
        return if_bonus_collected[stake_hash(_msgSender(),para_round, para_number)];
    }

    //do note-working on occurence of new income
    function noteIncome(
        uint256 para_dai_recieved, 
        uint16 para_number) 
    internal{
        // total fund pool
        lot_balance += para_dai_recieved; 
        uint256 _round = GameRound();
        uint256 _commission = para_dai_recieved * gameRoundlist[_round-1].ratio_commission_numerator /
                             gameRoundlist[_round-1].ratio_commission_denominator;
        commission_pool += _commission;
        uint256 _bonusIncre = para_dai_recieved - _commission;
        bonus_pool += _bonusIncre;
        assert(commission_pool + bonus_pool == lot_balance);

        //bonus accumulated
        gameRoundlist[_round-1].total_bonus += _bonusIncre;

        //increase stake for a player
        increStake(_round, para_number, para_dai_recieved);
        //mark the prospective bonus not collect yet
        markIfCollected(_round, para_number, false);
        //increase total stake
        increTotalStake(_round, para_number, para_dai_recieved);

    }

    function CheckBonusNumber(uint256 para_round) public view returns(uint16 ret_bonus_number){
        if(para_round ==0 || para_round > GameRound()){
           ret_bonus_number = 0xffff;
        }
        ret_bonus_number = gameRoundlist[para_round-1].bonusNumber;
    }

    function CheckBonusTotal(uint256 para_round) public view returns(uint256){
        if(para_round ==0 || para_round > GameRound()){
           return 0;
        }
        return gameRoundlist[para_round-1].total_bonus;
    }    

   //do commission refunding note
    function noteCommissionRefund(
        uint256 para_refund_amount
    ) 
    internal{
        // total fund pool
        lot_balance -= para_refund_amount; 
        commission_pool -= para_refund_amount;
        assert(commission_pool + bonus_pool == lot_balance);
    }

   //do bonus refunding note，take all one time or nothing
    function noteBonusRefund(
        uint256 para_round,
        uint256 para_refund_amount
    ) 
    internal{
        assert(para_round >0 && para_round<= GameRound());
       
        // total fund pool
        lot_balance -= para_refund_amount; 
        bonus_pool -= para_refund_amount;
        assert(commission_pool + bonus_pool == lot_balance);

        //bonus accumulated
        gameRoundlist[para_round-1].total_bonus_collected_bywinners += para_refund_amount;

        //mark the prospective bonus fully collected yet
        markIfCollected(para_round, CheckBonusNumber(para_round), true);

    }    

    function Test_view(uint256 para_round) public view {

        console.log("This Lottery Shop Being Runned By ", owner());
        console.log("game round: ", para_round);
        console.log("in game now: ", gameRoundlist[para_round-1].IfNowInGame);
        console.log("now: ", block.timestamp);
        console.log("total_bonus: ", gameRoundlist[para_round-1].total_bonus);
        console.log("total_bonus_collected_bywinners: ", gameRoundlist[para_round-1].total_bonus_collected_bywinners);
        console.log("expiration: ", gameRoundlist[para_round-1].expiration);
        console.log("difficulty: ", gameRoundlist[para_round-1].difficulty);
        console.log("StakePrice: ", gameRoundlist[para_round-1].StakePrice);
        console.log("ratio commission numerator: ", gameRoundlist[para_round-1].ratio_commission_numerator);
        console.log("ratio commission denominator: ", gameRoundlist[para_round-1].ratio_commission_denominator);
        console.log("bonusNumber: ", gameRoundlist[para_round-1].bonusNumber);
        console.log("total bonus: ", gameRoundlist[para_round-1].total_bonus);
        console.log("lot balance: ", lot_balance);
        console.log("total bonus pool: ", bonus_pool);
        console.log("total commission pool: ", commission_pool);
    }
    
}

contract Lot is LotNote {

    // Deployed Address of Dai ERC20 Token   
    address public immutable address_Of_the_Dai;

    // Event
    event launch(uint256 indexed para_round,     
                uint256  para_beginning,
                uint256 para_expiration, 
                uint16 para_difficulty,
                uint56 para_StakePrice, 
                uint80 para_ratio_commission_numerator, 
                uint80 para_ratio_commission_denominator);
    event stake(uint256 indexed para_round,  
                address indexed player,
                uint16 number,
                uint256 chips,
                uint256 _dai_needed);
    event bonuscollected(address indexed beneficiary, uint256 indexed para_round);
    event commissionrefund(address indexed beneficiary, uint256 indexed para_amount);

    constructor(address address_Of_the_Dai_) {
        address_Of_the_Dai = address_Of_the_Dai_;
    }

    //only operated by owner
    function Launch(
        uint16 para_difficulty,
        uint256 para_gamePeriod, 
        uint56 para_StakePrice, 
        uint80 para_ratio_commission_numerator, 
        uint80 para_ratio_commission_denominator) external onlyOwner 
    returns(bool) {

        //can not launch multi-rounds in the same time
        if(IfNowInGame() == true){
            return false; 
        }

        //para validation
        require(para_gamePeriod>0, "zero game period");
        require(para_StakePrice>0, "zero stake price");
        require(para_ratio_commission_denominator>0, "zero denominator");
        require(uint256(para_StakePrice) * uint256(para_ratio_commission_numerator) % uint256(para_ratio_commission_denominator) == 0, 
                "not divisible");

        //Create new rec of next game round
        createNextRound(para_difficulty,block.timestamp+para_gamePeriod,para_StakePrice,
                        para_ratio_commission_numerator,para_ratio_commission_denominator);

        emit launch(GameRound(),
                    block.timestamp,
                    block.timestamp+para_gamePeriod,
                    para_difficulty,
                    para_StakePrice,
                    para_ratio_commission_numerator,para_ratio_commission_denominator);

        return true;
    }

    function End() external {
        //no game being played now
        if (IfNowInGame() == false){
            return; 
        }

        //seal the final outcome of the gambling
        trySealCurRound();
    }

    function Stake(uint16 para_number, uint256 para_chips) external returns(bool) {   
        //no game being played now
        if (IfNowInGame() == false){
            return false; 
        }
        
        //validate the bid num
        require(para_number < checkDifficulty(), "beyond the range.");

        //check the client's finance condition
        uint256 _dai_needed = para_chips * StakePrice();
        //console.log("balance:  ", IERC20(address_Of_the_Dai).balanceOf(_msgSender()));
        //console.log("allowance approver:  ", _msgSender());//test
        //console.log("allowance spender:  ", address(this));//test
        //console.log("allowance:  ", IERC20(address_Of_the_Dai).allowance(_msgSender(),address(this)));
        require((IERC20(address_Of_the_Dai).balanceOf(_msgSender())) >= _dai_needed,"insufficient balance to stake");
        require((IERC20(address_Of_the_Dai).allowance(_msgSender(),address(this))) >= _dai_needed,"insufficient allownce to stake");

        //deduct Dai from client's account first
        bool _deduction_succeed = IERC20(address_Of_the_Dai).transferFrom(_msgSender(), address(this), _dai_needed);
        if(!_deduction_succeed){
            return false;
        }
    
        //note
        noteIncome(_dai_needed, para_number);
        assert( IERC20(address_Of_the_Dai).balanceOf(address(this)) == lot_balance);
        emit stake(GameRound(),_msgSender(),para_number,para_chips,_dai_needed);
                            
        //add more uncertainty, for the msg.sender who finishe this round can only be know at the last moment
        trySealCurRound();

        return true;
    }

    function Bingo(uint256 para_round) public view 
    returns(
        bool ret_if_bingo, 
        uint256 ret_bonus_amount,
        bool ret_if_bonus_collected
    ){
        require(para_round <= GameRound() && para_round > 0, "no such game round");
        
        //bonus number puzzle not solved yet
        uint16 _bonus_number = CheckBonusNumber(para_round);
        if (_bonus_number == 0xffff){ return(false,0,false);}
      
        //have no stake on the bingo number
        uint256 _stake_amount = getStakeAmount(para_round, _bonus_number);
        if(_stake_amount == 0){ return(false,0,false);}

        //caculate the bonus and return
        ret_if_bingo = true;
        ret_if_bonus_collected = checkIfCollected(para_round, _bonus_number);
        ret_bonus_amount = CheckBonusTotal(para_round) * _stake_amount / 
                            getTotalStakeAmount(para_round, _bonus_number);
        
    }

    function CollectBonus( uint256 para_round ) external returns(bool){
        require(para_round <= GameRound(), "The round unhappened");
        bool _if_bingo; 
        uint256 _bonus_amount;
        bool _if_bonus_collected;

        (_if_bingo, _bonus_amount, _if_bonus_collected) = Bingo(para_round);
        if(!_if_bingo || _bonus_amount == 0 || _if_bonus_collected){return false;}

        //deduct Dai from client's account first,take all by one time or nothing
        bool _refund_succeed = IERC20(address_Of_the_Dai).transfer(_msgSender(), _bonus_amount);
        if(!_refund_succeed){
            return false; 
        }
        noteBonusRefund(para_round,_bonus_amount); 
        assert( IERC20(address_Of_the_Dai).balanceOf(address(this)) == lot_balance );

        emit bonuscollected(_msgSender(),para_round);
        return true;
    }

    //only be operated by runner
    function RefundCommission(
        address para_reciever, 
        uint256 para_refund_amount) 
    public onlyOwner returns(bool){
        require(para_refund_amount <= commission_pool, "Surpass the commission cap. Bad Runner!!!");
        bool _refund_succeed = IERC20(address_Of_the_Dai).transfer(para_reciever, para_refund_amount);
        if(!_refund_succeed){
            return false;
        }

        noteCommissionRefund(para_refund_amount);
        emit commissionrefund(para_reciever, para_refund_amount);
        return true;
    }

}
