# The Littlefish Hunter – AI-Powered Honeypot & Threat Detection Node

An automated Cyber Threat Intelligence (CTI) and forensic analysis node deployed within a residential hybrid infrastructure (**rpilab**). This project demonstrates initial access interception, automated event logging via Wazuh SIEM, and active post-exploitation attribution of global automated threat campaigns.

## 🛠️ Infrastructure Architecture & Flow
[Internet Scanner / Botnet]
│
▼ (Port 22 / SSH)
[Raspberry Pi Host (rpilab)]
│
▼ (Docker Container Bridging)
[Cowrie Interactive Honeypot] ──(Raw JSON Events)──► [Wazuh SIEM Agent]
│
▼ (Decoders/Rules)
[Security Dashboard Alerts]


## 📋 Project Overview
* **SIEM Platform:** Wazuh
* **Telemetry Source:** Cowrie Honeypot (Hardened Docker Image)
* **Target Environment:** `rpilab` (Raspberry Pi Node)
* **Monitored Vector:** Automated Distributed SSH Brute-Force & Credential Stuffing.
* **Adversary Attribution:** Kinsing Botnet Threat Group (Monero Crypto-Jacking Campaign).

---

## 🔬 Project Documentation & Forensic Reports

This laboratory setup generated high-fidelity telemetry that was analyzed using two distinct methodologies. You can access the complete technical PDF reports directly within this repository:

### 1. 📄 Macro-Level Investigation: Distributed Attack Infrastructure
This phase focused on the wide-scale triangulation of the campaign, profiling global network distributions, carrier netblocks, and tracking automated multi-vector credential stuffing blasts.
* 👉 **[Open Campaign Intelligence Report (PDF)](https://github.com/jacekkaplon/The-Littlefish-Hunter/blob/main/SOC_Threat_Intelligence_Report_Botnet_Campaign.pdf)**

### 2. 📄 Micro-Level Deep Dive: Threat Host Attribution & Forensics
A focused forensic examination isolating a single high-frequency attacking node. Includes the active technical workflow executed on the host system to extract IoC artifacts from a **56.9 MB** raw `cowrie.json` file inside a minimal Docker container.
* 👉 **[Open Deep-Dive Forensic Report (PDF)](https://github.com/jacekkaplon/The-Littlefish-Hunter/blob/main/CTI_Threat_Report_Kinsing_Botnet.pdf)**

---

## 💻 Forensic Log Extraction Playbook (Summary)
To bypass image bin constraints within the active container, the following forensic execution layout was utilized to isolate 29 unique malicious SSH public keys:

```bash
# 1. Audit container state
docker ps

# 2. Extract active telemetry database out of the container
docker cp cowrie:/home/cowrie/cowrie/log/cowrie.json ./cowrie_local.json

# 3. Parse and de-duplicate raw ssh-rsa strings using regex
grep -o "ssh-rsa [A-Za-z0-9+/]*=\?" cowrie_local.json | sort -u > botnet_key.txt

# 4. Generate deterministic cryptographic hash of the evidence
sha256sum botnet_key.txt

Disclaimer: This repository is part of a secure home-laboratory project used exclusively for active defense research, log analysis, and threat telemetry collection.
