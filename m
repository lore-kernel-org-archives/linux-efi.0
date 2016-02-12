From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH] x86/efi: skip bgrt init for kexec reboot
Date: Fri, 12 Feb 2016 20:45:42 +0800
Message-ID: <20160212124542.GA7051@dhcp-128-65.nay.redhat.com>
References: <20160127112044.GA2961@dhcp-128-65.nay.redhat.com>
 <20160203214200.GA15110@dhcp-128-65.nay.redhat.com>
 <20160203225333.GA31246@codeblueprint.co.uk>
 <20160204100329.GA2586@codeblueprint.co.uk>
 <20160204110903.GA2977@dhcp-128-65.nay.redhat.com>
 <20160204115656.GB2586@codeblueprint.co.uk>
 <20160205004115.GA3651@dhcp-128-65.nay.redhat.com>
 <20160211160931.GL4134@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160211160931.GL4134@codeblueprint.co.uk>
Sender: linux-acpi-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-efi@vger.kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>, linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Josh Triplett <josh@joshtriplett.org>, Matthew Garrett <mjg59@srcf.ucam.org>
List-Id: linux-efi@vger.kernel.org

On 02/11/16 at 04:09pm, Matt Fleming wrote:
> On Fri, 05 Feb, at 08:41:15AM, Dave Young wrote:
> > On 02/04/16 at 11:56am, Matt Fleming wrote:
> > > On Thu, 04 Feb, at 07:09:03PM, Dave Young wrote:
> > > > 
> > > > Consider the original code path, maybe change it to efi_kexec_setup will
> > > > be better to remind people? Or something else like a wraper function with
> > > > similar name..
> > >  
> > > Possibly. I had considered adding a new efi_enabled() bit for
> > > KEXEC_BOOT, but I'm worried that'll just encourage more uses.
> > > 
> > > The best approach is going to be to see whether we can reduce the uses
> > > of efi_setup and the associated special code. Once we've completed
> > > that exercise, we can think about the best name for this variable.
> > 
> > Ok, thanks.
> > 
> > > 
> > > > For building ACPI tables we need do it in kernel instead of kexec-tools
> > > > because of kexec_file_load for secure boot case so we still need a conditional
> > > > code path for kexec..
> > > 
> > > Note that it may not be necessary to build any ACPI tables at all,
> > > provided that things like acpi_get_table() fail gracefully for kexec.
> > > I'm assuming that's the problem that you discovered when writing this
> > > patch.
> > > 
> > > And yes, I don't expect you can build the ACPI table from userspace,
> > > but it should at least be possible to do it in setup_boot_parameters()
> > > or so when you setup the EFI table pointers (efi.config_tables), etc.
> > > I think that would be a natural home for this feature.
> > 
> > Thing is we support both kexec_load and kexec_file_load, if we do something
> > in kernel loader we will need do same in userspace kexec-tools as well.
>  
> Actually, on thinking about it a little bit more, any changes we make
> would have to be on the second kernel side, because otherwise you end
> up with incompatibilities between kernel versions.

Hmm, agreed.

> 
> For example, changing the data we pass in the SETUP_EFI chain is a bad
> idea becuase you then have to care about exactly which kernel version
> you kexec loaded.
> 
> > Another way is we probably can retain the boot service areas for kexec
> > boot, but yes it is another special handling for kexec :(. Is this way
> > better to you?
> 
> Unfortunately retaining Boot Services areas is infeasible because they
> can be *really* large, i.e. multiple gigabytes in size.

Yes, rethink about this issue, how about something like below:
---

For kexec reboot the bgrt image address could contains random data because
we have freed boot service areas in 1st kernel boot phase. One possible
result is kmalloc fail in efi_bgrt_init due to large random image size.

bgrt table finished it's task after copying bgrt image thus let's
change the table status to be invalid at the end of efi_bgrt_init. 

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/platform/efi/efi-bgrt.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-x86.orig/arch/x86/platform/efi/efi-bgrt.c
+++ linux-x86/arch/x86/platform/efi/efi-bgrt.c
@@ -107,4 +107,10 @@ void __init efi_bgrt_init(void)
 	memcpy_fromio(bgrt_image, image, bgrt_image_size);
 	if (ioremapped)
 		early_iounmap(image, bmp_header.size);
+
+	/*
+	 * Invalidate bgrt table because kexec reboot will access the bgrt image
+	 * which stays in freed boot service area.
+	 */
+	bgrt_tab->status &= 0xfe;
 }
