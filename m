Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792623970;
	b=QuxLZ8if+JjMVxPaVCCY6Fb8Tj2WjbTic31FGlW7VB80bp70Jao14zTb/dGhJ2Igt4wP
	 OWo5VURNPCw6Amtp6NXXZqJzkPzFYKymRkCpm35Ug9YTPtL6g2fsPEskDhn+kT4eICORO
	 AbkTwuZSsaNp5mKNlFbeVGoW9AoSrJggtj7oeBrQpeC1S7Z2MtQ00Off0YAGpN5mJOuGF
	 IHvX3hAeqKkgNCaVrOGGvEhKE8qMC3aMDwXNK6k0i3CsFQdWafOM4Hg4MtCpX9NbJM4uP
	 d96Pqp76eSZ74j4NW1nJLpIzBpB0I86SvRIH6CxR1H2TVdfnd2pp+3JdBQQvklF5YVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792623970;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=jCgyO2THSSzeTo0gG7Yn5h5tZcIZdnA4VdSYaVd/Des=;
	b=PKamHMzpsraUyaeMMR/dHBV0ggWblG2+6tCKaOKQhKvDO7mDoV8WoVLnYqI3B38AdQ1H
	 EYgRv7VUxaUR+kfF1+8iFwbbEdmKkTBftpRhFqTfgsedefa92f+M/f+qywdYKoixhyYQN
	 k9ApwejfR88LqOZEkoxSE+vWXJI116wb+yN04HH4bj9yLMrepGo+9W/IL2T0fgxfF6/yc
	 mNXBY3F14S4iEOWSgXryvOs4Lz2RkCpKVqPgm7g0eFsf8/aG/wg68lWKcUBrytA20osLR
	 VTh2As7HTXW4lc03dxGnauR6WgtYncgRSlHXlDETPTBfouS35aWZ566se2r6rwnQIMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=MFblbEwM;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7972B606A31F
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 23:06:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7972B606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=MFblbEwM
Received: by linux.microsoft.com (Postfix, from userid 1216)
	id 6118620B7166; Wed, 21 Oct 2026 16:06:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6118620B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792623962;
	bh=jCgyO2THSSzeTo0gG7Yn5h5tZcIZdnA4VdSYaVd/Des=;
	h=From:To:Cc:Subject:Date:From;
	b=MFblbEwMkgUMuJk3LZ7u+Ew2M+fMRN26f1vTBTqQYugaEfkBDXBxeTHIt3WW5Ss+U
	 BVwiS01Bs3wepQXPEB13dRwrkJK/Z5YMqCJid70FXTGPx3GPAuKIeJRo8HOwe0dcrn
	 RlAf1o4tm9Bh0pKv+gskCKvkS6t83N9e4HvgEau0=
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kees Cook <kees@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-arm-kernel@lists.infradead.org,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Subject: [PATCH] arm64/efi: only disable the EFI runtime service that faulted
Date: Wed, 21 Oct 2026 19:05:03 -0400
Message-ID: <20261021230503.2075618-1-hamzamahfooz@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the firmware faults while executing an EFI runtime service, arm64
recovers from the exception, returns EFI_ABORTED to the caller and
disables all EFI runtime services for the remainder of the boot.

That is a rather big hammer. For instance, on Microsoft C2141 and C4143
machines, GetTime() faults when it is called by the rtc-efi driver:

  [Firmware Bug]: Unable to handle paging request in EFI runtime service
  WARNING: CPU: 9 PID: 1 at drivers/firmware/efi/runtime-wrappers.c:498 __efi_queue_work+0xe8/0x128
  Hardware name: Microsoft C2141/C2141  , BIOS C2141.BS.0301.AG.01.03 08/21/2024
  Call trace:
   __efi_queue_work+0xe8/0x128
   virt_efi_get_time+0x64/0xc0
   efi_rtc_probe+0x4c/0x188
   platform_probe+0x70/0xd8
   really_probe+0x190/0x3d8
   ...

and as a result, the variable services become unavailable too, which
breaks efivarfs (and with it efibootmgr, fwupd etc.), even though there
is nothing wrong with them.

