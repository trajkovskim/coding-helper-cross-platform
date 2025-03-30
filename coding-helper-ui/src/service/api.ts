export const AUTHORIZATION_HEADER = "Authorization";
export const AUTHORIZATION_PREFIX = "Bearer";

export const createAuthorizationHeader = () => `${AUTHORIZATION_PREFIX}: ${localStorage.getItem(AUTHORIZATION_HEADER)}`;
