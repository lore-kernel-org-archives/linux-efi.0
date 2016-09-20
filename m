From: Chao Gao <chao.gao@intel.com>
Subject: Re: [PATCH] x86/efi: Add necessary checks before iterating over
 efi.memmap
Date: Tue, 20 Sep 2016 13:25:14 +0800
Message-ID: <20160920052514.GA41801@g.c>
References: <20160913032813.GA11652@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160913032813.GA11652@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Sorry for bothering you. There is a regression since commit 78ce248f that if
booting xen in UEFI mode, dom0 will crash and xen reboot constantly.
This patch tries to fix it. Please take a look at it.

On Tue, Sep 13, 2016 at 11:28:15AM +0800, Chao Gao wrote:
>Commit 78ce248f (efi: Iterate over efi.memmap in for_each_efi_memory_desc())
>replaces the old loop by for_each_efi_memory_desc() which will encounter #PF
>when efi.memap are not initialized.
>
>In boot process, xen set EFI_PARAVIRT in xen_efi_init() before setup_arch()
>is called. This leads efi_memmap_init() will not initialize structures
>related to efi.memmap. However, the following functions e.g.
>efi_find_mirror(), efi_print_memmap() and efi_free_boot_services() access
>efi.memmap without necessary checks. kernel and xen crash in this case.
>After adding these checks, xen and kernel boot up normally.
>
>Signed-off-by: Chao Gao <chao.gao@intel.com>
>---
> arch/x86/platform/efi/efi.c    | 6 ++++++
> arch/x86/platform/efi/quirks.c | 3 +++
> 2 files changed, 9 insertions(+)
>
>diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
>index 1fbb408..68966dc 100644
>--- a/arch/x86/platform/efi/efi.c
>+++ b/arch/x86/platform/efi/efi.c
>@@ -102,6 +102,9 @@ void __init efi_find_mirror(void)
> 	efi_memory_desc_t *md;
> 	u64 mirror_size = 0, total_size = 0;
> 
>+	if (efi_enabled(EFI_PARAVIRT))
>+		return;
>+
> 	for_each_efi_memory_desc(md) {
> 		unsigned long long start = md->phys_addr;
> 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
>@@ -207,6 +210,9 @@ void __init efi_print_memmap(void)
> 	efi_memory_desc_t *md;
> 	int i = 0;
> 
>+	if (efi_enabled(EFI_PARAVIRT))
>+		return;
>+
> 	for_each_efi_memory_desc(md) {
> 		char buf[64];
> 
>diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
>index 89d1146..4fa1e4d 100644
>--- a/arch/x86/platform/efi/quirks.c
>+++ b/arch/x86/platform/efi/quirks.c
>@@ -251,6 +251,9 @@ void __init efi_free_boot_services(void)
> {
> 	efi_memory_desc_t *md;
> 
>+	if (efi_enabled(EFI_PARAVIRT))
>+		return;
>+
> 	for_each_efi_memory_desc(md) {
> 		unsigned long long start = md->phys_addr;
> 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
>-- 
>1.8.3.1
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-efi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
