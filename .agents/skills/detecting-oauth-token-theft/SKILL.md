---
name: detecting-oauth-token-theft
description: >
  Detect OAuth access token theft and misuse by analyzing sign-in logs for
  impossible travel, new device patterns, token replay from unusual IPs,
  and anomalous scope requests via Microsoft Graph and Okta APIs.
domain: cybersecurity
subdomain: identity-security
tags: [oauth, token-theft, identity-attacks, impossible-travel]
version: "1.0"
author: mahipal
license: Apache-2.0
---

# Detecting OAuth Token Theft

## When to Use

- Investigating alerts for impossible travel or anomalous token usage in Microsoft Entra ID
- Responding to a suspected session hijacking or pass-the-cookie attack
- Configuring proactive defenses against OAuth token theft in an Azure/M365 environment
- Detecting OAuth device code phishing campaigns that bypass MFA
- Analyzing sign-in logs for token replay indicators
- Implementing Token Protection conditional access policies to bind tokens to devices

**Do not use** for on-premises Kerberos ticket attacks (pass-the-ticket, golden ticket); use Active Directory-specific investigation techniques for those scenarios.

## Prerequisites

- Microsoft Entra ID P2 license (required for Identity Protection risk detections and conditional access)
- Global Administrator or Security Administrator role in the Entra admin center
- Microsoft Defender for Cloud Apps (MDCA) license for session anomaly detection
- Access to Entra ID Sign-in Logs and Audit Logs (Diagnostic Settings to Log Analytics or Sentinel)
- Familiarity with OAuth 2.0 authorization flows (authorization code, device code, client credentials)

## Workflow

### Step 1: Understand the Token Theft Attack Surface

Key token types and theft vectors:

| Token Type | Lifetime | Theft Vector | Impact |
|---|---|---|---|
| Access Token | 60-90 min | Memory dump, proxy interception | API access for token lifetime |
| Refresh Token | Up to 90 days | Browser cookie theft, malware | Persistent access |
| Primary Refresh Token | Session-based | Mimikatz, AADInternals | Full SSO to all M365/Azure apps |
| Session Cookie | Varies | XSS, AitM proxy | Full session hijacking |

### Step 2: Configure Entra ID Sign-in Risk Detection

Enable Identity Protection to flag anomalous token usage:

```
Entra Admin Center > Protection > Identity Protection > Risk Detections

Key risk detections for token theft:
- Anomalous Token        : Unusual token characteristics
- Token Issuer Anomaly   : Token from unusual issuer
- Unfamiliar Sign-in     : New location for user
- Impossible Travel      : Geographically impossible sign-ins
- Malicious IP Address   : Known malicious source
```

Configure risk-based conditional access:

```
Policy: "Block High-Risk Sign-ins"
  Users: All users (exclude break-glass accounts)
  Conditions: Sign-in Risk = High
  Grant: Block access

Policy: "Require MFA for Medium-Risk"
  Conditions: Sign-in Risk = Medium
  Grant: Require MFA + password change
```

### Step 3: Enable Token Protection

Bind sign-in session tokens to device TPM:

```
Entra Admin Center > Protection > Conditional Access > New Policy

Policy: "Enforce Token Protection"
  Users: Pilot group (expand after validation)
  Cloud Apps: Office 365 Exchange Online, SharePoint Online
  Conditions: Device Platforms = Windows
  Session: Require token protection for sign-in sessions
  Grant: Require compliant or Hybrid Azure AD joined device
```

### Step 4: Detect Token Replay in Sign-in Logs

KQL queries for Microsoft Sentinel or Log Analytics:

```kusto
// Detect anomalous token usage
SigninLogs
| where TimeGenerated > ago(7d)
| where RiskDetail contains "token" or RiskEventTypes_V2 has "anomalousToken"
| project TimeGenerated, UserPrincipalName, IPAddress, Location,
          RiskDetail, RiskLevelDuringSignIn, AppDisplayName
| sort by TimeGenerated desc

// Detect impossible travel with token reuse
SigninLogs
| where TimeGenerated > ago(7d)
| where ResultType == 0
| summarize Locations=make_set(Location), IPs=make_set(IPAddress),
            Count=count() by UserPrincipalName, bin(TimeGenerated, 1h)
| where array_length(Locations) > 1

// Detect device code flow abuse (phishing)
SigninLogs
| where TimeGenerated > ago(7d)
| where AuthenticationProtocol == "deviceCode"
| project TimeGenerated, UserPrincipalName, IPAddress, Location, AppDisplayName
```

### Step 5: Investigate and Respond

```powershell
# Revoke all refresh tokens for compromised user
Connect-MgGraph -Scopes "User.ReadWrite.All"
Revoke-MgUserSignInSession -UserId "user@contoso.com"

# Force password reset
Update-MgUser -UserId "user@contoso.com" -PasswordProfile @{
    ForceChangePasswordNextSignIn = $true
}

# Review and revoke malicious OAuth app consent grants
Get-MgUserOauth2PermissionGrant -UserId "user@contoso.com"
Remove-MgOauth2PermissionGrant -OAuth2PermissionGrantId "<grant-id>"

# Check for mail forwarding rules (common post-compromise action)
Get-MgUserMailFolderRule -UserId "user@contoso.com" -MailFolderId "Inbox" |
    Where-Object { $_.Actions.ForwardTo -ne $null }
```

### Step 6: Enable Continuous Access Evaluation (CAE)

```
Entra Admin Center > Protection > Conditional Access > Continuous Access Evaluation
  Strictly enforce location policies: Enabled

CAE triggers near-real-time token revocation when:
- User account disabled/deleted
- Password changed/reset
- Admin explicitly revokes tokens
- Identity Protection detects elevated risk
```

## Key Concepts

| Term | Definition |
|------|------------|
| **Primary Refresh Token (PRT)** | Long-lived device-bound token providing SSO to all Azure AD apps |
| **Token Protection** | Conditional access feature binding tokens to device TPM |
| **Continuous Access Evaluation** | Near-real-time policy enforcement on token revocation |
| **AitM (Adversary-in-the-Middle)** | Phishing that proxies auth flow to capture session cookies post-MFA |
| **Device Code Flow** | OAuth grant for input-constrained devices; abused in phishing campaigns |

## Verification

- [ ] Identity Protection risk detections generating alerts for anomalous tokens
- [ ] Conditional access policies block high-risk sign-ins and require MFA for medium-risk
- [ ] Token Protection confirmed working (test from unregistered device fails)
- [ ] KQL queries return results against synthetic anomaly events
- [ ] CAE enabled and verified (revoke session, confirm access blocked within minutes)
- [ ] Incident response runbook includes token revocation and OAuth consent review
