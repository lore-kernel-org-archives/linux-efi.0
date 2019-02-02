From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 06/10] efi: replace GPL license boilerplate with SPDX headers
Date: Sat,  2 Feb 2019 10:41:15 +0100
Message-ID: <20190202094119.13230-7-ard.biesheuvel@linaro.org>
References: <20190202094119.13230-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190202094119.13230-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, AKASHI Takahiro <takahiro.akashi@linaro.org>, Alexander Graf <agraf@suse.de>, Bjorn Andersson <bjorn.andersson@linaro.org>, Borislav Petkov <bp@alien8.de>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Jeffrey Hugo <jhugo@codeaurora.org>, Lee Jones <lee.jones@linaro.org>, Leif Lindholm <leif.lindholm@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Jones <pjones@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

Replace all GPL license blurbs with an equivalent SPDX header (most
files are GPLv2, some are GPLv2+). While at it, drop some outdated
header changelogs as well.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/apple-properties.c       | 13 +----
 drivers/firmware/efi/arm-init.c               |  6 +-
 drivers/firmware/efi/arm-runtime.c            |  6 +-
 drivers/firmware/efi/capsule-loader.c         |  4 +-
 drivers/firmware/efi/capsule.c                |  4 +-
 drivers/firmware/efi/cper-arm.c               | 14 +----
 drivers/firmware/efi/cper.c                   | 14 +----
 drivers/firmware/efi/dev-path-parser.c        |  9 +--
 drivers/firmware/efi/efi-bgrt.c               |  5 +-
 drivers/firmware/efi/efi-pstore.c             |  2 +
 drivers/firmware/efi/efibc.c                  | 10 +---
 drivers/firmware/efi/efivars.c                | 58 +------------------
 drivers/firmware/efi/esrt.c                   |  1 +
 drivers/firmware/efi/fake_mem.c               | 16 +----
 drivers/firmware/efi/libstub/arm32-stub.c     |  6 +-
 drivers/firmware/efi/libstub/arm64-stub.c     |  6 +-
 .../firmware/efi/libstub/efi-stub-helper.c    |  5 +-
 drivers/firmware/efi/libstub/fdt.c            |  5 +-
 drivers/firmware/efi/libstub/gop.c            |  4 +-
 drivers/firmware/efi/libstub/random.c         |  6 +-
 drivers/firmware/efi/libstub/secureboot.c     |  4 +-
 drivers/firmware/efi/libstub/tpm.c            |  4 +-
 drivers/firmware/efi/memattr.c                |  5 +-
 drivers/firmware/efi/runtime-map.c            |  3 +-
 drivers/firmware/efi/test/efi_test.c          |  1 +
 drivers/firmware/efi/test/efi_test.h          |  2 +-
 drivers/firmware/efi/tpm.c                    |  5 +-
 drivers/firmware/efi/vars.c                   | 15 +----
 28 files changed, 29 insertions(+), 204 deletions(-)

diff --git a/drivers/firmware/efi/apple-properties.c b/drivers/firmware/efi/apple-properties.c
index ac1654f74dc7..0e206c9e0d7a 100644
--- a/drivers/firmware/efi/apple-properties.c
+++ b/drivers/firmware/efi/apple-properties.c
@@ -1,19 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * apple-properties.c - EFI device properties on Macs
  * Copyright (C) 2016 Lukas Wunner <lukas@wunner.de>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License (version 2) as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses/>.
- *
  * Note, all properties are considered as u8 arrays.
  * To get a value of any of them the caller must use device_property_read_u8_array().
  */
diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index 1a6a77df8a5e..311cd349a862 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -1,14 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Extensible Firmware Interface
  *
  * Based on Extensible Firmware Interface Specification version 2.4
  *
  * Copyright (C) 2013 - 2015 Linaro Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
  */
 
 #define pr_fmt(fmt)	"efi: " fmt
diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 23ea1ed409d1..19ab3ad9cbba 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -1,14 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Extensible Firmware Interface
  *
  * Based on Extensible Firmware Interface Specification version 2.4
  *
  * Copyright (C) 2013, 2014 Linaro Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
  */
 
 #include <linux/dmi.h>
diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 96688986da56..b1395133389e 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -1,10 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * EFI capsule loader driver.
  *
  * Copyright 2015 Intel Corporation
