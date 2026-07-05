---
name: implementing-devsecops-security-scanning
description: >
  Integrate security scanning into CI/CD pipelines using tools like Semgrep,
  Trivy, and Gitleaks. Covers SAST, SCA, container scanning, and secret
  detection with structured JSON output for pipeline gates.
domain: cybersecurity
subdomain: application-security
tags: [devsecops, sast, sca, container-security, ci-cd]
version: "1.0"
author: mahipal
license: Apache-2.0
---

# Implementing DevSecOps Security Scanning

## When to Use

- Setting up automated security scanning in a new or existing CI/CD pipeline
- Shifting security left by catching vulnerabilities before production
- Meeting compliance requirements (SOC 2, PCI-DSS, ISO 27001) mandating automated security testing
- Integrating SAST, DAST, and SCA for comprehensive application security coverage
- Establishing security gates that block deployments with critical/high vulnerabilities

**Do not use** as a replacement for manual penetration testing. Automated scanning catches common patterns but cannot replace human-driven assessments for business logic flaws.

## Prerequisites

- CI/CD platform: GitHub Actions, GitLab CI, Jenkins, or Azure DevOps
- Container runtime (Docker) for running scanning tools
- A staging environment URL for DAST scanning
- Tool requirements: Semgrep (free), Trivy (free), OWASP ZAP (free), Gitleaks (free)

## Workflow

### Step 1: Add Secrets Detection with Gitleaks

```yaml
# .github/workflows/security.yml
name: DevSecOps Security Pipeline
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  secrets-scan:
    name: Secrets Detection (Gitleaks)
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: Run Gitleaks
        uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### Step 2: Add SAST Scanning with Semgrep

```yaml
  sast-scan:
    name: SAST (Semgrep)
    runs-on: ubuntu-latest
    container:
      image: semgrep/semgrep
    steps:
      - uses: actions/checkout@v4
      - name: Run Semgrep SAST scan
        run: |
          semgrep scan \
            --config p/security-audit \
            --config p/owasp-top-ten \
            --severity ERROR \
            --error \
            --json --output semgrep-results.json .
      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: semgrep-results
          path: semgrep-results.json
```

### Step 3: Add SCA and Container Scanning with Trivy

```yaml
  sca-scan:
    name: SCA & Container Scan (Trivy)
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Trivy filesystem scan (dependencies)
        uses: aquasecurity/trivy-action@0.28.0
        with:
          scan-type: 'fs'
          scan-ref: '.'
          severity: 'CRITICAL,HIGH'
          exit-code: '1'
          format: 'json'
          output: 'trivy-fs-results.json'
      - name: Build and scan container image
        run: |
          docker build -t app:${{ github.sha }} .
      - uses: aquasecurity/trivy-action@0.28.0
        with:
          image-ref: 'app:${{ github.sha }}'
          severity: 'CRITICAL,HIGH'
          exit-code: '1'
```

### Step 4: Add DAST Scanning with OWASP ZAP

```yaml
  dast-scan:
    name: DAST (OWASP ZAP)
    runs-on: ubuntu-latest
    needs: [deploy-staging]
    steps:
      - uses: actions/checkout@v4
      - name: ZAP Baseline Scan
        uses: zaproxy/action-baseline@v0.14.0
        with:
          target: ${{ vars.STAGING_URL }}
          rules_file_name: '.zap/rules.tsv'
```

Configure `.zap/rules.tsv` alert thresholds:

```tsv
40012	FAIL	(Cross Site Scripting - Reflected)
40014	FAIL	(Cross Site Scripting - Persistent)
40018	FAIL	(SQL Injection)
90019	FAIL	(Server Side Code Injection)
10038	FAIL	(Content Security Policy Header Not Set)
```

### Step 5: Enforce Security Gates

```yaml
  security-gate:
    name: Security Gate
    runs-on: ubuntu-latest
    needs: [secrets-scan, sast-scan, sca-scan]
    if: always()
    steps:
      - name: Check scan results
        run: |
          if [[ "${{ needs.secrets-scan.result }}" == "failure" ]]; then
            echo "BLOCKED: Secrets detected"; exit 1
          fi
          if [[ "${{ needs.sast-scan.result }}" == "failure" ]]; then
            echo "BLOCKED: SAST critical/high findings"; exit 1
          fi
          if [[ "${{ needs.sca-scan.result }}" == "failure" ]]; then
            echo "BLOCKED: Vulnerable dependencies"; exit 1
          fi
          echo "All security gates passed"
```

### Step 6: Configure Pre-commit Hooks

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.22.1
    hooks:
      - id: gitleaks
  - repo: https://github.com/semgrep/semgrep
    rev: v1.102.0
    hooks:
      - id: semgrep
        args: ['--config', 'p/security-audit', '--error']
```

```bash
pip install pre-commit
pre-commit install
pre-commit run --all-files
```

## Key Concepts

| Term | Definition |
|------|------------|
| **SAST** | Static Application Security Testing - analyzes source code without execution |
| **DAST** | Dynamic Application Security Testing - tests running applications |
| **SCA** | Software Composition Analysis - scans dependencies for known vulnerabilities |
| **SBOM** | Software Bill of Materials - inventory of all components |
| **Shift Left** | Moving security testing earlier in the SDLC |
| **Security Gate** | CI/CD checkpoint blocking deployment on scan failures |

## Verification

- [ ] Gitleaks blocks commits containing hardcoded secrets
- [ ] Semgrep runs on every PR and reports findings
- [ ] Trivy detects known-vulnerable dependencies
- [ ] OWASP ZAP baseline scan runs against staging URL
- [ ] Security gate blocks merges when critical/high findings exist
- [ ] Branch protection rules enforce required status checks
- [ ] Pre-commit hooks catch issues locally before push
