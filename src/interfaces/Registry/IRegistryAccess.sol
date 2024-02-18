// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;


// @audit: we should be able to bypass this!!!
interface IRegistryAccess {
    function getOwner() external view returns (address);

    function checkRole(bytes32 role, address user) external view returns (bool);
}
