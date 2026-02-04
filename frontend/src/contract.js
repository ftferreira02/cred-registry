export const CONTRACT_ADDRESS = "0x6ef26CdbC1918Ff95dD50A132764D1d04A3b12ed";
export const ABI = [
  "function issue(bytes32 docHash) external",
  "function issueWithSignature(tuple(bytes32 docHash, string studentName, string course, uint64 issueDate, string ipfsCid) credential, uint8 v, bytes32 r, bytes32 s) external",
  "function revoke(bytes32 docHash) external",
  "function verify(bytes32 docHash) external view returns (bool issued, bool revoked, uint64 issuedAt, address issuer, string memory ipfsCid)",
  "event Issued(bytes32 indexed docHash, address indexed issuer, uint64 issuedAt, string ipfsCid)",
  "event Revoked(bytes32 indexed docHash, address indexed issuer, uint64 revokedAt)"
];
