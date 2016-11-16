From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/9] KEYS: Blacklisting & UEFI database load
Date: Wed, 16 Nov 2016 18:10:44 +0000
Message-ID: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


Here are two sets of patches.  Firstly, the first three patches provide a
blacklist, making the following changes:

 (1) Add a new key type, blacklist, that is a slimline key that just
     contains a blacklisted hash and a note saying what it applies to.

 (2) Add a system keyring, .blacklist, that holds blacklisted hashes.

 (3) Add a pair of functions, one that blacklists a hash and the other that
     queries as to whether a hash is blacklisted.

 (4) Check the TBS hash of an X.509 cert against the blacklist.

 (5) Check the PKCS#7 content hash against the blacklist.

 (6) Allow a file of blacklisted hashes to be included in the build.

Secondly, the remaining patches allow the UEFI database to be used to load
the system keyrings:

 (1) Kernel initialisation is permitted to add keys to the
     .secondary_trusted_keys keyring.

 (2) A parser is added to parse the contents of the UEFI variables that
     contain keys and hashes.

 (3) The UEFI db and MokListRT variables are parsed for keys which are
     loaded into the secondary keyring.

 (4) The UEFI dbx variable is parsed for hashes to be blacklisted.

 (5) Use of the UEFI db variable can be suppressed by another UEFI variable.

The patches can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-blacklist

and:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-uefi

David
---
Dave Howells (2):
      efi: Add EFI signature data types
      efi: Add an EFI signature blob parser

David Howells (5):
      KEYS: Add a system blacklist keyring
      X.509: Allow X.509 certs to be blacklisted
      PKCS#7: Handle blacklisted certificates
      KEYS: Allow unrestricted boot-time addition of keys to secondary keyring
      efi: Add SHIM and image security database GUID definitions

Josh Boyer (2):
      MODSIGN: Import certificates from UEFI Secure Boot
      MODSIGN: Allow the "db" UEFI variable to be suppressed


 certs/Kconfig                            |   42 +++++++
 certs/Makefile                           |   11 ++
 certs/blacklist.c                        |  174 +++++++++++++++++++++++++++
 certs/blacklist.h                        |    3 
 certs/blacklist_hashes.c                 |    6 +
 certs/blacklist_nohashes.c               |    5 +
 certs/efi_parser.c                       |  112 ++++++++++++++++++
 certs/internal.h                         |   18 +++
 certs/load_uefi.c                        |  192 ++++++++++++++++++++++++++++++
 certs/system_keyring.c                   |   33 +++++
 crypto/asymmetric_keys/pkcs7_parser.h    |    1 
 crypto/asymmetric_keys/pkcs7_verify.c    |   32 ++++-
 crypto/asymmetric_keys/x509_parser.h     |    1 
 crypto/asymmetric_keys/x509_public_key.c |   15 ++
 include/keys/system_keyring.h            |   12 ++
 include/linux/efi.h                      |   36 ++++++
 16 files changed, 685 insertions(+), 8 deletions(-)
 create mode 100644 certs/blacklist.c
 create mode 100644 certs/blacklist.h
 create mode 100644 certs/blacklist_hashes.c
 create mode 100644 certs/blacklist_nohashes.c
 create mode 100644 certs/efi_parser.c
 create mode 100644 certs/internal.h
 create mode 100644 certs/load_uefi.c
