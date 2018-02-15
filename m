From: Joe Konno <joe.konno@linux.intel.com>
Subject: [PATCH 0/2] efivars: reading variables can generate SMIs
Date: Thu, 15 Feb 2018 10:22:06 -0800
Message-ID: <20180215182208.35003-1-joe.konno@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ard.biesheuvel@linaro.org, matthew.garrett@nebula.com, jk@ozlabs.org, ak@linux.intel.com, tony.luck@intel.com
List-Id: linux-efi@vger.kernel.org

From: Joe Konno <joe.konno@intel.com>

It was pointed out that normal, unprivileged users reading certain EFI
variables (through efivarfs) can generate SMIs. Given these nodes are created
with 0644 permissions, normal users could generate a lot of SMIs. By
restricting permissions a bit (patch 1), we can make it harder for normal users
to generate spurious SMIs.

A normal user could generate lots of SMIs by reading the efivarfs in a trivial
loop:

```
while true; do
    cat /sys/firmware/efi/evivars/* > /dev/null
done
```

Patch 1 in this series limits read and write permissions on efivarfs to the
owner/superuser. Group and world cannot access.

Patch 2 is for consistency and hygiene. If we restrict permissions for either
efivarfs or efi/vars, the other interface should get the same treatment.

Joe Konno (2):
  fs/efivarfs: restrict inode permissions
  efi: restrict top-level attribute permissions

 drivers/firmware/efi/efi.c | 10 ++++++----
 fs/efivarfs/super.c        |  4 ++--
 2 files changed, 8 insertions(+), 6 deletions(-)

-- 
2.14.1
