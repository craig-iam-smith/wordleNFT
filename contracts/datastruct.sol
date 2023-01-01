// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/access/Ownable.sol";
//import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
/// @title Wordle on chain 

contract Wordle is Ownable {
//    using SafeERC20 for IERC20;

    event emitGame (address indexed player, uint8 guesses, bytes5 solution);

    struct gameStat {
        uint256 GameStartTime;
        uint256 elapsedTime;
        uint8 guesses;
        bytes5 solution;
    }
    gameStat[] public gameStats;

    mapping(address => gameStat[]) public GamesRecord;
    mapping(address => bool) public _whitelist;
    
    

/// @param  startTime - when game started
/// @param  elapsedTime - how long to complete game
/// @param  guesses - how many guesses did it take
/// @param  solution - word solution

    function logGame (uint256 startTime, uint256 elapsedTime, uint8 guesses, bytes5 solution) public {
        gameStat memory GS;

        GS.GameStartTime = startTime;
        GS.elapsedTime = elapsedTime;
        GS.guesses = guesses;
        GS.solution = solution;
      
        GamesRecord[msg.sender].push(GS);
    
    }

/// @notice getGamesCount - get number of games played for account 
/// @param account - address of account of interest

    function getGamesCount (address account) public view returns (uint256) {
        return GamesRecord[account].length;
    }

/// @notice getGames - returns array of Games stats for account
/// @param account - account in question
    function getGames (address account) public view returns (gameStat[] memory) {
        return (GamesRecord[account]);
    }

    constructor () {
      
    }


/// @dev implement whitelist TODO

    function whitelist (address account) public onlyOwner {
        _whitelist[account] = true;
    }
    function dewhitelist (address account) public onlyOwner {
        _whitelist[account] = false;
    }

    modifier whitelisted(address account) {
        require (_whitelist[account] == true);
        _;
    }

    receive() external payable {}

    fallback() external payable {}

}