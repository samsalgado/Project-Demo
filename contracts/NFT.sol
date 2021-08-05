// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;
pragma experimental ABIEncoderV2;
import "./IERC721.sol";
import "./IERC721Receiver.sol";
import "./Receipt.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./LegalFramework.sol";
contract NFT is IERC721, Receipt {
    using SafeMath for uint256;
    //Name and ticker symbol subject to change, just for Demo
    string public override constant name = "Farm Bit Collateral Protocol";
    string public override constant symbol = "FBCP";
    bytes4 internal constant MAGIC_ERC721_RECEIVED = bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
        /**
     *  bytes4(keccak256('balanceOf(address)')) == 0x70a08231
     *  bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
     *  bytes4(keccak256('approve(address, uint256)')) == 0x095ea7b3
     *  bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
     *  bytes4(keccak256('setApprovalForAll(address, bool)')) == 0xa22cb465
     *  bytes4(keccak256('isApprovedForAll(address, address)')) == 0xe985e9c5
     *  bytes4(keccak256('transferFrom(address, address, uint256)')) == 0x23b872dd
     *  bytes4(keccak256('safeTransferFrom(address, address, uint256)')) == 0x42842e0e
     *  bytes4(keccak256('safeTransferFrom(address, address, uint256, bytes)')) == 0xb88d4fde
     *  
     *  => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
     *     0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
     */
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;

    /**
     *  bytes4(keccak256('supportsInterface(bytes4)'));
    */
    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
    struct Loan{
        uint256 id;
        string required_loan_duration;
        uint256 amount;
        string details_of_receipt;
    }
    Loan[] public Loans;
    mapping(address => uint256) public balances;
    mapping(address => uint256) public loanIncites;
    mapping(uint256 => address) public loanIdMapping;
    mapping(uint256 => address) public loanIndexToApproved;
    mapping(address => mapping(address => bool)) private _collateralManagerApproval;

    event ApplicationMade(
        uint256 newLoanId,
        string required_loan_duration,
        uint256 amount,
        string details_of_receipt
    );
    function loanApplication(
        uint256 _id,
        string memory _required_loan_duration,
        uint256 _amount,
        string  memory _details_of_receipt
    ) external returns (uint256) {
        Loan memory _loan = Loan({
            id:_id,
            required_loan_duration: string(_required_loan_duration),
            amount: uint256(_amount),
            details_of_receipt: string(_details_of_receipt)
        });
        Loans.push(_loan);
        uint256 newloanId = Loans.length-1;
        emit ApplicationMade(newloanId, _required_loan_duration, _amount, _details_of_receipt);
        return newloanId;
    }
    function getLoans(uint256 _id) external view returns(
        uint256 id,
        string memory required_loan_duration,
        uint256 amount,
        string memory details_of_receipt
    ) {
        return (
         Loans[_id].id,
         Loans[_id].required_loan_duration,
         Loans[_id].amount,
         Loans[_id].details_of_receipt   
        );
    }
    function totalSupply() external view override returns (uint256 total){
        return Loans.length;
    }
    function balanceOf(address owner) external view override returns (uint256 balance){
        return loanIncites[owner];
    }
    function ownerOf(uint256 tokenId) public view returns (address owner) {
        return loanIdMapping[tokenId];
    }
    function transfer(address to, uint256 tokenId) external override {
        require(address(to) != address(0));
        require(to != address(this));
        require(_owns(msg.sender, tokenId));
        _transfer(msg.sender,to,tokenId);
    }
    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        balances[_to]++;
        _to=loanIdMapping[_tokenId];
        if(_from != address(0)) {
            balances[_from]--;
            delete loanIndexToApproved[_tokenId];
        }
        emit Transfer(_from, _to, _tokenId);
    }
    function _owns(address _claimant, uint256 _tokenId) internal view returns(bool){
        return loanIdMapping[_tokenId] == _claimant;
    }
    function approve(address _approved, uint256 _tokenId) public override payable {
        require(_approved != address(0));
        require(_owns(msg.sender, _tokenId));
        _approve(_approved, _tokenId);
        emit Approval(loanIdMapping[_tokenId], _approved, _tokenId);
    }
    function setApprovalForAll(address operator, bool _approved) external override {
        require(operator != address(0));
        require(operator !=msg.sender);
        _setApprovalForAll(operator, _approved);
        emit ApprovalForAll(msg.sender, operator, _approved);

    }
    //Front End function in which Collateral Manager: approves, appraises, and documents asset
    function _setApprovalForAll(address _operator, bool _approved) internal{
        _collateralManagerApproval[msg.sender][_operator] = _approved;
    }
    //Assets must be in warehouse
    function getApproved(uint256 _tokenId) external view override returns (address){
        require(_tokenId < Loans.length);
        return loanIndexToApproved[_tokenId];
    }
    function isApprovedForAll(address _owner, address _operator) external override view returns (bool){
        return _collateralManagerApproval[_owner][_operator];
    }
    function _checkERC721Support(address _from, address _to, uint256 _tokenId, bytes memory _data) internal returns (bool) {
        if (!_isContract(_to)) {
            return true;
        }
        bytes4 returnData = IERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
        return returnData == MAGIC_ERC721_RECEIVED;
    }
    function _isContract(address _to) internal view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(_to)
        }
        return size > 0;
    }
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) public override payable {
        require(_isApprovedOrOwner(msg.sender, _from, _to, _tokenId));
        _safeTransfer(_from, _to, _tokenId, data);
    }
    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal {
        _transfer(from, to, tokenId);
        require(_checkERC721Support(from, to, tokenId, _data));
    }
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external override payable {
        safeTransferFrom(_from, _to, _tokenId, "");
    }
    function transferFrom(address _from, address _to, uint256 _tokenId) external override payable{
        require(_to != address(0));
        address owner = loanIdMapping[_tokenId];
        require(_to != owner);
        require(msg.sender == _from || approvedFor(msg.sender, _tokenId) || this.isApprovedForAll(owner, msg.sender));
        require(_owns(_from, _tokenId), "From is not token owner");
        require(_tokenId < Loans.length, "Token ID not VALID");
        _transfer(_from, _to, _tokenId);
    }
    function _approve(address _approved, uint256 _tokenId) private {
        loanIndexToApproved[_tokenId] = _approved;
    }
    function approvedFor(address claimant, uint256 tokenId) internal view returns(bool){
        return loanIndexToApproved[tokenId] == claimant;
    }

    function _isApprovedOrOwner(address spender, address _from, address _to, uint256 _tokenId) private view returns(bool) {
        require(_tokenId < Loans.length);
        require(_to != address(0));
        address owner = loanIdMapping[_tokenId];
        require(_to != owner);
        require(_owns(_from, _tokenId));
        //Error at approve(spender, _tokenId)
        return (spender == _from || approvedFor(spender, _tokenId) || this.isApprovedForAll(owner, spender) );
    }
   
    
    function mintNFT(uint256 receiptId, uint256 amount, uint collateral, address _owner, address _operator) external view returns(bool) {
        require(receiptId > 0);
        require(collateral > amount);
         return _collateralManagerApproval[_owner][_operator];
    }








    function calculateFee(uint amount) external pure returns(uint) {
        //100 basis points = 1 pct
        return (amount /10000).mul(100);
    }

}