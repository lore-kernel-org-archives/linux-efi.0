From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 0/3] constify firmware attribute_group structures.
Date: Thu,  3 Aug 2017 19:07:21 +0530
Message-ID: <1501767444-27873-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas_Warzecha@dell.com, matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

attribute_group are not supposed to change at runtime. All functions
working with attribute_group provided by <linux/sysfs.h> work with
const attribute_group. So mark the non-const structs as const.

Arvind Yadav (3):
  [PATCH 1/3] firmware: dcdbas: constify attribute_group structures.
  [PATCH 2/3] firmware: efi: constify attribute_group structures.
  [PATCH 3/3] firmware: efi: esrt: constify attribute_group structures.

 drivers/firmware/dcdbas.c   | 2 +-
 drivers/firmware/efi/efi.c  | 2 +-
 drivers/firmware/efi/esrt.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

-- 
1.9.1