So, if the faulting call was made via efi_rts_wq, which is the case for
all runtime services apart from ResetSystem() and the non-blocking
variable services, only disable the service that faulted: clear its bit
in efi.runtime_supported_mask, so that callers that check for it via
efi_rt_services_supported() no longer try to use it, and fail any
further calls to it with EFI_DEVICE_ERROR, which is what all runtime
service calls return today once they have been disabled. Otherwise,
and for the ACPI PRM handlers and the LKDTM tests, which have no bit
of their own, keep disabling all runtime services.

Update the LKDTM EFI_RUNTIME_CRASH test accordingly, as the fault it
provokes in GetNextVariableName() now only disables that service.

Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
---
 arch/arm64/kernel/efi.c                 |  2 +-
 drivers/firmware/efi/runtime-wrappers.c | 85 ++++++++++++++++++++++++-
 drivers/misc/lkdtm/bugs.c               |  4 +-
 include/linux/efi.h                     |  1 +
 4 files changed, 88 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 0ec90fd17..330909d56 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -227,7 +227,7 @@ bool efi_runtime_fixup_exception(struct pt_regs *regs, const char *msg)
 
 	pr_err(FW_BUG "Unable to handle %s in EFI runtime service\n", msg);
 	add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
-	clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+	efi_runtime_disable_faulting_service();
 
 	regs->regs[0]	= EFI_ABORTED;
 	regs->regs[30]	= efi_rt_stack_top[-1];
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index eea4f32e6..221196c95 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -132,6 +132,82 @@ struct efi_runtime_work efi_rts_work;
  */
 static bool efi_rts_abandoned;
 
