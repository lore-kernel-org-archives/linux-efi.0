From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH 0/4] Using the hash in MOKx to blacklist kernel module
Date: Wed, 29 Nov 2017 22:00:57 +0800
Message-ID: <20171129140101.19682-1-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-fs@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

This patch set is base on the efi-lock-down and keys-uefi branchs in
David Howells's linux-fs git tree. The main purpose is using the MOKx
to blacklist kernel module.

As the MOK (Machine Owner Key), MOKx is a EFI boot time variable which
is maintained by shim boot loader. We can enroll the hash of blacklisted
kernel module (with or without signature) to MOKx by mokutil. Kernel loads
the hash from MOKx to blacklist keyring when booting. Kernel will prevent
to load the kernel module when its hash be found in blacklist.

Except MOKx, this patch set fixs another two issues: The MOK/MOKx should
not be loaded when secure boot is disabled. And, modified error message
prints out appropriate status string for reading by human being.

Lee, Chun-Yi (4):
  MODSIGN: do not load mok when secure boot disabled
  MODSIGN: print appropriate status message when getting UEFI
    certificates list
  MODSIGN: load blacklist from MOKx
  MODSIGN: checking the blacklisted hash before loading a kernel module

 certs/load_uefi.c       | 71 +++++++++++++++++++++++++++++++++++--------------
 include/linux/efi.h     | 25 +++++++++++++++++
 kernel/module_signing.c | 62 ++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 136 insertions(+), 22 deletions(-)

-- 
2.10.2
