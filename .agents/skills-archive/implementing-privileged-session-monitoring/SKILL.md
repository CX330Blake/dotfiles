---
name: implementing-privileged-session-monitoring
description: >
  Monitor and audit privileged user sessions including SSH, RDP, and
  database access. Tracks session metadata, records commands, detects
  anomalous activity, and enforces session policies for PAM compliance.
domain: cybersecurity
subdomain: identity-access-management
tags: [pam, session-monitoring, privileged-access, audit-logging]
version: "1.0"
author: mahipal
license: Apache-2.0
---

# Implementing Privileged Session Monitoring

## When to Use

- Deploying session recording for all privileged access to critical servers and databases
- Meeting compliance requirements (PCI-DSS 10.2, SOX, HIPAA, ISO 27001) mandating privileged activity monitoring
- Investigating incidents where an administrator may have performed unauthorized actions
- Implementing real-time alerting for high-risk commands during privileged sessions
- Establishing a forensic audit trail of all administrative actions on production infrastructure

**Do not use** for monitoring standard user sessions; use EDR/UBA for general user behavior monitoring.

## Prerequisites

- CyberArk PAM or Privilege Cloud with Digital Vault, or open-source alternative (Teleport)
- PSM (Privileged Session Manager) or PSMP installed on hardened jump server
- Network architecture routing all privileged access through the PSM proxy
- Sufficient storage for recordings (estimate: 50-250 KB/min for RDP, 5-20 KB/min for SSH)

## Workflow

### Step 1: Route All Privileged Access Through PSM

```
Architecture:
  Admin User --> PVWA (Web Portal) --> PSM (Jump Server) --> Target Server

Network Controls:
  - DENY direct RDP (3389) / SSH (22) to targets from user networks
  - ALLOW RDP/SSH to targets ONLY from PSM server IPs
  - ALLOW PVWA access (443) from admin user networks
```

### Step 2: Configure PSM Connection Components

```
PVWA > Administration > Connection Components

For Windows RDP:
  Connection Component: PSM-RDP
  Record Sessions: Yes
  Recording Format: AVI (video) + Keystrokes (text)
  Record Windows Titles: Yes

For Linux SSH:
  Connection Component: PSM-SSH
  Record Sessions: Yes
  Record Unix Commands: Yes
```

### Step 3: Configure Session Recording Policies

```
PVWA > Platform Management > Session Management

  Enable Session Recording: Yes
  Keystroke Logging: Enable Transcript + Window Events
  Storage: Vault (encrypted, tamper-proof)

  Retention periods (per compliance):
    PCI-DSS:  1 year available, 3 months accessible
    SOX:      7 years
    HIPAA:    6 years

  Per-Safe policies:
    Production-Servers-Admin: Record all, real-time monitoring
    Third-Party-Vendor-Access: Record all, dual authorization required
```

### Step 4: Enable Real-Time Monitoring and Alerting

Configure CyberArk Privileged Threat Analytics (PTA):

```
PTA > Configuration > Security Events

Rule: High-Risk Command Detected
  Trigger patterns:
    - rm -rf /
    - chmod 777
    - useradd / passwd root
    - wget http* | sh / curl * | bash
    - nc -e /bin/sh
  Action: Alert SOC + Flag session as high-risk

Rule: Credential Access Attempt
  Trigger:
    - mimikatz.exe
    - procdump.exe targeting lsass
    - ntdsutil.exe
  Action: Terminate session + Alert SOC + Lock account

Rule: Unusual Session Duration
  Trigger: Session > 4 hours
  Action: Alert SOC for review
```

### Step 5: Configure Session Review Workflow

```
PVWA > Recordings > Search and Review

Review features:
  - Video playback with timeline scrubbing
  - Keystroke transcript alongside video
  - Window title log for application tracking
  - Risk events highlighted on timeline
  - Text search within keystroke transcript
  - Auditor can mark: Reviewed-OK, Suspicious, Requires-Investigation
```

### Step 6: Open-Source Alternative - Teleport

```yaml
# /etc/teleport.yaml
teleport:
  nodename: teleport-proxy.corp.internal

auth_service:
  enabled: yes
  session_recording: "node-sync"
  audit_sessions_uri: "s3://teleport-session-recordings/sessions?region=us-east-1"
  enhanced_recording:
    enabled: true
    command_events: true
    network_events: true
```

```bash
# List recorded sessions
tsh recordings ls --from=2026-03-15

# Play back a session
tsh play <session-id>

# Export session events for SIEM
tsh recordings export <session-id> --format=json > session_events.json
```

### Step 7: Forward Session Metadata to SIEM

```
CyberArk PTA > SIEM Integration
  Protocol: TCP + TLS (Syslog CEF)
  Destination: siem.corp.internal:6514

Events forwarded:
  - Session start/stop with user, target, duration
  - High-risk command alerts
  - Session termination events
  - Dual-authorization approvals/denials
```

## Key Concepts

| Term | Definition |
|------|------------|
| **PSM** | Privileged Session Manager - proxy recording all sessions in video and text |
| **PSMP** | PSM for SSH Proxy - Linux-based proxy for SSH, SCP, SFTP sessions |
| **PTA** | Privileged Threat Analytics - behavioral analytics and risk scoring for sessions |
| **Dual Authorization** | Two authorized users must approve before a privileged session is established |
| **Session Isolation** | All admin access proxied through PAM; no direct connections to targets |
| **Keystroke Transcript** | Searchable text log of all keystrokes during a recorded session |

## Verification

- [ ] All privileged access routes through PSM (direct RDP/SSH blocked by firewall)
- [ ] Session recordings stored encrypted with tamper protection
- [ ] Keystroke transcripts captured and searchable for SSH and RDP
- [ ] PTA rules trigger alerts for high-risk commands (test with benign trigger)
- [ ] Real-time monitoring dashboard shows active sessions with correct metadata
- [ ] Recordings play back in PVWA HTML5 player with timeline and transcript
- [ ] Retention policies match compliance requirements
- [ ] Dual authorization enforced for vendor and high-risk access
- [ ] Session metadata and alerts forwarding to SIEM
