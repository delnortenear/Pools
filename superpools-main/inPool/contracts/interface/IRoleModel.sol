pragma solidity ^0.6.0;

contract IRoleModel {
    /**
     * SUPER_ADMIN_ROLE - The Role controls adding a new wallet addresses to according roles arrays
     */
    bytes32 public constant SUPER_ADMIN_ROLE = keccak256("SUPER_ADMIN_ROLE");

    /**
     * GENERAL_PARTNER_ROLE - The Role controls the approval process to transfer money inside
     *               investment pools and control Limited Partners adding, investment
     *               pools adding
     */
    bytes32 public constant GENERAL_PARTNER_ROLE = keccak256("GENERAL_PARTNER_ROLE");

    /**
     * LIMITED_PARTNER_ROLE - The Role allows the wallet of LP to invest money in the
     *               investment pool and withdraw money from there (access to limited pools)
     */
    bytes32 public constant LIMITED_PARTNER_ROLE = keccak256("LIMITED_PARTNER_ROLE");

    /**
     * TEAM_ROLE - Role that exposes access to wallets (the team member), were
     *           distributed all fees, fines, and success premiums from investment pools
     */
    bytes32 public constant TEAM_ROLE = keccak256("TEAM_ROLE");

    /**
     * STURTAP_TEAM_ROLE - Role that exposes access to wallets which can withdraw
     *              investor’s money after convert to tokens/NFT assets (access tolimited pools)
     */
    bytes32 public constant STURTAP_TEAM_ROLE = keccak256("STURTAP_TEAM_ROLE");

    /**
     * REFERER_ROLE - Registry of wallets, which connects LP with their Referrer to sent
     *               there a part of the fees.
     */
    bytes32 public constant REFERER_ROLE = keccak256("REFERER_ROLE");

    /**
     * ORACLE_ROLE - Registry of wallets, which connects LP with their Referrer to sent
     *               there a part of the fees.
     */
    bytes32 public constant ORACLE_ROLE = keccak256("ORACLE_ROLE");

    /**
     * POOL_REGISTRY - Registry of contract, which manage contract;
     */
    bytes32 public constant POOL_REGISTRY = keccak256("POOL_REGISTRY");
}
