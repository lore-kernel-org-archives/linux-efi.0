From: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>
Subject: [PATCH v2 0/3] pstore: resend three patches
Date: Sat,  7 Nov 2015 12:43:46 +0800
Message-ID: <cover.1446869434.git.geliangtang@163.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

I sent these patches a few weeks ago. Due to the recent changes in pstore,
these patched might not apply anymore. So I refresh and resend them.

---
Changes in v2:
 - refresh the patches.
---

Geliang Tang (3):
  pstore: check PSTORE_FLAGS_FRAGILE in pstore_unregister
  efi-pstore: implement efivars_pstore_exit()
  pstore: drop file opened reference count

 drivers/firmware/efi/efi-pstore.c | 7 +++++++
 fs/pstore/inode.c                 | 1 -
 fs/pstore/platform.c              | 9 ++++++---
 3 files changed, 13 insertions(+), 4 deletions(-)

-- 
2.5.0
