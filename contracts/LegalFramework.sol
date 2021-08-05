// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;
contract LegalFramework {
    /*
    Outlines:
    1. If borrower defaults on loan then NFT is sold back at market price by collateral manager
    2. If borrower wants to get back NFT they can
    Re-Payments options:
    How do we deal with the connundrum of choosing to pay back loan?
    Install payments: NFT will know, as soon payment is done
    Take timestamp and have Oracle that will determine loan has been paid
    Process:
    Step1. Loan Registration
    Step2. Loan Repayment
    Step3. Pool via Chainlink/Oracle that will keep track of timestamp/repayment
    Step4. Pool confirmation
    */
    
    function stipulation(uint256 asset) pure public returns (bool) {
       /*
        1. If borrower defaults on loan then NFT is sold back at market price by collateral manager
        2. If borrower wants to get back NFT they can buy back NFT
        3. NFT has been sold, other funds put back into the pool
        1% to collateral manager once sale is final and the rest to goes back to the pool
        Any funds left post-sale (of loan) goes to asset owner and 1% goes to the collateral manager

    

       */
        
    }
}