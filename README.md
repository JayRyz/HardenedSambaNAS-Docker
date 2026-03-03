# Minimal-attack-surface containerized standalone SMB server for home lab, secure NAS use

## Overview

This project provides a security-focused Samba file server running inside a hardened Docker container.

The goal is to minimize attack surface while maintaining Windows ACL compatibility and SMB 3.11 encryption.

## Security Features

- Runs as non-root user (`made it work trough gosu`)
- Drops all Linux capabilities except required ones
- `no-new-privileges` enabled
- SMB 3.11 only (`makes sure no unsecure old versions are accepted)
- NTLMv1 disabled
- Mandatory SMB signing
- Mandatory SMB encryption
- Anonymous access disabled, guest disabled on a global level
- Docker secrets for password injection
- POSIX ACL + Windows ACL compatibility (`acl_xattr`)
- NetBIOS disabled (port 445 only)

## Architecture

- Base: Alpine Linux
- Network: Custom bridge with static IP
- Authentication: Local passdb backend
- Share isolation via ACL groups
- Secrets mounted at `/run/secrets` 
	(yes the way of handling passwords in this project could be better)
- Two Example Users, testuser1 (in group tick) and jayryz (not in group tick)

Deploy with: `docker compose up -d --build`

Make sure your firewall settings allow 445 traffic (set it up secure).


