export enum PostgresErrorCode {
  UNIQUE_VIOLATION = '23505',
  FOREIGN_KEY_VIOLATION = '23503',
  NOT_NULL_VIOLATION = '23502',
  SYNTAX_ERROR = '42601',
  CONNECTION_FAILURE = '08006',
  CLIENT_UNABLE_TO_ESTABLISH_CONNECTION = '08001',
  CONNECTION_DOES_NOT_EXIST = '08003',
  SERVER_REJECTED_CONNECTION = '08004',
  TRANSACTION_RESOLUTION_UNKNOWN = '08007',
  PROTOCOL_VIOLATION = '08P01',
}