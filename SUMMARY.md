# Summary

* [AuthDoc](README.md)

## API

* [GET /authorize](API/GetAuthorize.md)
* [GET /jwks](API/GetJwks.md)
* [GET /login/status](API/GetLoginStatus.md)
* [GET /signup/verify](API/GetSignupVerify.md)
* [GET /terms/current](API/GetTerm.md)
* [GET /userinfo](API/GetUserinfo.md)
* [GET /.well-known/openid-configuration](API/GetWellKnown.md)
* [POST /account/password](API/PostAccountPassword.md)
* [POST /account/withdrawal](API/PostAccountWithdrawal.md)
* [POST /agent](API/PostAgent.md)
* [POST /agent/{agent_id}/revoke](API/PostAgentRevoke.md)
* [POST /agent/{agent_id}/secret](API/PostAgentSecret.md)
* [POST /agent/token](API/PostAgentToken.md)
* [POST /login](API/PostLogin.md)
* [POST /logout](API/PostLogout.md)
* [POST /mfa/authenticator/setup](API/PostMfaAuthenticatorSetup.md)
* [POST /mfa/authenticator/verify](API/PostMfaAuthenticatorVerify.md)
* [POST /mfa/email/start](API/PostMfaEmailStart.md)
* [POST /mfa/email/verify](API/PostMfaEmailVerify.md)
* [POST /password/reset/start](API/PostPasswordResetStart.md)
* [POST /password/reset](API/PostPasswordReset.md)
* [POST /revoke](API/PostRevoke.md)
* [POST /signup/email](API/PostSignupEmail.md)
* [POST /signup/resend](API/PostSignupResend.md)
* [POST /terms](API/PostTermConsent.md)
* [POST /token](API/PostToken.md)
* [Signup](API/signup.md)

## Architecture

* [パスワード変更設計](Architecture/Account/PasswordChange.md)
* [パスワードリセット設計](Architecture/Account/PasswordReset.md)
* [退会設計](Architecture/Account/Withdrawal.md)
* [AI Agent Delegated Auth](Architecture/Agent/DelegatedAuth.md)
* [AI Agent Delegated Scope Policy](Architecture/Agent/ScopePolicy.md)
* [AI Agent Secret Management](Architecture/Agent/SecretManagement.md)

## Data

* [Cookie](Data/Cookie.md)
* [RDB Summary](Data/RDB_Summary.md)
* [client_data_key](Data/RDB_Table/client_data_key.md)
* [client_master](Data/RDB_Table/client_master.md)
* [client_redirect_uri](Data/RDB_Table/client_redirect_uri.md)
* [client_scope](Data/RDB_Table/client_scope.md)
* [client_term](Data/RDB_Table/client_term.md)
* [data_key_master](Data/RDB_Table/data_key_master.md)
* [jwk_master](Data/RDB_Table/jwk_master.md)
* [osolab_user](Data/RDB_Table/osolab_user.md)
* [scope_data_key](Data/RDB_Table/scope_data_key.md)
* [scope_master](Data/RDB_Table/scope_master.md)
* [term_master](Data/RDB_Table/term_master.md)
* [user_client_scope_consent](Data/RDB_Table/user_client_scope_consent.md)
* [user_info](Data/RDB_Table/user_info.md)
* [user_term_consent](Data/RDB_Table/user_term_consent.md)
* [Redis](Data/Redis.md)

## ScreenDesign

* [Client Register Screen](ScreenDesign/ClientRegisterScreenDesign.md)
* [AI Agent Management Screen](ScreenDesign/AgentManagementScreenDesign.md)
* [JWK Key Management](ScreenDesign/JwkKeyManagement.md)
* [Login Screen](ScreenDesign/LoginScreenDesign.md)
* [AuthPortal Production Hardening](ScreenDesign/PortalProductionHardening.md)
* [Password Reset Screen](ScreenDesign/PasswordResetScreenDesign.md)

## Sequence

* [Authorization Code Flow](Sequence/AuthorizationCodeFlow.md)
* [Client Registration Flow](Sequence/ClientRegister.md)
* [MFA / Step-up Authorization Flow](Sequence/MfaStepUp.md)
* [Password Reset Flow](Sequence/PasswordReset.md)
* [Portal Login Flow](Sequence/PortalLogin.md)
* [Sign-out / Token Revocation Flow](Sequence/SignOut.md)
* [Signup Flow](Sequence/Signup.md)
* [Signup Flow (Summary)](Sequence/SignupSimple.md)

## Testing

* [API Tester Scenario Design](Testing/ApiTesterScenarios.md)
