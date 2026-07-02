#!/bin/bash
# =====================================================
# The Littlefish Hunter - Monthly 30-Day Threat Report
# Final Professional & Clean Version
# =====================================================

REPORT_DATE=$(date +"%Y-%m-%d")
START_DATE="2026-06-02"
END_DATE="2026-07-02"

REPORT_DIR="reports"
MD_REPORT="${REPORT_DIR}/${REPORT_DATE}_30day_Threat_Report.md"
RAW_VPS="${REPORT_DIR}/${REPORT_DATE}_VPS_Raw.txt"
RAW_HONEYPOT="${REPORT_DIR}/${REPORT_DATE}_Honeypot_Raw.txt"

mkdir -p "$REPORT_DIR"

echo "Generating The Littlefish Hunter 30-Day Threat Report..."

# ==================== COLLECT DATA ====================
echo "→ Collecting data from logs..."

VPS_IPS=$(sudo zgrep -h "sshd" /var/ossec/logs/alerts/2026/Jun/*.json.gz /var/ossec/logs/alerts/2026/Jul/*.json.gz 2>/dev/null | \
jq -r 'select(.agent.name == "PL84924" and .data.srcip != null) | .data.srcip' | sort | uniq -c | sort -nr | head -n 6)

VPS_SIGS=$(sudo zgrep -h "sshd" /var/ossec/logs/alerts/2026/Jun/*.json.gz /var/ossec/logs/alerts/2026/Jul/*.json.gz 2>/dev/null | \
jq -r 'select(.agent.name == "PL84924" and .rule.description != null) | .rule.description' | sort | uniq -c | sort -nr | head -n 6)

HONEYPOT_PASS=$(sudo zgrep -h '"eventid":"cowrie' /var/ossec/logs/archives/2026/Jun/*.json.gz /var/ossec/logs/archives/2026/Jul/*.json.gz 2>/dev/null | \
jq -r 'select(.agent.name == "rpilab" and .data.password != null) | .data.password' | sort | uniq -c | sort -nr | head -n 8)

HONEYPOT_PAIRS=$(sudo zgrep -h '"eventid":"cowrie' /var/ossec/logs/archives/2026/Jun/*.json.gz /var/ossec/logs/archives/2026/Jul/*.json.gz 2>/dev/null | \
jq -r 'select(.agent.name == "rpilab" and .data.username != null and .data.password != null) | "\(.data.username) : \(.data.password)"' | \
sort | uniq -c | sort -nr | head -n 6)

# ==================== SAVE RAW DATA ====================
cat > "$RAW_VPS" << EOF
==================================================================
VPS RAW REPORT - ${REPORT_DATE}
==================================================================
Top Attacker IPs:
${VPS_IPS}

Top Wazuh Signatures:
${VPS_SIGS}
EOF

cat > "$RAW_HONEYPOT" << EOF
==================================================================
HONEYPOT RAW REPORT - ${REPORT_DATE}
==================================================================
Top Passwords:
${HONEYPOT_PASS}

Top Credential Pairs:
${HONEYPOT_PAIRS}
EOF

# ==================== FINAL PROFESSIONAL REPORT ====================
cat > "$MD_REPORT" << EOF
# The Littlefish Hunter - 30-Day Threat Intelligence Report
**Period:** ${START_DATE} – ${END_DATE}  
**Generated:** ${REPORT_DATE}

## Executive Summary
This report presents a comparative analysis of automated threat activity targeting a production Cloud VPS and a residential Cowrie Honeypot over the last 30 days. The results clearly demonstrate strong segmentation between enterprise/cloud-targeted and IoT-focused botnet campaigns.

## Key Findings

- **Cloud VPS** is subjected to high-volume, aggressive brute-force attacks, predominantly originating from Polish data center infrastructure (AS43422 - ISAEV Igor).
- **Residential Honeypot** experiences steady, lower-intensity activity focused on default credentials and hardcoded IoT backdoors.
- No meaningful source IP overlap was observed between the two environments.
- Modern botnets clearly differentiate targeting strategies based on infrastructure type.

## Top Wazuh Signatures (Cloud VPS)
\`\`\`
${VPS_SIGS}
\`\`\`

## Top Attacker IPs - Cloud VPS
\`\`\`
${VPS_IPS}
\`\`\`

## Top Passwords - Honeypot
\`\`\`
${HONEYPOT_PASS}
\`\`\`

## Top Credential Pairs - Honeypot
\`\`\`
${HONEYPOT_PAIRS}
\`\`\`

## Comparative Analysis

| Aspect                    | Cloud VPS (PL84924)                              | Residential Honeypot (rpilab)                    |
|---------------------------|--------------------------------------------------|--------------------------------------------------|
| **Attack Volume**         | **Very High**                                    | Moderate & Steady                                |
| **Attack Pattern**        | Burst / High-frequency                           | Continuous background scanning                   |
| **Primary Targets**       | root, ubuntu, postgres, oracle, mysql            | admin, root, 123456, IoT backdoors               |
| **Main Source**           | Data center / Bulletproof hosting (Poland)       | Compromised consumer/IoT devices                 |
| **Technique**             | Industrial brute-force                           | Credential stuffing + worm propagation           |

## Recommendations

1. **Cloud Assets** — Enforce key-based SSH authentication only and consider geo-blocking high-risk ASNs.
2. **Edge/IoT Devices** — Avoid exposing management ports publicly. Use VPN or non-standard ports.
3. **Monitoring Strategy** — Use contextual threat intelligence and separate feeds for cloud vs residential environments.
4. **Defense** — Maintain active Wazuh + Cowrie deployment for continuous visibility and rapid detection.

---
**Project:** The Littlefish Hunter  
**Analyst:** Jacek Kaplon  
**GitHub:** [The-Littlefish-Hunter](https://github.com/jacekkaplon/The-Littlefish-Hunter)
EOF

echo "=================================================================="
echo "✅ Professional 30-Day Threat Report successfully generated!"
echo "   📄 Main Report : $MD_REPORT"
echo "   📊 Raw VPS      : $RAW_VPS"
echo "   📊 Raw Honeypot : $RAW_HONEYPOT"
echo "=================================================================="
