export const CONTRACT_ADDRESS = "0x0C6Fe5983595528E2B27294bc6b9a5C7736989EB";

export const ABI = [
  "function issue(bytes32)",
  "function revoke(bytes32)",
  "function verify(bytes32) view returns (bool issued,bool revoked,uint64 issuedAt,address issuer)",
  "function issueWithSignature(tuple(bytes32 docHash, string studentName, string course, uint64 issueDate) credential, uint8 v, bytes32 r, bytes32 s)",
  "function hasRole(bytes32,address) view returns (bool)",
  "event Issued(bytes32 indexed docHash, address indexed issuer, uint64 issuedAt)",
  "event Revoked(bytes32 indexed docHash, address indexed issuer, uint64 revokedAt)"
];
