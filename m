From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/2] x86/efi: Map EFI_MEMORY_{XP,RO} memory region bits
 to EFI page tables
Date: Thu, 11 Feb 2016 14:57:37 +0000
Message-ID: <20160211145737.GG4134@codeblueprint.co.uk>
References: <1454115880-6914-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1454115880-6914-3-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454115880-6914-3-git-send-email-sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 29 Jan, at 05:04:40PM, Sai Praneeth Prakhya wrote:
> From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Now that we have EFI memory region bits that indicate which regions do
> not need execute permission or read/write permission in the page tables,
> let's use them.
> 
> We also check for EFI_NX_PE_DATA and only enforce the restrictive
> mappings if it's present (to allow us to ignore buggy firmware that sets
> bits it didn't mean to and to preserve backwards compatibility).
> 
> Instead of assuming that firmware would set appropriate attributes in
> memory descriptor like EFI_MEMORY_RO for code and EFI_MEMORY_XP for
> data, we can expect some firmware out there which might only set *type*
> in memory descriptor to be EFI_RUNTIME_SERVICES_CODE or
> EFI_RUNTIME_SERVICES_DATA leaving away attribute. This will lead to
> improper mappings of EFI runtime regions. In order to avoid it, we check
> attribute and type of memory descriptor to update mappings and moreover
> Windows works this way.
> 
> Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
> Cc: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> Cc: Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/include/asm/efi.h     |  2 +-
>  arch/x86/platform/efi/efi.c    |  9 +++++++--
>  arch/x86/platform/efi/efi_64.c | 45 ++++++++++++++++++++++++++++++++++++++----
>  3 files changed, 49 insertions(+), 7 deletions(-)

I just hit the following build error,

arch/x86/built-in.o: In function `efi_enter_virtual_mode':
(.init.text+0x12ac0): undefined reference to `efi_runtime_update_mappings'
make[1]: *** [vmlinux] Error 1

I fixed it up like so,

diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index 58d669bc8250..338402b91d2e 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -90,7 +90,7 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
 	__flush_tlb_all();
 }
 
-void __init efi_runtime_mkexec(void)
+void __init efi_runtime_update_mappings(void)
 {
 	if (__supported_pte_mask & _PAGE_NX)
 		runtime_code_page_mkexec();
