pragma solidity 0.8.15;

contract DeedMulti {
    address public lawyer;
    address  payable public beneficiary;
    uint  public deploymentTime;
    uint constant payouts =4;                           // I declare the number of payouts. I declare as constant to provide less strain on the code execution and save gas.
    uint  amount ;                                       //  Ideclare the amounts to be paid at every payout. 
    uint constant interval = 1;                           //  I declare the interval between each payment. set at 1 second for testing purposes. 
    uint paidPayouts;                                   //  I declare it to track the number of completed payouts 
    
    
    
    modifier onlyLawyer {
        require(msg.sender == lawyer, " Only the lawyer can execute this fn().");
        _;
    }

    constructor ( address _address, address payable _beneficiary, uint time) payable   {      
        lawyer= _address;
        beneficiary = _beneficiary;
        deploymentTime = time +block.timestamp;
        amount = msg.value/payouts;                       // every payout will be of equal amounts. this is why I define the amount in the constructor and  make it equal to the amount of ether sent upon deployment, divided by the payouts number 
      
    }

    function withdraw () external  {
        require (msg.sender ==beneficiary, " Only the beneficiary can invoke this fn ()! ");
        require (paidPayouts<payouts, "Maximum number of  available payouts exceeded!");                   //check required for the beneficiary to not be able to exceed the maximum payouts                                         
        require( block.timestamp >= deploymentTime, "Funds are still locked");                         
        uint eligiblePayouts = (block.timestamp - deploymentTime)/interval ;                                //  I declare this variable in order to calculate how much  much payments the beneficiary is eligible for. the time difference between the fn invocation and the deployment time , divided by the payment interval
        uint duePayouts = eligiblePayouts - paidPayouts;                                                     // I  also declare duepayouts, which is different form eligible payouts. The former is  derived from subtracting the already paid payouts from the eligible payouts.
        duePayouts = duePayouts +paidPayouts >= payouts ? payouts-paidPayouts :duePayouts;                 // I use a ternary operator to check the duepayouts value and to prevent locking the funds forever in case the eligible payots exceed the payouts (4) due to forgeting to withdraw for a very long time. If duepayots and paidpayouts exceed 4, then duepayouts is equivelanet to 4- paidPayouts. Else, it is equal to itself.
        paidPayouts +=duePayouts;                                                                           

        beneficiary.transfer((duePayouts)*amount);
        
        

    }
 

     function suddenDeath () external onlyLawyer {                                             
     }









}