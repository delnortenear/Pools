pragma solidity ^0.6.0;

interface IReturnInvestmentLpartner {
  function _request(address pool, address lPartner, uint256 index) external returns(bool);
  
  function _approve(address pool, address lPartner, address sender) external returns(bool);
  
  function _disapprove(address pool, address lPartner, address sender) external returns(bool);

  function getRequests(address pool) external view returns(address[] memory);
  
  function getRequestsLpartner(address pool, address lPartner) external view returns(uint256[] memory);
}