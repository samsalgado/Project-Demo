// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Receipt is ReentrancyGuard {
    struct warehouseReceipt {
        uint256 id;
        string shipper;
        string cosignee;
        string destination;
        uint64 unitWeight;
        uint64 numberOfPackages;
        uint64 totalWeight;
        uint256 itemId;
        uint256 packageId;
        uint256 date;
    }

    warehouseReceipt[] public receipts;

    event ReceiptIssued(
        uint256 ReceiptId,
        string shipper,
        string cosignee,
        string destination,
        uint64 unitWeight,
        uint64 numberOfPackages,
        uint64 totalWeight,
        uint256 itemId,
        uint256 packageId,
        uint256 date
    );

    function issueReceipt(
        uint256 _id,
        string memory _shipper,
        string memory _cosignee,
        string memory _destination,
        uint64 _unitWeight,
        uint64 _numberOfPackages,
        uint64 _totalWeight,
        uint64 _itemId,
        uint256 _packageId,
        uint256 _date
    ) external returns (uint256) {
        warehouseReceipt memory _warehouseReceipt = warehouseReceipt(
            _id,
            _shipper,
            _cosignee,
            _destination,
            _unitWeight,
            _numberOfPackages,
            _totalWeight,
            _itemId,
            _packageId,
            _date
        );
        receipts.push(_warehouseReceipt);
        uint256 receiptId = receipts.length - 1;
        emit ReceiptIssued(
            receiptId,
            _shipper,
            _cosignee,
            _destination,
            _unitWeight,
            _numberOfPackages,
            _totalWeight,
            _itemId,
            _packageId,
            _date
        );
        return receiptId;
    }

    // Waaaayy too many return values
    // Too many arguments, local variables, and return values will break the compiler
    // Not necessary if we have structs
    // Also, never name the return values; only declare their variable typesz
    function showReceipts(uint256 _id)
        external
        view
        returns (
            uint256,
            string memory,
            string memory,
            string memory,
            uint64,
            uint64,
            uint64,
            uint256,
            uint256,
            uint256
        )
    {
        warehouseReceipt memory receipt = receipts[_id];
        return (
            receipt.id,
            receipt.shipper,
            receipt.cosignee,
            receipt.destination,
            receipt.unitWeight,
            receipt.numberOfPackages,
            receipt.totalWeight,
            receipt.itemId,
            receipt.packageId,
            receipt.date
        );
    }
}