+/*
+ * The EFI runtime services that are called via efi_rts_wq, and their bits in
+ * efi.runtime_supported_mask.
+ */
+static const struct {
+	unsigned int	mask;
+	const char	*name;
+} efi_rts_services[] = {
+	[EFI_GET_TIME]			= { EFI_RT_SUPPORTED_GET_TIME,
+					    "GetTime" },
+	[EFI_SET_TIME]			= { EFI_RT_SUPPORTED_SET_TIME,
+					    "SetTime" },
+	[EFI_GET_WAKEUP_TIME]		= { EFI_RT_SUPPORTED_GET_WAKEUP_TIME,
+					    "GetWakeupTime" },
+	[EFI_SET_WAKEUP_TIME]		= { EFI_RT_SUPPORTED_SET_WAKEUP_TIME,
+					    "SetWakeupTime" },
+	[EFI_GET_VARIABLE]		= { EFI_RT_SUPPORTED_GET_VARIABLE,
+					    "GetVariable" },
+	[EFI_GET_NEXT_VARIABLE]		= { EFI_RT_SUPPORTED_GET_NEXT_VARIABLE_NAME,
+					    "GetNextVariableName" },
+	[EFI_SET_VARIABLE]		= { EFI_RT_SUPPORTED_SET_VARIABLE,
+					    "SetVariable" },
+	[EFI_QUERY_VARIABLE_INFO]	= { EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO,
+					    "QueryVariableInfo" },
+	[EFI_GET_NEXT_HIGH_MONO_COUNT]	= { EFI_RT_SUPPORTED_GET_NEXT_HIGH_MONOTONIC_COUNT,
+					    "GetNextHighMonotonicCount" },
+	[EFI_UPDATE_CAPSULE]		= { EFI_RT_SUPPORTED_UPDATE_CAPSULE,
+					    "UpdateCapsule" },
+	[EFI_QUERY_CAPSULE_CAPS]	= { EFI_RT_SUPPORTED_QUERY_CAPSULE_CAPABILITIES,
+					    "QueryCapsuleCapabilities" },
+};
+
+/*
+ * The EFI runtime services that have been disabled because they faulted. This
+ * is tracked separately from efi.runtime_supported_mask, so that services that
+ * the firmware reports as unsupported can still be called.
+ */
+static unsigned int efi_rts_faulted;
+
+static unsigned int efi_rts_mask(enum efi_rts_ids id)
+{
+	return id < ARRAY_SIZE(efi_rts_services) ? efi_rts_services[id].mask : 0;
+}
+
+static bool efi_rts_service_faulted(enum efi_rts_ids id)
+{
+	return efi_rts_faulted & efi_rts_mask(id);
+}
+
+/**
+ * efi_runtime_disable_faulting_service() - disable a faulting runtime service
+ *
+ * Called by architecture code after it has recovered from an exception taken
+ * by the firmware while executing an EFI runtime service. If the call was made
+ * via efi_rts_wq, only the service that faulted is disabled, so that the other
+ * ones remain usable. Otherwise, all EFI runtime services are disabled.
+ */
+void efi_runtime_disable_faulting_service(void)
+{
+	enum efi_rts_ids id = efi_rts_work.efi_rts_id;
+	unsigned int mask = 0;
+
+	if (current_work() == &efi_rts_work.work)
+		mask = efi_rts_mask(id);
+
+	if (!mask) {
+		pr_err("Disabling EFI runtime services\n");
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+		return;
+	}
+
+	pr_err("Disabling EFI runtime service %s()\n", efi_rts_services[id].name);
+	efi_rts_faulted |= mask;
+	efi.runtime_supported_mask &= ~mask;
+}
+
 /*
  * efi_queue_work:	Queue EFI runtime service call and wait for completion
  * @_rts:		EFI runtime service function identifier
@@ -388,6 +464,9 @@ static efi_status_t __efi_queue_work(enum efi_rts_ids id,
 		return EFI_DEVICE_ERROR;
 	}
 
+	if (efi_rts_service_faulted(id))
+		return EFI_DEVICE_ERROR;
+
 	efi_rts_work.efi_rts_id = id;
 	efi_rts_work.args = args;
 	efi_rts_work.caller = __builtin_return_address(0);
@@ -520,7 +599,8 @@ virt_efi_set_variable_nb(efi_char16_t *name, efi_guid_t *vendor, u32 attr,
 	if (down_trylock(&efi_runtime_lock))
 		return EFI_NOT_READY;
 
-	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
+	if (!efi_enabled(EFI_RUNTIME_SERVICES) ||
+	    efi_rts_service_faulted(EFI_SET_VARIABLE)) {
 		up(&efi_runtime_lock);
 		return EFI_DEVICE_ERROR;
 	}
@@ -564,7 +644,8 @@ virt_efi_query_variable_info_nb(u32 attr, u64 *storage_space,
 	if (down_trylock(&efi_runtime_lock))
 		return EFI_NOT_READY;
 
-	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
+	if (!efi_enabled(EFI_RUNTIME_SERVICES) ||
+	    efi_rts_service_faulted(EFI_QUERY_VARIABLE_INFO)) {
 		up(&efi_runtime_lock);
 		return EFI_DEVICE_ERROR;
 	}
diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
index 8ed368ea3..fec6eaca2 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -836,7 +836,9 @@ static void __maybe_unused lkdtm_EFI_RUNTIME_CRASH(void)
 	 */
 	status = efi.get_next_variable(&size, L"", &(efi_guid_t){});
 
-	if (status != EFI_ABORTED || efi_enabled(EFI_RUNTIME_SERVICES))
+	if (status != EFI_ABORTED ||
+	    (efi_enabled(EFI_RUNTIME_SERVICES) &&
+	     efi_rt_services_supported(EFI_RT_SUPPORTED_GET_NEXT_VARIABLE_NAME)))
 		pr_err("FAIL: EFI GetNextVariable() did not abort (%#lx)\n",
 		       status);
 }
diff --git a/include/linux/efi.h b/include/linux/efi.h
index cc1df1577..12d3e4a07 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1139,6 +1139,7 @@ extern unsigned long efi_call_virt_save_flags(void);
 
 void efi_runtime_assert_lock_held(void);
 efi_status_t efi_runtime_set_enable_flag(bool enable);
+void efi_runtime_disable_faulting_service(void);
 
 enum efi_secureboot_mode {
 	efi_secureboot_mode_unset,
-- 
2.56.0