- *
- * This file is part of the Linux kernel, and is made available under
- * the terms of the GNU General Public License version 2.
  */
 
 #define pr_fmt(fmt) "efi: " fmt
diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
index 4938c29b7c5d..598b7800d14e 100644
--- a/drivers/firmware/efi/capsule.c
+++ b/drivers/firmware/efi/capsule.c
@@ -1,10 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * EFI capsule support.
  *
  * Copyright 2013 Intel Corporation; author Matt Fleming
- *
- * This file is part of the Linux kernel, and is made available under
- * the terms of the GNU General Public License version 2.
  */
 
 #define pr_fmt(fmt) "efi: " fmt
diff --git a/drivers/firmware/efi/cper-arm.c b/drivers/firmware/efi/cper-arm.c
index 502811344e81..36d3b8b9da47 100644
--- a/drivers/firmware/efi/cper-arm.c
+++ b/drivers/firmware/efi/cper-arm.c
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * UEFI Common Platform Error Record (CPER) support
  *
  * Copyright (C) 2017, The Linux Foundation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License version
- * 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index a7902fccdcfa..6a966ecdd80a 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * UEFI Common Platform Error Record (CPER) support
  *
@@ -9,19 +10,6 @@
  *
  * For more information about CPER, please refer to Appendix N of UEFI
  * Specification version 2.4.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License version
- * 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/firmware/efi/dev-path-parser.c b/drivers/firmware/efi/dev-path-parser.c
index 85d1834ee9b7..85ec99f97841 100644
--- a/drivers/firmware/efi/dev-path-parser.c
+++ b/drivers/firmware/efi/dev-path-parser.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * dev-path-parser.c - EFI Device Path parser
  * Copyright (C) 2016 Lukas Wunner <lukas@wunner.de>
@@ -5,14 +6,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License (version 2) as
  * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <linux/acpi.h>
diff --git a/drivers/firmware/efi/efi-bgrt.c b/drivers/firmware/efi/efi-bgrt.c
index b22ccfb0c991..a2384184a7de 100644
--- a/drivers/firmware/efi/efi-bgrt.c
+++ b/drivers/firmware/efi/efi-bgrt.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright 2012 Intel Corporation
  * Author: Josh Triplett <josh@joshtriplett.org>
@@ -5,10 +6,6 @@
  * Based on the bgrt driver:
  * Copyright 2012 Red Hat, Inc <mjg@redhat.com>
  * Author: Matthew Garrett
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 0f7d97917197..9ea13e8d12ec 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0+
+
 #include <linux/efi.h>
 #include <linux/module.h>
 #include <linux/pstore.h>
diff --git a/drivers/firmware/efi/efibc.c b/drivers/firmware/efi/efibc.c
index 503bbe2a9d49..61e099826cbb 100644
--- a/drivers/firmware/efi/efibc.c
+++ b/drivers/firmware/efi/efibc.c
@@ -1,15 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * efibc: control EFI bootloaders which obey LoaderEntryOneShot var
  * Copyright (c) 2013-2016, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
  */
 
 #define pr_fmt(fmt) "efibc: " fmt
diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 8061667a6765..7576450c8254 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * Originally from efivars.c,
  *
@@ -6,63 +7,6 @@
  *
  * This code takes all variables accessible from EFI runtime and
  *  exports them via sysfs
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- * Changelog:
- *
- *  17 May 2004 - Matt Domsch <Matt_Domsch@dell.com>
- *   remove check for efi_enabled in exit
- *   add MODULE_VERSION
- *
- *  26 Apr 2004 - Matt Domsch <Matt_Domsch@dell.com>
- *   minor bug fixes
- *
- *  21 Apr 2004 - Matt Tolentino <matthew.e.tolentino@intel.com)
- *   converted driver to export variable information via sysfs
- *   and moved to drivers/firmware directory
- *   bumped revision number to v0.07 to reflect conversion & move
- *
- *  10 Dec 2002 - Matt Domsch <Matt_Domsch@dell.com>
- *   fix locking per Peter Chubb's findings
- *
- *  25 Mar 2002 - Matt Domsch <Matt_Domsch@dell.com>
- *   move uuid_unparse() to include/asm-ia64/efi.h:efi_guid_to_str()
- *
- *  12 Feb 2002 - Matt Domsch <Matt_Domsch@dell.com>
- *   use list_for_each_safe when deleting vars.
- *   remove ifdef CONFIG_SMP around include <linux/smp.h>
- *   v0.04 release to linux-ia64@linuxia64.org
- *
- *  20 April 2001 - Matt Domsch <Matt_Domsch@dell.com>
- *   Moved vars from /proc/efi to /proc/efi/vars, and made
- *   efi.c own the /proc/efi directory.
- *   v0.03 release to linux-ia64@linuxia64.org
- *
- *  26 March 2001 - Matt Domsch <Matt_Domsch@dell.com>
- *   At the request of Stephane, moved ownership of /proc/efi
- *   to efi.c, and now efivars lives under /proc/efi/vars.
- *
- *  12 March 2001 - Matt Domsch <Matt_Domsch@dell.com>
- *   Feedback received from Stephane Eranian incorporated.
- *   efivar_write() checks copy_from_user() return value.
- *   efivar_read/write() returns proper errno.
- *   v0.02 release to linux-ia64@linuxia64.org
- *
- *  26 February 2001 - Matt Domsch <Matt_Domsch@dell.com>
- *   v0.01 release to linux-ia64@linuxia64.org
  */
 
 #include <linux/efi.h>
diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
index 5d06bd247d07..d6dd5f503fa2 100644
--- a/drivers/firmware/efi/esrt.c
+++ b/drivers/firmware/efi/esrt.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * esrt.c
  *
diff --git a/drivers/firmware/efi/fake_mem.c b/drivers/firmware/efi/fake_mem.c
index 6c7d60c239b5..9501edc0fcfb 100644
--- a/drivers/firmware/efi/fake_mem.c
+++ b/drivers/firmware/efi/fake_mem.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * fake_mem.c
  *
@@ -8,21 +9,6 @@
  * By specifying this parameter, you can add arbitrary attribute to
  * specific memory range by updating original (firmware provided) EFI
  * memmap.
- *
- *  This program is free software; you can redistribute it and/or modify it
- *  under the terms and conditions of the GNU General Public License,
- *  version 2, as published by the Free Software Foundation.
- *
- *  This program is distributed in the hope it will be useful, but WITHOUT
- *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- *  more details.
- *
- *  You should have received a copy of the GNU General Public License along with
- *  this program; if not, see <http://www.gnu.org/licenses/>.
- *
- *  The full GNU General Public License is included in this distribution in
- *  the file called "COPYING".
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware/efi/libstub/arm32-stub.c
index becbda445913..e8f7aefb6813 100644
--- a/drivers/firmware/efi/libstub/arm32-stub.c
+++ b/drivers/firmware/efi/libstub/arm32-stub.c
@@ -1,10 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2013 Linaro Ltd;  <roy.franz@linaro.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
  */
 #include <linux/efi.h>
 #include <asm/efi.h>
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index 1b4d465cc5d9..1550d244e996 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -1,13 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2013, 2014 Linaro Ltd;  <roy.franz@linaro.org>
  *
  * This file implements the EFI boot stub for the arm64 kernel.
  * Adapted from ARM version by Mark Salter <msalter@redhat.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
  */
 
 /*
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index e94975f4655b..8f2d000bec75 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -1,13 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Helper functions used by the EFI stub on multiple
  * architectures. This should be #included by the EFI stub
  * implementation files.
  *
  * Copyright 2011 Intel Corporation; author Matt Fleming
- *
- * This file is part of the Linux kernel, and is made available
- * under the terms of the GNU General Public License version 2.
- *
  */
 
 #include <linux/efi.h>
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index d474964b873b..7cfc51935c4b 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -1,13 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * FDT related Helper functions used by the EFI stub on multiple
  * architectures. This should be #included by the EFI stub
  * implementation files.
  *
  * Copyright 2013 Linaro Limited; author Roy Franz
- *
- * This file is part of the Linux kernel, and is made available
- * under the terms of the GNU General Public License version 2.
- *
  */
 
 #include <linux/efi.h>
diff --git a/drivers/firmware/efi/libstub/gop.c b/drivers/firmware/efi/libstub/gop.c
index 24c461dea7af..0101ca4c13b1 100644
--- a/drivers/firmware/efi/libstub/gop.c
+++ b/drivers/firmware/efi/libstub/gop.c
@@ -1,10 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /* -----------------------------------------------------------------------
  *
  *   Copyright 2011 Intel Corporation; author Matt Fleming
  *
- *   This file is part of the Linux kernel, and is made available under
- *   the terms of the GNU General Public License version 2.
- *
  * ----------------------------------------------------------------------- */
 
 #include <linux/efi.h>
