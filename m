Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE3930C15F;
	Mon, 18 May 2026 19:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779132575; cv=none; b=UdqSFa4aBfxdcSvJbtS8IWAbLiRs/Bp8rd9cELe87tQM8IZhB1MlHEeOruoZKAkS2TwpZS6v3jGKW7yMyy9aD8wmcwRtcHn5HfUj+DHMiAb94JFfg5O71j/4oC99udB6jyClytrbVygmmziRYQxDoKGlFl76ASGIkpyK1hskfK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779132575; c=relaxed/simple;
	bh=iAe0adQVoejA0VoHY+e3w6N+5A1F0VNkllyY8+vM3Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c8JmFwAjIjMTqirmMrQhU/lTLUWvDO/XAxfwlxLRtcJYYKaRn6WWr2SX97rMNQpiw7nUsv5N6aXjJB5AcsMQ+8JK9/a0Im8sj+HyqCplb9cIr/8qqChmoEpEePMKGY26u7vVmo4Atkzro+ZHMixJ8GBvaTWnrMxw6eUv5FVyEG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f5l0uuv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f5l0uuv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC31C2BCB7;
	Mon, 18 May 2026 19:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779132574;
	bh=iAe0adQVoejA0VoHY+e3w6N+5A1F0VNkllyY8+vM3Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f5l0uuv9nrwE4OJ3F5Yb6rKnX8IvXUParKFHgZkX6gwsG3IUOMXx+LNqwwPw9crQQ
	 aJR4jhi6UKzOCNFvvQ8zZN1wZYnznPyTQeMyCLOb1mpfTDF9XX31ZdBa4E6DgdMD0h
	 1h0i//X0e8FUaCL/P1O3cPM+0RDznM+SW6BN6W2Df28C2IB00t+z6BYIo2DT6OQ+IF
	 +R9BqyV9Y5o5lElyv9oYZFVYFCIVQjYpt0KAyTivdowP3uR6uhY3qYTKEyewgSrmSF
	 +E/bVyT+gw9Z+QFGDLSkjTGFJumVhe5o3UxyNK1cwSsAJS6eCGP6mP5rHE8GxKTgE7
	 xWZCOTytTKG+A==
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 Linux ACPI <linux-acpi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject:
 Re: [PATCH v1] efi/runtime-wrappers: Avoid crashing on early PRM code
 invocations
Date: Mon, 18 May 2026 21:29:31 +0200
Message-ID: <6277483.lOV4Wx5bFT@rafael.j.wysocki>
Organization: Linux Kernel Development
In-Reply-To: <0572b4b0-d67c-46de-aecb-d11a4336c202@app.fastmail.com>
References:
 <2415513.ElGaqSPkdT@rafael.j.wysocki>
 <0572b4b0-d67c-46de-aecb-d11a4336c202@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

On Friday, May 15, 2026 7:29:03 PM CEST Ard Biesheuvel wrote:
> Hi Rafael,
> 
> On Fri, 15 May 2026, at 19:10, Rafael J. Wysocki wrote:
> > From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> >
> > There is a dependency between EFI and ACPI PRM that the latter cannot
> > run until the former is ready and PRM can be invoked from AML early
> > through acpi_platformrt_space_handler().  If that happens before
> > initializing efi_rts_wq, it leads to a NULL pointer dereference.
> >
> > Avoid that by adding an efi_rts_wq check against NULL to
> > efi_call_acpi_prm_handler().
> >
> > Fixes: 5894cf571e14 ("acpi/prmt: Use EFI runtime sandbox to invoke PRM 
> > handlers")
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Cc: 6.6+ <stable@vger.kernel.org> # 6.6+
> > ---
> >
> > An alternative would be to somehow ensure that efisubsys_init() will always
> > run before acpi_init(), but moving any of them to another initcall level is
> > not an option AFAICS.
> >
> 
> Given that they both run as subsys_initcall() currently, changing acpi_init()
> to subsys_initcall_sync() is probably fine (famous last words :-))

Well, not quite because there is stuff depending on ACPI in that initcall level
(MWI and CXL, probably among other things).

> But if the PRM code can deal with EFI_NOT_READY than this is also fine,
> modulo the comment below.

It can, but that is not ideal because if EFI_NOT_READY is returned, so AML will
be aborted and that may be something like a GPE handler method, so it would be
better to ensure the working order.

Something like the patch below can be done.  It works AFAICS, but the initcall
error handling is a bit awkward (it is for debug though, so not a big deal I
guess).  If this is acceptable, I can send it as a v2.

---
 drivers/acpi/bus.c         |    8 +++++++-
 drivers/firmware/efi/efi.c |   16 +++++++++++++++-
 include/acpi/acpi_bus.h    |    4 ++++
 3 files changed, 26 insertions(+), 2 deletions(-)

--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1490,7 +1490,7 @@ EXPORT_SYMBOL_GPL(acpi_kobj);
 
 void __weak __init acpi_arch_init(void) { }
 
-static int __init acpi_init(void)
+int __init acpi_init(void)
 {
 	int result;
 
@@ -1531,4 +1531,10 @@ static int __init acpi_init(void)
 	return 0;
 }
 
+/*
+ * If EFI is enabled, it needs to initialize before ACPI due to a PRM
+ * dependency, so in that case acpi_init() will be called from there.
+ */
+#ifndef CONFIG_EFI
 subsys_initcall(acpi_init);
+#endif
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -500,7 +500,21 @@ err_destroy_wq:
 	return error;
 }
 
-subsys_initcall(efisubsys_init);
+static int __init efisubsys_and_acpi_init(void)
+{
+	int efi_ret, acpi_ret;
+
+	efi_ret = efisubsys_init();
+
+	/* Initialize ACPI after EFI to satisfy a PRM dependency. */
+	acpi_ret = acpi_init();
+
+	if (efi_ret)
+		return efi_ret;
+
+	return acpi_ret;
+}
+subsys_initcall(efisubsys_and_acpi_init);
 
 void __init efi_find_mirror(void)
 {
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -92,6 +92,8 @@ bool acpi_reduced_hardware(void);
 
 #ifdef CONFIG_ACPI
 
+int __init acpi_init(void);
+
 struct proc_dir_entry;
 
 #define ACPI_BUS_FILE_ROOT	"acpi"
@@ -994,6 +996,8 @@ int acpi_scan_add_dep(acpi_handle handle
 u32 arch_acpi_add_auto_dep(acpi_handle handle);
 #else	/* CONFIG_ACPI */
 
+static inline int acpi_init(void) { return 0; }
+
 static inline int register_acpi_bus_type(void *bus) { return 0; }
 static inline int unregister_acpi_bus_type(void *bus) { return 0; }
 



