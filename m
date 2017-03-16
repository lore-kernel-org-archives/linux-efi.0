From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: kexec regression since 4.9 caused by efi
Date: Thu, 16 Mar 2017 12:41:32 +0000
Message-ID: <20170316124132.GF6261@codeblueprint.co.uk>
References: <20170308201616.GC8598@vader>
 <20170309063806.GB17257@dhcp-128-65.nay.redhat.com>
 <20170309095408.GA17883@vader>
 <20170313073748.GA6332@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170313073748.GA6332-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 13 Mar, at 03:37:48PM, Dave Young wrote:
> 
> Omar, could you try below patch? Looking at the efi_mem_desc_lookup, it is not
> correct to be used in efi_arch_mem_reserve, if it passed your test, I
> can rewrite patch log with more background and send it out:
> 
>         for_each_efi_memory_desc(md) {
> 		[snip]
>                 if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
>                     md->type != EFI_BOOT_SERVICES_DATA &&
>                     md->type != EFI_RUNTIME_SERVICES_DATA) {
>                         continue;
>                 }
> 
> In above code, it meant to get a md of EFI_MEMORY_RUNTIME of either boot
> data or runtime data, this is wrong for efi_mem_reserve, because we are
> reserving boot data which has no EFI_MEMORY_RUNTIME attribute at the
> running time. Just is happened to work and we did not capture the error.

Wouldn't something like this be simpler?

---

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 30031d5293c4..cdfe8c628959 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -201,6 +201,10 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
 		return;
 	}
 
+	/* No need to reserve regions that will never be freed. */
+	if (md.attribute & EFI_MEMORY_RUNTIME)
+		return;
+
 	size += addr % EFI_PAGE_SIZE;
 	size = round_up(size, EFI_PAGE_SIZE);
 	addr = round_down(addr, EFI_PAGE_SIZE);