diff --git a/drivers/firmware/efi/libstub/random.c b/drivers/firmware/efi/libstub/random.c
index e0e603a89aa9..b4b1d1dcb5fd 100644
--- a/drivers/firmware/efi/libstub/random.c
+++ b/drivers/firmware/efi/libstub/random.c
@@ -1,10 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2016 Linaro Ltd;  <ard.biesheuvel@linaro.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
  */
 
 #include <linux/efi.h>
diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
index 72d9dfbebf08..edba5e7a3743 100644
--- a/drivers/firmware/efi/libstub/secureboot.c
+++ b/drivers/firmware/efi/libstub/secureboot.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Secure boot handling.
  *
@@ -5,9 +6,6 @@
  *     Roy Franz <roy.franz@linaro.org
  * Copyright (C) 2013 Red Hat, Inc.
  *     Mark Salter <msalter@redhat.com>
- *
- * This file is part of the Linux kernel, and is made available under the
- * terms of the GNU General Public License version 2.
  */
 #include <linux/efi.h>
 #include <asm/efi.h>
diff --git a/drivers/firmware/efi/libstub/tpm.c b/drivers/firmware/efi/libstub/tpm.c
index a90b0b8fc69a..5bd04f75d8d6 100644
--- a/drivers/firmware/efi/libstub/tpm.c
+++ b/drivers/firmware/efi/libstub/tpm.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * TPM handling.
  *
@@ -5,9 +6,6 @@
  * Copyright (C) 2017 Google, Inc.
  *     Matthew Garrett <mjg59@google.com>
  *     Thiebaud Weksteen <tweek@google.com>
- *
- * This file is part of the Linux kernel, and is made available under the
- * terms of the GNU General Public License version 2.
  */
 #include <linux/efi.h>
 #include <linux/tpm_eventlog.h>
diff --git a/drivers/firmware/efi/memattr.c b/drivers/firmware/efi/memattr.c
index aac972b056d9..58452fde92cc 100644
--- a/drivers/firmware/efi/memattr.c
+++ b/drivers/firmware/efi/memattr.c
@@ -1,9 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2016 Linaro Ltd. <ard.biesheuvel@linaro.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #define pr_fmt(fmt)	"efi: memattr: " fmt
diff --git a/drivers/firmware/efi/runtime-map.c b/drivers/firmware/efi/runtime-map.c
index 84a11d0a8023..ad9ddefc9dcb 100644
--- a/drivers/firmware/efi/runtime-map.c
+++ b/drivers/firmware/efi/runtime-map.c
@@ -1,8 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * linux/drivers/efi/runtime-map.c
  * Copyright (C) 2013 Red Hat, Inc., Dave Young <dyoung@redhat.com>
- *
- * This file is released under the GPLv2.
  */
 
 #include <linux/string.h>
diff --git a/drivers/firmware/efi/test/efi_test.c b/drivers/firmware/efi/test/efi_test.c
index 51ecf7d6da48..877745c3aaf2 100644
--- a/drivers/firmware/efi/test/efi_test.c
+++ b/drivers/firmware/efi/test/efi_test.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * EFI Test Driver for Runtime Services
  *
diff --git a/drivers/firmware/efi/test/efi_test.h b/drivers/firmware/efi/test/efi_test.h
index 5f4818bf112f..f2446aa1c2e3 100644
--- a/drivers/firmware/efi/test/efi_test.h
+++ b/drivers/firmware/efi/test/efi_test.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * EFI Test driver Header
  *
diff --git a/drivers/firmware/efi/tpm.c b/drivers/firmware/efi/tpm.c
index 0cbeb3d46b18..3a689b40ccc0 100644
--- a/drivers/firmware/efi/tpm.c
+++ b/drivers/firmware/efi/tpm.c
@@ -1,10 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2017 Google, Inc.
  *     Thiebaud Weksteen <tweek@google.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #include <linux/efi.h>
diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index fceaafd67ec6..436d1776bc7b 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -1,22 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * Originally from efivars.c
  *
  * Copyright (C) 2001,2003,2004 Dell <Matt_Domsch@dell.com>
  * Copyright (C) 2004 Intel Corporation <matthew.e.tolentino@intel.com>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #include <linux/capability.h>
-- 
2.17.1
