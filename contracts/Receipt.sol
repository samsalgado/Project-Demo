// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Receipt is ReentrancyGuard {
struct Warehouse_Receipt{
    uint256 id;
    string shipper;
    string cosignee;
    string destination;
    uint64 unit_Weight;
    uint64 number_of_packages;
    uint64 total_weight;
    uint256 item_id;
    uint256 package_id;
    uint256 date;
}
Warehouse_Receipt[] private receipts;
event ReceiptIssued(
uint256 ReceiptId,
string shipper,
string cosignee,
string destination,
uint64 unit_Weight,
uint64 number_of_packages,
uint64 total_weight,
uint256 item_id,
uint256 package_id,
uint256 date
);


function issueReceipt(uint256 _id,
string memory _shipper,
string memory _cosignee,
string memory _destination,
uint64 _unit_Weigth,
uint64 _number_of_packages,
uint64 _total_weight,
uint64 _item_id,
uint256 _package_id,
uint256 _date) external returns (uint256) {
    Warehouse_Receipt memory _Warehouse_Receipt = Warehouse_Receipt({
        id: uint256 (_id),
        shipper: string(_shipper),
        cosignee: string(_cosignee),
        destination: string(_destination),
        unit_Weight: uint64(_unit_Weigth),
        number_of_packages: uint64(_number_of_packages),
        total_weight: uint64(_total_weight),
        item_id: uint64(_item_id),
        package_id: uint256(_package_id),
        date: uint256(_date)
    });
    receipts.push(_Warehouse_Receipt);
    uint256 receiptId = receipts.length-1;
    emit ReceiptIssued( receiptId, _shipper, _cosignee, _destination, _unit_Weigth, _number_of_packages, _total_weight, _item_id, _package_id, _date);
   return receiptId; 
}
function showcaseReceipts(uint256 _id) external view returns(
uint256 id,
    string memory shipper,
    string memory cosignee,
    string memory destination,
    uint64 unit_Weight,
    uint64 number_of_packages,
    uint64 total_weight,
    uint256 item_id,
    uint256 package_id,
    uint256 date
) {
    return (
        receipts[_id].id,
        receipts[_id].shipper,
        receipts[_id].cosignee,
        receipts[_id].destination,
        receipts[_id].unit_Weight,
        receipts[_id].number_of_packages,
        receipts[_id].total_weight,
        receipts[_id].item_id,
        receipts[_id].package_id,
        receipts[_id].date
);
}


}

