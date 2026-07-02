# The Littlefish Hunter - 30-Day Threat Intelligence Report
**Period:** 2026-06-02 – 2026-07-02  
**Generated:** 2026-07-02

## Executive Summary
This report presents a comparative analysis of automated threat activity targeting a production Cloud VPS and a residential Cowrie Honeypot over the last 30 days. The results clearly demonstrate strong segmentation between enterprise/cloud-targeted and IoT-focused botnet campaigns.

## Key Findings

- **Cloud VPS** is subjected to high-volume, aggressive brute-force attacks, predominantly from Polish data center infrastructure (AS43422 - ISAEV Igor).
- **Residential Honeypot** experiences steady, lower-intensity activity focused on default credentials and hardcoded IoT backdoors.
- No meaningful source IP overlap was observed between the two environments.
- Modern botnets clearly differentiate targeting strategies based on infrastructure type.

## Top Wazuh Signatures (Cloud VPS)
```
 134833 sshd: Attempt to login using a non-existent user
  75394 sshd: authentication failed.
  52504 PAM: User login failed.
  33781 syslog: User missed the password more than one time
  20815 sshd: connection reset
   4353 PAM: Multiple failed logins in a small period of time.
```

## Top Attacker IPs - Cloud VPS
```
  82599 87.251.64.147
  52936 87.251.64.145
  52188 87.251.64.144
  51150 87.251.64.149
   1640 45.144.212.75
   1608 77.83.39.217
```

## Top Passwords - Honeypot
```
   3987 123456
   2683 admin
   2303 123
   1985 1234
   1491 1
   1422 12345678
   1311 password
   1305 root
```

## Top Credential Pairs - Honeypot
```
   2239 root : admin
    337 345gs5662d34 : 345gs5662d34
    329 root : 3245gs5662d34
    269 admin : admin
    129 root : baidu123
    122 root : root
```

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
