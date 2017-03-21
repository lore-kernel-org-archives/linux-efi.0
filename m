From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: kexec regression since 4.9 caused by efi
Date: Tue, 21 Mar 2017 15:48:26 +0800
Message-ID: <20170321074826.GA4571@dhcp-128-65.nay.redhat.com>
References: <20170308201616.GC8598@vader>
 <20170309063806.GB17257@dhcp-128-65.nay.redhat.com>
 <20170309095408.GA17883@vader>
 <20170313073748.GA6332@dhcp-128-65.nay.redhat.com>
 <20170316124132.GF6261@codeblueprint.co.uk>
 <20170317020951.GA3942@dhcp-128-65.nay.redhat.com>
 <20170317133232.GI6261@codeblueprint.co.uk>
 <20170320021412.GA3793@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170320021412.GA3793-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 03/20/17 at 10:14am, Dave Young wrote:
> On 03/17/17 at 01:32pm, Matt Fleming wrote:
> > On Fri, 17 Mar, at 10:09:51AM, Dave Young wrote:
> > > 
> > > Matt, I think it should be fine although I think the md type checking in
> > > efi_mem_desc_lookup() is causing confusion and not easy to understand..
> >  
> > Could you make that a separate patch if you think of improvements
> > there?
> 
> Duplicate the lookup function is indeed a little ugly, will do it when I
> have a better idea, we can leave it as is since it works.

Matt, rethinking about this, how about doint something below, not
tested, just seeking for idea and opinons, in this way no need duplicate
a function, but there is an assumption that no overlapped mem ranges in
efi memmap.

Also the case Omar reported is the esrt memory range type is
RUNTIME_DATA, that is a little different with the mem attribute of
RUNTIME which also includes BOOT_DATA which has been set the RUNTIME
attribute, like bgrt in kexec reboot. Should we distinguish the two
cases and give out some warnings or debug info?


---
 arch/x86/platform/efi/quirks.c |    5 +++++
 drivers/firmware/efi/efi.c     |    6 ------
 drivers/firmware/efi/esrt.c    |    7 +++++++
 3 files changed, 12 insertions(+), 6 deletions(-)

--- linux-x86.orig/drivers/firmware/efi/efi.c
+++ linux-x86/drivers/firmware/efi/efi.c
@@ -376,12 +376,6 @@ int __init efi_mem_desc_lookup(u64 phys_
 		u64 size;
 		u64 end;
 
-		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
-		    md->type != EFI_BOOT_SERVICES_DATA &&
-		    md->type != EFI_RUNTIME_SERVICES_DATA) {
-			continue;
-		}
-
 		size = md->num_pages << EFI_PAGE_SHIFT;
 		end = md->phys_addr + size;
 		if (phys_addr >= md->phys_addr && phys_addr < end) {
--- linux-x86.orig/drivers/firmware/efi/esrt.c
+++ linux-x86/drivers/firmware/efi/esrt.c
@@ -258,6 +258,13 @@ void __init efi_esrt_init(void)
 		return;
 	}
 
+	if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
+	      md->type != EFI_BOOT_SERVICES_DATA &&
+	      md->type != EFI_RUNTIME_SERVICES_DATA) {
+		pr_err("ESRT header memory map type is invalid\n");
+		return;
+	}
+
 	max = efi_mem_desc_end(&md);
 	if (max < efi.esrt) {
 		pr_err("EFI memory descriptor is invalid. (esrt: %p max: %p)\n",
--- linux-x86.orig/arch/x86/platform/efi/quirks.c
+++ linux-x86/arch/x86/platform/efi/quirks.c
@@ -201,6 +201,11 @@ void __init efi_arch_mem_reserve(phys_ad
 		return;
 	}
 
+	if (md->attribute & EFI_MEMORY_RUNTIME ||
+	      md->type != EFI_BOOT_SERVICES_DATA) {
+		return;
+	}
+
 	size += addr % EFI_PAGE_SIZE;
 	size = round_up(size, EFI_PAGE_SIZE);
 	addr = round_down(addr, EFI_PAGE_SIZE);

> 
> > 
> > > How about move the if chunk early like below because it seems no need
> > > to sanity check the addr + size any more if the md is still RUNTIME?
> > 
> > My original version did as you suggest, but I changed it because we
> > *really* want to know if someone tries to reserve a range that spans
> > regions. That would be totally unexpected and a warning about a
> > potential bug/issue.
> 
> Matt, I'm fine if you prefer to capture the range checking errors.
> Would you like me to post it or just you send it out?
> 
> Thanks
> Dave

Thanks
Dave
