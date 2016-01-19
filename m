From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: v4.4-rc8 based tip tree kernel hangs on boot.
Date: Tue, 19 Jan 2016 15:42:41 +0000
Message-ID: <20160119154241.GA3615@codeblueprint.co.uk>
References: <20160110192921.GD17012@linux.vnet.ibm.com>
 <20160111140140.GA2644@codeblueprint.co.uk>
 <20160112103043.GA5707@gmail.com>
 <20160115162011.GA2935@linux.vnet.ibm.com>
 <20160115222921.GA5378@codeblueprint.co.uk>
 <20160117173248.GA28841@linux.vnet.ibm.com>
 <20160118154001.GA2607@codeblueprint.co.uk>
 <20160119104715.GA15850@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160119104715.GA15850-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srikar Dronamraju <srikar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 19 Jan, at 04:17:15PM, Srikar Dronamraju wrote:
> * Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> [2016-01-18 15:40:01]:
> 
> > On Sun, 17 Jan, at 11:02:48PM, Srikar Dronamraju wrote:
> > > 
> > > Unfortunately even with your below patch on top of c9f2a9a ("x86/efi:
> > > Hoist page table switching code into efi_call_virt()" also fails to boot
> > > with and without CONFIG_DEBUG_WX=y. I have added CONFIG_EFI_PGT_DUMP.
> > 
> > What about if you comment out the call to efi_dump_pagetable()? What
> > if you return early from efi_sync_low_kernel_mappings(), e.g.
> 
> This doesnt help but ....
> 
> > 
> > diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> > index 71121a9d06cf..e1f8ebb88f84 100644
> > --- a/arch/x86/platform/efi/efi_64.c
> > +++ b/arch/x86/platform/efi/efi_64.c
> > @@ -177,6 +177,8 @@ void efi_sync_low_kernel_mappings(void)
> >  		init_mm.pgd + pgd_index(PAGE_OFFSET),
> >  		sizeof(pgd_t) * num_pgds);
> > 
> > +	return;
> > +
> 
> This alone makes it boot. dmesg below
> 
> i.e git checkout tip/x86/efi
> +
> git am <your patch> + <the above fixlet>
> 

OK could you add efi=debug to your kernel cmdline and try this patch
instead of the one that returns early from
efi_sync_low_kernel_mappings()?

I also pushed out all the changes to the following branch if that's
easier to pull and build,

  https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/log/?h=bug/efi/srikar

I have no idea why any of these entries would be empty, but this is
the only thing I can imagine could go wrong with this code,

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 71121a9d06cf..9b610aa17683 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -192,6 +192,9 @@ void efi_sync_low_kernel_mappings(void)
 	pgd_efi = efi_pgd + pgd_index(PAGE_OFFSET);
 	pgd_k = pgd_offset_k(PAGE_OFFSET);
 
+	if (WARN_ON_ONCE(pgd_none(*pgd_efi) || pgd_none(*pgd_k)))
+		return;
+
 	num_entries = pgd_index(EFI_VA_END) - pgd_index(PAGE_OFFSET);
 	memcpy(pgd_efi, pgd_k, sizeof(pgd_t) * num_entries);
 
@@ -203,17 +206,26 @@ void efi_sync_low_kernel_mappings(void)
 	BUILD_BUG_ON((EFI_VA_END & ~PUD_MASK) != 0);
 
 	pgd_efi = efi_pgd + pgd_index(EFI_VA_END);
-	pud_efi = pud_offset(pgd_efi, 0);
-
 	pgd_k = pgd_offset_k(EFI_VA_END);
+
+	if (WARN_ON_ONCE(pgd_none(*pgd_efi) || pgd_none(*pgd_k)))
+		return;
+
+	pud_efi = pud_offset(pgd_efi, 0);
 	pud_k = pud_offset(pgd_k, 0);
 
+	if (WARN_ON_ONCE(pud_none(*pud_efi) || pud_none(*pud_k)))
+		return;
+
 	num_entries = pud_index(EFI_VA_END);
 	memcpy(pud_efi, pud_k, sizeof(pud_t) * num_entries);
 
 	pud_efi = pud_offset(pgd_efi, EFI_VA_START);
 	pud_k = pud_offset(pgd_k, EFI_VA_START);
 
+	if (WARN_ON_ONCE(pud_none(*pud_efi) || pud_none(*pud_k)))
+		return;
+
 	num_entries = PTRS_PER_PUD - pud_index(EFI_VA_START);
 	memcpy(pud_efi, pud_k, sizeof(pud_t) * num_entries);
 }
