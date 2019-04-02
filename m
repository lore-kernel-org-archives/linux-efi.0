From: Claudio Carvalho <cclaudio@linux.ibm.com>
Subject: [PATCH 2/4] powerpc/powernv: Add support for OPAL secure variables
Date: Tue,  2 Apr 2019 15:15:03 -0300
Message-ID: <20190402181505.25037-3-cclaudio@linux.ibm.com>
References: <20190402181505.25037-1-cclaudio@linux.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190402181505.25037-1-cclaudio@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linuxppc-dev@ozlabs.org, linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michael Ellerman <mpe@ellerman.id.au>, Paul Mackerras <paulus@samba.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jeremy Kerr <jk@ozlabs.org>, Matthew Garret <matthew.garret@nebula.com>, Claudio Carvalho <cclaudio@linux.ibm.com>, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org

The X.509 certificates trusted by the platform and other information
required to secure boot the host OS kernel are wrapped in secure
variables, which are controlled by OPAL.

The OPAL secure variables can be handled through the following OPAL
calls.

OPAL_SECVAR_GET:
Returns the data for a given secure variable name and vendor GUID.

OPAL_SECVAR_GET_NEXT:
For a given secure variable, it returns the name and vendor GUID
of the next variable.

OPAL_SECVAR_ENQUEUE:
Enqueue the supplied secure variable update so that it can be processed
by OPAL in the next boot. Variable updates cannot be be processed right
away because the variable storage is write locked at runtime.

OPAL_SECVAR_INFO:
Returns size information about the variable.

This patch adds support for OPAL secure variables by setting up the EFI
runtime variable services to make OPAL calls.

This patch also introduces CONFIG_OPAL_SECVAR for enabling the OPAL
secure variables support in the kernel. Since CONFIG_OPAL_SECVAR selects
CONFIG_EFI, it also allow us to manage the OPAL secure variables from
userspace via efivarfs.

Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
---
This patch depends on new OPAL calls that are being added to skiboot.
The patch set that implements the new calls has been posted to
https://patchwork.ozlabs.org/project/skiboot/list/?series=99805
---
 arch/powerpc/include/asm/opal-api.h          |   6 +-
 arch/powerpc/include/asm/opal.h              |  10 ++
 arch/powerpc/platforms/Kconfig               |   3 +
 arch/powerpc/platforms/powernv/Kconfig       |   9 +
 arch/powerpc/platforms/powernv/Makefile      |   1 +
 arch/powerpc/platforms/powernv/opal-call.c   |   4 +
 arch/powerpc/platforms/powernv/opal-secvar.c | 179 +++++++++++++++++++
 7 files changed, 211 insertions(+), 1 deletion(-)
 create mode 100644 arch/powerpc/platforms/powernv/opal-secvar.c

diff --git a/arch/powerpc/include/asm/opal-api.h b/arch/powerpc/include/asm/opal-api.h
index 870fb7b239ea..d3066f29cb7a 100644
--- a/arch/powerpc/include/asm/opal-api.h
+++ b/arch/powerpc/include/asm/opal-api.h
@@ -210,7 +210,11 @@
 #define OPAL_PCI_GET_PBCQ_TUNNEL_BAR		164
 #define OPAL_PCI_SET_PBCQ_TUNNEL_BAR		165
 #define	OPAL_NX_COPROC_INIT			167
-#define OPAL_LAST				167
+#define OPAL_SECVAR_GET				170
+#define OPAL_SECVAR_GET_NEXT			171
+#define OPAL_SECVAR_ENQUEUE			172
+#define OPAL_SECVAR_INFO			173
+#define OPAL_LAST				173
 
 #define QUIESCE_HOLD			1 /* Spin all calls at entry */
 #define QUIESCE_REJECT			2 /* Fail all calls with OPAL_BUSY */
diff --git a/arch/powerpc/include/asm/opal.h b/arch/powerpc/include/asm/opal.h
index a55b01c90bb1..fdfd8dd7b326 100644
--- a/arch/powerpc/include/asm/opal.h
+++ b/arch/powerpc/include/asm/opal.h
@@ -385,6 +385,16 @@ void opal_powercap_init(void);
 void opal_psr_init(void);
 void opal_sensor_groups_init(void);
 
+extern int opal_secvar_get(uint64_t name, uint64_t vendor, uint64_t attr,
+			   uint64_t data_size, uint64_t data);
+extern int opal_secvar_get_next(uint64_t name_size, uint64_t name,
+				uint64_t vendor);
+extern int opal_secvar_enqueue(uint64_t name, uint64_t vendor, uint64_t attr,
+			       uint64_t data_size, uint64_t data);
+extern int opal_secvar_info(uint64_t attr, uint64_t storage_space,
+			    uint64_t remaining_space,
+			    uint64_t max_variable_size);
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_POWERPC_OPAL_H */
diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index f3fb79fccc72..8e30510bc0c1 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -326,4 +326,7 @@ config XILINX_PCI
 	bool "Xilinx PCI host bridge support"
 	depends on PCI && XILINX_VIRTEX
 
+config EFI
+	bool
+
 endmenu
diff --git a/arch/powerpc/platforms/powernv/Kconfig b/arch/powerpc/platforms/powernv/Kconfig
index 850eee860cf2..879f8e766098 100644
--- a/arch/powerpc/platforms/powernv/Kconfig
+++ b/arch/powerpc/platforms/powernv/Kconfig
@@ -47,3 +47,12 @@ config PPC_VAS
 	  VAS adapters are found in POWER9 based systems.
 
 	  If unsure, say N.
