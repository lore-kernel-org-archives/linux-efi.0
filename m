From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: add support for UEFIv2.5 Properties table
Date: Fri, 25 Sep 2015 09:43:36 +0800
Message-ID: <20150925014336.GA6640@dhcp-129-149.nay.redhat.com>
References: <1441786096-8514-1-git-send-email-ard.biesheuvel@linaro.org>
 <20150924060624.GA26341@dhcp-129-149.nay.redhat.com>
 <CAKv+Gu9hoMybK19EGRxsQTt1A4xsfwj40d=6F5kVHQD+39CvGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9hoMybK19EGRxsQTt1A4xsfwj40d=6F5kVHQD+39CvGg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 09/24/15 at 02:06pm, Ard Biesheuvel wrote:
> On 23 September 2015 at 23:06, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On 09/09/15 at 10:08am, Ard Biesheuvel wrote:
> >> Version 2.5 of the UEFI spec introduces a new configuration table
> >> called the 'EFI Properties table'. Currently, it is only used to
> >> convey whether the Memory Protection feature is enabled, which splits
> >> PE/COFF images into separate code and data memory regions.
> >>
> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> >> ---
> >>  drivers/firmware/efi/efi.c | 32 ++++++++++++++++++--------------
> >>  include/linux/efi.h        | 13 +++++++++++++
> >>  2 files changed, 31 insertions(+), 14 deletions(-)
> >>
> >> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> >> index d6144e3b97c5..5cbb8d31da33 100644
> >> --- a/drivers/firmware/efi/efi.c
> >> +++ b/drivers/firmware/efi/efi.c
> >> @@ -26,20 +26,21 @@
> >>  #include <linux/platform_device.h>
> >>
> >>  struct efi __read_mostly efi = {
> >> -     .mps        = EFI_INVALID_TABLE_ADDR,
> >> -     .acpi       = EFI_INVALID_TABLE_ADDR,
> >> -     .acpi20     = EFI_INVALID_TABLE_ADDR,
> >> -     .smbios     = EFI_INVALID_TABLE_ADDR,
> >> -     .smbios3    = EFI_INVALID_TABLE_ADDR,
> >> -     .sal_systab = EFI_INVALID_TABLE_ADDR,
> >> -     .boot_info  = EFI_INVALID_TABLE_ADDR,
> >> -     .hcdp       = EFI_INVALID_TABLE_ADDR,
> >> -     .uga        = EFI_INVALID_TABLE_ADDR,
> >> -     .uv_systab  = EFI_INVALID_TABLE_ADDR,
> >> -     .fw_vendor  = EFI_INVALID_TABLE_ADDR,
> >> -     .runtime    = EFI_INVALID_TABLE_ADDR,
> >> -     .config_table  = EFI_INVALID_TABLE_ADDR,
> >> -     .esrt       = EFI_INVALID_TABLE_ADDR,
> >> +     .mps                    = EFI_INVALID_TABLE_ADDR,
> >> +     .acpi                   = EFI_INVALID_TABLE_ADDR,
> >> +     .acpi20                 = EFI_INVALID_TABLE_ADDR,
> >> +     .smbios                 = EFI_INVALID_TABLE_ADDR,
> >> +     .smbios3                = EFI_INVALID_TABLE_ADDR,
> >> +     .sal_systab             = EFI_INVALID_TABLE_ADDR,
> >> +     .boot_info              = EFI_INVALID_TABLE_ADDR,
> >> +     .hcdp                   = EFI_INVALID_TABLE_ADDR,
> >> +     .uga                    = EFI_INVALID_TABLE_ADDR,
> >> +     .uv_systab              = EFI_INVALID_TABLE_ADDR,
> >> +     .fw_vendor              = EFI_INVALID_TABLE_ADDR,
> >> +     .runtime                = EFI_INVALID_TABLE_ADDR,
> >> +     .config_table           = EFI_INVALID_TABLE_ADDR,
> >> +     .esrt                   = EFI_INVALID_TABLE_ADDR,
> >> +     .properties_table       = EFI_INVALID_TABLE_ADDR,
> >>  };
> >>  EXPORT_SYMBOL(efi);
> >>
> >> @@ -105,6 +106,8 @@ static ssize_t systab_show(struct kobject *kobj,
> >>               str += sprintf(str, "BOOTINFO=0x%lx\n", efi.boot_info);
> >>       if (efi.uga != EFI_INVALID_TABLE_ADDR)
> >>               str += sprintf(str, "UGA=0x%lx\n", efi.uga);
> >> +     if (efi.properties_table != EFI_INVALID_TABLE_ADDR)
> >> +             str += sprintf(str, "PROP=0x%lx\n", efi.properties_table);
> >
> > Hello, Ard and Matt
> >
> 
> Hi Dave,
> 
> > I ramdomly read some of mails in linux-efi@, sorry for joining the discussion late.
> >
> > The sysfs file systab abuses sysfs policy about one value one file. For what we
> > have done we will have to maintain it, but I think we should not add more entries
> > to the file any more. Previously I thought to send a patch to add some code comment
> > to avoid later patches doing such modifications, but I hesitated if I should send
> > it, later I'm busy on something else..
> >
> 
> While I agree that we should not be abusing this policy in the first
> place, changing the semantics of 'systab' to mean 'all configuration
> tables we knew about at some random point in the past' rather than
> 'all configuration tables passed by the firmware' is even worse imo.

Hmm, I have already put several of them out of systab like 'runtime', if you do not
like it, how about re-adding all table entries under /sys/firmware/efi as standalone
files, at the same time keep original systab there only for compatibility purpose.

Thanks
Dave
