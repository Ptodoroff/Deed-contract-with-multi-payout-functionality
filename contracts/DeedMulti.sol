pragma solidity 0.8.15;

contract Deed {
    address public lawyer;
    address  payable public beneficiary;
    uint  public donation_date;
    uint constant payouts =10;                           // I declare the number of payouts. I declare as constant to provide less strain on the code execution and save gas.
    uint  amount ;                                       //  Ideclare the amounts to be paid at every payout. 
    uint constant interval = 5;                           //  I declare the interval between each payment. set at 10 seconds for testing purposes. 
    uint paidPayouts;                                   //  I declare it to track the number of completed payouts 
    
    
    
    modifier onlyLawyer {
        require(msg.sender == lawyer, " Only the lawyer can execute this fn().");
        _;
    }

    constructor ( address _address, address payable _beneficiary, uint date, uint _amount) payable   {      
        lawyer= _address;
        beneficiary = _beneficiary;
        donation_date = date +block.timestamp;
        amount = msg.value/_amount;                       // every payout will be of equal amounts. this is why I define the amount in the constructor and  make it equal to the amount of ether sent upon deployment, divided by the payouts number 

    }

    function send_funds () external onlyLawyer {                                                            
        require( block.timestamp >= donation_date, "Funds are still locked");
        beneficiary.transfer(address(this).balance);

    }
 

     function suddenDeath () external onlyLawyer {                                             
     }









}