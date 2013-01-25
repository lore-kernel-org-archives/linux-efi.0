From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] fix setup_efi_pci()
Date: Fri, 25 Jan 2013 11:04:26 +0000
Message-ID: <1359111866.2496.135.camel@mfleming-mobl1.ger.corp.intel.com>
References: <50F94F9202000078000B74EE@nat28.tlf.novell.com>
	 <1359051621.2496.95.camel@mfleming-mobl1.ger.corp.intel.com>
	 <5102452202000078000B9755@nat28.tlf.novell.com>
	 <1359103537.2496.132.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359103537.2496.132.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Cc: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2013-01-25 at 08:45 +0000, Matt Fleming wrote:
> On Fri, 2013-01-25 at 07:41 +0000, Jan Beulich wrote:
> > >>> On 24.01.13 at 19:20, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > > On Fri, 2013-01-18 at 12:35 +0000, Jan Beulich wrote:
> > >> This fixes two issues:
> > >> - wrong memory type used for allocation intended to persist post-boot
> > > 
> > > [...]
> > > 
> > >> @@ -311,7 +311,7 @@ static efi_status_t setup_efi_pci(struct
> > >>  		size = pci->romsize + sizeof(*rom);
> > >>  
> > >>  		status = efi_call_phys3(sys_table->boottime->allocate_pool,
> > >> -				EFI_LOADER_DATA, size, &rom);
> > >> +					EFI_RUNTIME_SERVICES_DATA, size, &rom);
> > >>  
> > >>  		if (status != EFI_SUCCESS)
> > >>  			continue;
> > > 
> > > I'm curious why you made this change. No one should be stealing that
> > > region of memory because that's all handled in parse_e820_ext() - it's
> > > marked as off limits wrt memory for the kernel's use. And the firmware
> > > certainly shouldn't start touching it.
> > 
> > According to my reading of do_add_efi_memmap(), EFI_LOADER_DATA
> > gets treated the same as EFI_CONVENTIONAL_MEMORY, i.e. gets
> > marked as available for allocation. That's also how I'd expect things
> > to be. I don't think parse_e820_ext() matters here at all.
> 
> Oh, I totally misread the flow of execution here. parse_setup_data()
> seems to be missing a SETUP_PCI case.
> 
> Matthew, what guarantees do we have that the memory we've allocated for
> the PCI ROMs isn't going to be reused? I suspect what's needed is for
> parse_setup_data() to reserve the SETUP_PCI regions, just like you would
> for any other key data structure.
> 
> It's the kernel's responsibility to protect any EFI_LOADER_DATA regions
> that it needs, we shouldn't have to trick ourselves by using the
> EFI_RUNTIME_SERVICES_DATA pool for allocations.

Meanwhile I've queued up the following patch. Jan, please shout if
you're unhappy with me doing so,

---

>From bc754790f932f3466ec521ee792da2791e7003ae Mon Sep 17 00:00:00 2001
From: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Date: Fri, 18 Jan 2013 12:35:14 +0000
Subject: [PATCH] x86, efi: fix 32-bit warnings in setup_efi_pci()

Fix four similar build warnings on 32-bit (casts between different
size pointers and integers).

Signed-off-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Stefan Hasko <hasko.stevo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 18e329c..3f3d36f 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -256,10 +256,10 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 	int i;
 	struct setup_data *data;
 
-	data = (struct setup_data *)params->hdr.setup_data;
+	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
 
 	while (data && data->next)
-		data = (struct setup_data *)data->next;
+		data = (struct setup_data *)(unsigned long)data->next;
 
 	status = efi_call_phys5(sys_table->boottime->locate_handle,
 				EFI_LOCATE_BY_PROTOCOL, &pci_proto,
@@ -345,9 +345,9 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 		memcpy(rom->romdata, pci->romimage, pci->romsize);
 
 		if (data)
-			data->next = (uint64_t)rom;
+			data->next = (unsigned long)rom;
 		else
-			params->hdr.setup_data = (uint64_t)rom;
+			params->hdr.setup_data = (unsigned long)rom;
 
 		data = (struct setup_data *)rom;
 
-- 
1.7.11.7
