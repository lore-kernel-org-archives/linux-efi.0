From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/4] Using the hash in MOKx to blacklist kernel module
Date: Wed, 29 Nov 2017 22:11:35 +0800
Message-ID: <20171129141139.20088-1-jlee@suse.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-fs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This patch set is base on the efi-lock-down and keys-uefi branchs in
David Howells's linux-fs git tree. The main purpose is using the MOKx
to blacklist kernel module.

As the MOK (Machine Owner Key), MOKx is a EFI boot time variable which
is maintained by shim boot loader. We can enroll the hash of blacklisted
kernel module (with or without signature) to MOKx by mokutil. Kernel loads
the hash from MOKx to blacklist keyring when booting. Kernel will prevent
to load the kernel module when its hash be found in blacklist.

This function is useful to revoke a kernel module that it has exploit. Or
revoking a kernel module that it was signed by a unsecure key.

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
