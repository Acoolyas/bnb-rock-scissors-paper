// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CoinFlipper{

    //modifier onlyOwner
    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }

    //Owner's address
    address owner; 

    //event to track result of Coin Flip
    event CoinFlipped(address player, uint256 amount, uint256 option, uint256 sign); 

    //payable = user может заплатить в BNB (главная монета в блокчейне)
    //in Constructor we assign owner's address;
    constructor() payable {
        owner = msg.sender;
    }

    //function that asks for 0 or 1 and returns if you win or lose
    function coinFlip(uint256 _option) public payable returns (bool){ //view, pure = gassless 
        require(_option<3, "Please select sign");
        require(msg.value>0, "Please add your bet"); //WEI smallest unit ETH 
        //1,000,000,000,000,000,000 WEI = 1 ETH 
        require(msg.value*2 <= address(this).balance, "Contract balance is insuffieient ");
        //rock = 0
        //scissors = 1
        //paper = 2
        //PseudoRandom and check with _option 
        uint256 sign = block.timestamp*block.gaslimit%3; //компьютер выбрал жест
        //TODO add oracle: https://docs.chain.link/vrf/v2/introduction


        //Emiting event of Coin Flip
        emit CoinFlipped(msg.sender, msg.value, _option, sign);


        //If user wins he doubles his stake
        if (sign != _option){
            if (sign == 0){
                if (_option == 1){
                    return false;
                }
                if (_option == 2){
                    payable(msg.sender).transfer(msg.value*2);
                    return true;
                }
            }
            if (sign == 1){
                if (_option == 2){
                    return false;
                }
                if (_option == 0){
                    payable(msg.sender).transfer(msg.value*2);
                    return true;
                }
            }
            if (sign == 2){
                if (_option == 0){
                    return false;
                }
                if (_option == 1){
                    payable(msg.sender).transfer(msg.value*2);
                    return true;
                }
            }
        }
        else {
            payable(msg.sender).transfer(msg.value);
            return false;
        }
        
        
    }



    //Owner can withdraw BNB amount
    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    fallback() external payable{

    }

    receive() external payable{
        
    }
}