+
+config OPAL_SECVAR
+	bool "OPAL Secure Variables"
+	depends on PPC_POWERNV && !CPU_BIG_ENDIAN
+	select UCS2_STRING
+	select EFI
+	help
+	  This enables the kernel to access OPAL secure variables via EFI
+	  runtime variable services.
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
index daad8c45c8e7..8c791c4c187b 100644
--- a/arch/powerpc/platforms/powernv/opal-call.c
+++ b/arch/powerpc/platforms/powernv/opal-call.c
@@ -282,3 +282,7 @@ OPAL_CALL(opal_pci_set_pbcq_tunnel_bar,		OPAL_PCI_SET_PBCQ_TUNNEL_BAR);
 OPAL_CALL(opal_sensor_read_u64,			OPAL_SENSOR_READ_U64);
 OPAL_CALL(opal_sensor_group_enable,		OPAL_SENSOR_GROUP_ENABLE);
 OPAL_CALL(opal_nx_coproc_init,			OPAL_NX_COPROC_INIT);
+OPAL_CALL(opal_secvar_get,			OPAL_SECVAR_GET);
+OPAL_CALL(opal_secvar_get_next,			OPAL_SECVAR_GET_NEXT);
+OPAL_CALL(opal_secvar_enqueue,			OPAL_SECVAR_ENQUEUE);
+OPAL_CALL(opal_secvar_info,			OPAL_SECVAR_INFO)
diff --git a/arch/powerpc/platforms/powernv/opal-secvar.c b/arch/powerpc/platforms/powernv/opal-secvar.c
new file mode 100644
index 000000000000..e333828bd0bc
--- /dev/null
+++ b/arch/powerpc/platforms/powernv/opal-secvar.c
@@ -0,0 +1,179 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * PowerNV code for secure variables
+ *
+ * Copyright (C) 2019 IBM Corporation
+ * Author: Claudio Carvalho <cclaudio@linux.ibm.com>
+ *
+ */
+#define pr_fmt(fmt) "secvar: "fmt
+
+#include <linux/efi.h>
+#include <asm/machdep.h>
+#include <asm/opal.h>
+
+static bool opal_secvar_supported;
+
+static efi_status_t opal_to_efi_status_log(int rc, const char *func_name)
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
+static efi_status_t
+opal_get_variable(efi_char16_t *name, efi_guid_t *vendor, u32 *attr,
+		  unsigned long *data_size, void *data)
+{
+	int rc;
+
+	if (!opal_secvar_supported)
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
+
+static efi_status_t
+opal_get_next_variable(unsigned long *name_size, efi_char16_t *name,
+		       efi_guid_t *vendor)
+{
+	int rc;
+
+	if (!opal_secvar_supported)
+		return EFI_UNSUPPORTED;
+
+	*name_size = cpu_to_be64(*name_size);
+
+	rc = opal_secvar_get_next(__pa(name_size), __pa(name),
+				  __pa(vendor));
+
+	*name_size = be64_to_cpu(*name_size);
+
+	return opal_to_efi_status(rc);
+}
+
+static efi_status_t
+opal_set_variable(efi_char16_t *name, efi_guid_t *vendor, u32 attr,
+		  unsigned long data_size, void *data)
+{
+	int rc;
+
+	if (!opal_secvar_supported)
+		return EFI_UNSUPPORTED;
+	/*
+	 * The secure variable update must be enqueued in order to be processed
+	 * in the next boot by firmware. The secure variable storage is write
+	 * locked at runtime.
+	 */
+	rc = opal_secvar_enqueue(__pa(name), __pa(vendor), attr,
+				 data_size, __pa(data));
+	return opal_to_efi_status(rc);
+}
+
+static efi_status_t
+opal_query_variable_info(u32 attr, u64 *storage_space, u64 *remaining_space,
+			 u64 *max_variable_size)
+{
+	int rc;
+
+	if (!opal_secvar_supported)
+		return EFI_UNSUPPORTED;
+
+	*storage_space = cpu_to_be64p(storage_space);
+	*remaining_space = cpu_to_be64p(remaining_space);
+	*max_variable_size = cpu_to_be64p(max_variable_size);
+
+	rc = opal_secvar_info(attr, __pa(storage_space), __pa(remaining_space),
+			      __pa(max_variable_size));
+
+	*storage_space = be64_to_cpup(storage_space);
+	*remaining_space = be64_to_cpup(remaining_space);
+	*max_variable_size = be64_to_cpup(max_variable_size);
+
+	return opal_to_efi_status(rc);
+}
+
+static void pnv_efi_runtime_setup(void)
+{
+	/*
+	 * The opal wrappers below treat the @name, @vendor, and @data
+	 * parameters as little endian blobs.
+	 * @name is a ucs2 string
+	 * @vendor is the vendor GUID. It is converted to LE in the kernel
+	 * @data variable data, which layout may be different for each variable
+	 */
+	efi.get_variable = opal_get_variable;
+	efi.get_next_variable = opal_get_next_variable;
+	efi.set_variable = opal_set_variable;
+	efi.query_variable_info = opal_query_variable_info;
+
+	if (!opal_check_token(OPAL_SECVAR_GET) ||
+	    !opal_check_token(OPAL_SECVAR_GET_NEXT) ||
+	    !opal_check_token(OPAL_SECVAR_ENQUEUE) ||
+	    !opal_check_token(OPAL_SECVAR_INFO)) {
+		pr_err("OPAL doesn't support secure variables\n");
+		opal_secvar_supported = false;
+	} else {
+		opal_secvar_supported = true;
+	}
+}
+
+static int __init pnv_efi_init(void)
+{
+	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+	set_bit(EFI_BOOT, &efi.flags);
+
+	if (IS_ENABLED(CONFIG_64BIT))
+		set_bit(EFI_64BIT, &efi.flags);
+
+	pnv_efi_runtime_setup();
+	return 0;
+}
+machine_arch_initcall(powernv, pnv_efi_init);
-- 
2.20.1
