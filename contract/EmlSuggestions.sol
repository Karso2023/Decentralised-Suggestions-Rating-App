// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EmlExam {
    struct Suggestion {
        string text;
        address creator;
        bool isDeleted;
    }

    mapping(uint256 => Suggestion) private suggestions;
    uint256 private count;

    mapping(address => uint256) public creatorBalances;

    uint256 private constant OK_SUGGESTION = 0.001 ether;
    uint256 private constant GOOD_SUGGESTION = 0.005 ether;
    uint256 private constant GREAT_SUGGESTION = 0.01 ether;

    mapping(uint8 => uint256) private qualityToReward;

    constructor() {
        qualityToReward[1] = OK_SUGGESTION;
        qualityToReward[2] = GOOD_SUGGESTION;
        qualityToReward[3] = GREAT_SUGGESTION;
    }

    event SuggestionAdded(uint256 indexed suggestionId, address indexed creator);
    event SuggestionRewarded(
        uint256 indexed suggestionId,
        uint8 rewardType,
        uint256 rewardAmount
    );
    event SuggestionDeleted(uint256 indexed suggestionId);
    event BalanceWithdrawn(address indexed creator, uint256 amount);

    function addSuggestion(string memory _suggestion) public {
        suggestions[count] = Suggestion(_suggestion, msg.sender, false);
        emit SuggestionAdded(count, msg.sender);
        count++;
    }

    function getSuggestions() public view returns (Suggestion[] memory) {
        Suggestion[] memory allSuggestions = new Suggestion[](count);
        uint256 counter = 0;
        for (uint256 i = 0; i < count; i++) {
            if (!suggestions[i].isDeleted) {
                allSuggestions[counter] = suggestions[i];
                counter++;
            }
        }
        if (counter == count) {
            return allSuggestions;
        } else {
            Suggestion[] memory filteredSuggestions = new Suggestion[](counter);
            for (uint256 j = 0; j < counter; j++) {
                filteredSuggestions[j] = allSuggestions[j];
            }
            return filteredSuggestions;
        }
    }

    function rewardSuggestion(uint256 suggestionId, uint8 _rewardType) public payable {
        require(suggestionId < count, "Invalid token");
        require(_rewardType >= 1 && _rewardType <= 3,
                "Reward type should be between 1 and 3"
        );
        require(!suggestions[suggestionId].isDeleted, "Suggestion is deleted");

        uint256 rewardAmount = qualityToReward[_rewardType];
        require(msg.value == rewardAmount, "Incorrect reward amount");

        creatorBalances[suggestions[suggestionId].creator] += rewardAmount;
        emit SuggestionRewarded(suggestionId, _rewardType, rewardAmount);
    }

    function deleteSuggestion(uint256 suggestionId) public {
        require(suggestionId < count, "Invalid token");
        require(suggestions[suggestionId].creator == msg.sender, 
                "Only the creator can delete this suggestion"
        );
        require(!suggestions[suggestionId].isDeleted, "Suggestion is already deleted");
        suggestions[suggestionId] = Suggestion("", address(0), true);

        emit SuggestionDeleted(suggestionId);
    }

    function withdrawBalance() public {
        uint256 balance = creatorBalances[msg.sender];
        require(balance > 0, "No balance to withdraw");
        creatorBalances[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: balance}("");
        require(success, "Failed to withdraw balance");

        emit BalanceWithdrawn(msg.sender, balance);
    }

    function getSuggestionRaw(uint256 id)
    public
    view
    returns (string memory, address, bool)
    {
        Suggestion memory s = suggestions[id];
        return (s.text, s.creator, s.isDeleted);
    }
}