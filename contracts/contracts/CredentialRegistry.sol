// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract CredentialRegistry is AccessControl, EIP712 {
    bytes32 public constant ISSUER_ROLE = keccak256("ISSUER_ROLE");
    bytes32 private constant CREDENTIAL_TYPEHASH =
        keccak256("Credential(bytes32 docHash,string studentName,string course,uint64 issueDate)");

    struct Record {
        uint64 issuedAt;
        bool revoked;
        address issuer;
    }

    struct Credential {
        bytes32 docHash;
        string studentName;
        string course;
        uint64 issueDate;
    }

    mapping(bytes32 => Record) public records;

    event Issued(bytes32 indexed docHash, address indexed issuer, uint64 issuedAt);
    event Revoked(bytes32 indexed docHash, address indexed issuer, uint64 revokedAt);

    constructor(address admin) EIP712("CredentialRegistry", "1") {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(ISSUER_ROLE, admin);
    }

    // Admin governance
    function addIssuer(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(ISSUER_ROLE, account);
    }

    function removeIssuer(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _revokeRole(ISSUER_ROLE, account);
    }

    // Main actions
    function issue(bytes32 docHash) external onlyRole(ISSUER_ROLE) {
        _issue(docHash, msg.sender);
    }

    function issueWithSignature(
        Credential calldata credential,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        bytes32 structHash = keccak256(
            abi.encode(
                CREDENTIAL_TYPEHASH,
                credential.docHash,
                keccak256(bytes(credential.studentName)),
                keccak256(bytes(credential.course)),
                credential.issueDate
            )
        );
        bytes32 hash = _hashTypedDataV4(structHash);
        address signer = ECDSA.recover(hash, v, r, s);

        require(hasRole(ISSUER_ROLE, signer), "signer is not an issuer");
        
        // Use the docHash from the credentials as the storage key
        _issue(credential.docHash, signer);
    }

    function _issue(bytes32 docHash, address issuer) internal {
        require(records[docHash].issuedAt == 0, "already issued");
        records[docHash] = Record(uint64(block.timestamp), false, issuer);
        emit Issued(docHash, issuer, uint64(block.timestamp));
    }

    function revoke(bytes32 docHash) external onlyRole(ISSUER_ROLE) {
        require(records[docHash].issuedAt != 0, "not issued");
        records[docHash].revoked = true;
        emit Revoked(docHash, msg.sender, uint64(block.timestamp));
    }

    function verify(bytes32 docHash)
        external
        view
        returns (bool issued, bool revoked, uint64 issuedAt, address issuer)
    {
        Record memory r = records[docHash];
        issued = r.issuedAt != 0;
        revoked = r.revoked;
        issuedAt = r.issuedAt;
        issuer = r.issuer;
    }
}
