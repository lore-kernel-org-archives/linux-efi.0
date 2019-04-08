Return-Path: <SRS0=QuFd=SK=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3FC8C10F13
	for <linux-efi@archiver.kernel.org>; Mon,  8 Apr 2019 22:53:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82B4420857
	for <linux-efi@archiver.kernel.org>; Mon,  8 Apr 2019 22:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbfDHWxC (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 8 Apr 2019 18:53:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40428 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726352AbfDHWw5 (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Mon, 8 Apr 2019 18:52:57 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x38MnHws079221
        for <linux-efi@vger.kernel.org>; Mon, 8 Apr 2019 18:52:55 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2rrckqxcq3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-efi@vger.kernel.org>; Mon, 08 Apr 2019 18:52:55 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-efi@vger.kernel.org> from <nayna@linux.ibm.com>;
        Mon, 8 Apr 2019 23:52:54 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 8 Apr 2019 23:52:50 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x38Mqnj044892400
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Apr 2019 22:52:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C5E84C04E;
        Mon,  8 Apr 2019 22:52:49 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B8364C044;
        Mon,  8 Apr 2019 22:52:47 +0000 (GMT)
Received: from swastik.ibm.com (unknown [9.85.157.39])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Apr 2019 22:52:47 +0000 (GMT)
From:   Nayna Jain <nayna@linux.ibm.com>
To:     linuxppc-dev@ozlabs.org, linux-efi@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Jeremy Kerr <jk@ozlabs.org>,
        Matthew Garret <matthew.garret@nebula.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Claudio Carvalho <cclaudio@linux.ibm.com>,
        Nayna Jain <nayna@linux.ibm.com>
Subject: [PATCH v2 1/3] powerpc/powernv: Add support for OPAL_SECVAR_GET
Date:   Mon,  8 Apr 2019 18:52:32 -0400
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1554763954-11795-1-git-send-email-nayna@linux.ibm.com>
References: <1554763954-11795-1-git-send-email-nayna@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19040822-0028-0000-0000-0000035EAF08
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19040822-0029-0000-0000-0000241DCA9A
Message-Id: <1554763954-11795-2-git-send-email-nayna@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-08_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904080164
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20190408225232._VGqqDlsgi22qcCGVxr2WQEakrL0wcRx11NLYVhk_1k@z>

From: Claudio Carvalho <cclaudio@linux.ibm.com>

The X.509 certificates trusted by the platform and other information
required to secure boot the OS kernel are wrapped in secure variables,
which are controlled by OPAL.

This patch adds support to read OPAL secure variables through
OPAL_SECVAR_GET call. It returns the data for a given secure variable
and vendor GUID. It can be configured using CONFIG_OPAL_SECVAR.

Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>

---
This patch depends on a new OPAL call that is being added to skiboot.
The patch set that implements the new call has been posted to
https://patchwork.ozlabs.org/project/skiboot/list/?series=99805
---
 arch/powerpc/include/asm/opal-api.h          |   3 +-
 arch/powerpc/include/asm/opal-secvar.h       |  18 ++++
 arch/powerpc/include/asm/opal.h              |   2 +
 arch/powerpc/platforms/powernv/Kconfig       |   6 ++
 arch/powerpc/platforms/powernv/Makefile      |   1 +
 arch/powerpc/platforms/powernv/opal-call.c   |   1 +
 arch/powerpc/platforms/powernv/opal-secvar.c | 107 +++++++++++++++++++
 7 files changed, 137 insertions(+), 1 deletion(-)
 create mode 100644 arch/powerpc/include/asm/opal-secvar.h
 create mode 100644 arch/powerpc/platforms/powernv/opal-secvar.c

diff --git a/arch/powerpc/include/asm/opal-api.h b/arch/powerpc/include/asm/opal-api.h
index 870fb7b239ea..782eb20a08a7 100644
--- a/arch/powerpc/include/asm/opal-api.h
+++ b/arch/powerpc/include/asm/opal-api.h
@@ -210,7 +210,8 @@
 #define OPAL_PCI_GET_PBCQ_TUNNEL_BAR		164
 #define OPAL_PCI_SET_PBCQ_TUNNEL_BAR		165
 #define	OPAL_NX_COPROC_INIT			167
-#define OPAL_LAST				167
+#define OPAL_SECVAR_GET				170
+#define OPAL_LAST				171
 
 #define QUIESCE_HOLD			1 /* Spin all calls at entry */
 #define QUIESCE_REJECT			2 /* Fail all calls with OPAL_BUSY */
diff --git a/arch/powerpc/include/asm/opal-secvar.h b/arch/powerpc/include/asm/opal-secvar.h
new file mode 100644
index 000000000000..e3d5e4cbf3bc
--- /dev/null
+++ b/arch/powerpc/include/asm/opal-secvar.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * PowerNV definitions for secure variables OPAL API.
+ *
+ * Copyright (C) 2019 IBM Corporation
+ * Author: Claudio Carvalho <cclaudio@linux.ibm.com>
+ *
+ */
+#ifndef OPAL_SECVAR_H
+#define OPAL_SECVAR_H
+
+#include <linux/efi.h>
+
+extern efi_status_t
+opal_get_variable(efi_char16_t *name, efi_guid_t *vendor, u32 *attr,
+		  unsigned long *data_size, void *data);
+
+#endif
diff --git a/arch/powerpc/include/asm/opal.h b/arch/powerpc/include/asm/opal.h
index a55b01c90bb1..eb654baf8764 100644
--- a/arch/powerpc/include/asm/opal.h
+++ b/arch/powerpc/include/asm/opal.h
@@ -385,6 +385,8 @@ void opal_powercap_init(void);
 void opal_psr_init(void);
 void opal_sensor_groups_init(void);
 
+extern int opal_secvar_get(uint64_t name, uint64_t vendor, uint64_t attr,
+			   uint64_t data_size, uint64_t data);
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_POWERPC_OPAL_H */
diff --git a/arch/powerpc/platforms/powernv/Kconfig b/arch/powerpc/platforms/powernv/Kconfig
index 850eee860cf2..65b060539b5c 100644
--- a/arch/powerpc/platforms/powernv/Kconfig
+++ b/arch/powerpc/platforms/powernv/Kconfig
@@ -47,3 +47,9 @@ config PPC_VAS
 	  VAS adapters are found in POWER9 based systems.
 
 	  If unsure, say N.
+
+config OPAL_SECVAR
+	bool "OPAL Secure Variables"
+	depends on PPC_POWERNV
+	help
+	  This enables the kernel to access OPAL secure variables.
diff --git a/arch/powerpc/platforms/powernv/Makefile b/arch/powerpc/platforms/powernv/Makefile
index da2e99efbd04..1511d836fd19 100644
--- a/arch/powerpc/platforms/powernv/Makefile
+++ b/arch/powerpc/platforms/powernv/Makefile
@@ -16,3 +16,4 @@ obj-$(CONFIG_PERF_EVENTS) += opal-imc.o
 obj-$(CONFIG_PPC_MEMTRACE)	+= memtrace.o
 obj-$(CONFIG_PPC_VAS)	+= vas.o vas-window.o vas-debug.o
 obj-$(CONFIG_OCXL_BASE)	+= ocxl.o
+obj-$(CONFIG_OPAL_SECVAR)	+= opal-secvar.o
diff --git a/arch/powerpc/platforms/powernv/opal-call.c b/arch/powerpc/platforms/powernv/opal-call.c
index daad8c45c8e7..eafd8f690b7a 100644
--- a/arch/powerpc/platforms/powernv/opal-call.c
+++ b/arch/powerpc/platforms/powernv/opal-call.c
@@ -282,3 +282,4 @@ OPAL_CALL(opal_pci_set_pbcq_tunnel_bar,		OPAL_PCI_SET_PBCQ_TUNNEL_BAR);
 OPAL_CALL(opal_sensor_read_u64,			OPAL_SENSOR_READ_U64);
 OPAL_CALL(opal_sensor_group_enable,		OPAL_SENSOR_GROUP_ENABLE);
 OPAL_CALL(opal_nx_coproc_init,			OPAL_NX_COPROC_INIT);
+OPAL_CALL(opal_secvar_get,			OPAL_SECVAR_GET);
diff --git a/arch/powerpc/platforms/powernv/opal-secvar.c b/arch/powerpc/platforms/powernv/opal-secvar.c
new file mode 100644
index 000000000000..3ba02c9503f7
--- /dev/null
+++ b/arch/powerpc/platforms/powernv/opal-secvar.c
@@ -0,0 +1,107 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * PowerNV code for secure variables
+ *
+ * Copyright (C) 2019 IBM Corporation
+ * Author: Claudio Carvalho <cclaudio@linux.ibm.com>
+ *
+ */
+
+/*
+ * The opal wrappers in this file treat the @name, @vendor, and @data
+ * parameters as little endian blobs.
+ * @name is a ucs2 string
+ * @vendor is the vendor GUID. It is converted to LE in the kernel
+ * @data variable data, which layout may be different for each variable
+ */
+
+#define pr_fmt(fmt) "secvar: "fmt
+
+#include <linux/efi.h>
+#include <asm/machdep.h>
+#include <asm/opal.h>
+#include <asm/opal-secvar.h>
+
+static bool is_opal_secvar_supported(void)
+{
+	static bool opal_secvar_supported;
+	static bool initialized;
+
+	if (initialized)
+		return opal_secvar_supported;
+
+	if (opal_check_token(OPAL_SECVAR_GET))
+		opal_secvar_supported = true;
+	else
+		opal_secvar_supported = false;
+
+	initialized = true;
+
+	return opal_secvar_supported;
+}
+
+efi_status_t opal_to_efi_status_log(int rc, const char *func_name)
+{
+	efi_status_t status;
+
+	switch (rc) {
+	case OPAL_EMPTY:
+		status = EFI_NOT_FOUND;
+		break;
+	case OPAL_HARDWARE:
+		status = EFI_DEVICE_ERROR;
+		break;
+	case OPAL_NO_MEM:
+		pr_err("%s: No space in the volatile storage\n", func_name);
+		status = EFI_OUT_OF_RESOURCES;
+		break;
+	case OPAL_PARAMETER:
+		status = EFI_INVALID_PARAMETER;
+		break;
+	case OPAL_PARTIAL:
+		status = EFI_BUFFER_TOO_SMALL;
+		break;
+	case OPAL_PERMISSION:
+		status = EFI_WRITE_PROTECTED;
+		break;
+	case OPAL_RESOURCE:
+		pr_err("%s: No space in the non-volatile storage\n", func_name);
+		status = EFI_OUT_OF_RESOURCES;
+		break;
+	case OPAL_SUCCESS:
+		status = EFI_SUCCESS;
+		break;
+	default:
+		pr_err("%s: Unknown OPAL error %d\n", func_name, rc);
+		status = EFI_DEVICE_ERROR;
+		break;
+	}
+
+	return status;
+}
+
+#define opal_to_efi_status(rc) opal_to_efi_status_log(rc, __func__)
+
+efi_status_t
+opal_get_variable(efi_char16_t *name, efi_guid_t *vendor, u32 *attr,
+		  unsigned long *data_size, void *data)
+{
+	int rc;
+
+	if (!is_opal_secvar_supported())
+		return EFI_UNSUPPORTED;
+
+	*data_size = cpu_to_be64(*data_size);
+
+	rc = opal_secvar_get(__pa(name), __pa(vendor), __pa(attr),
+			     __pa(data_size), __pa(data));
+	/*
+	 * The @attr is an optional output parameter. It is returned in
+	 * big-endian.
+	 */
+	if (attr)
+		*attr = be32_to_cpup(attr);
+	*data_size = be64_to_cpu(*data_size);
+
+	return opal_to_efi_status(rc);
+}
-- 
2.20.1

