From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 07/14] efi: export more efi table variable to sysfs
Date: Thu, 12 Dec 2013 10:15:51 +0800
Message-ID: <20131212021551.GE3751@dhcp-16-126.nay.redhat.com>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-8-git-send-email-dyoung@redhat.com>
 <20131211183203.GF23793@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131211183203.GF23793-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 12/11/13 at 07:32pm, Borislav Petkov wrote:
> On Mon, Dec 09, 2013 at 05:42:20PM +0800, Dave Young wrote:
> > Export fw_vendor, runtime and config table physical addresses to
> > /sys/firmware/efi/fw_vendor, /sys/firmware/efi/runtime and
> > /sys/firmware/efi/config_table because kexec kernel will need them.
> 
> you might wanna shorten:
> 
> ... sys/firmware/efi/{fw_vendor,runtime,config_table} ...

Ok, will do.

> 
> > 
> > From EFI spec these 3 variables will be updated to
> > virtual address after entering virtual mode. But
> > kernel startup code will need the physical address.
> > 
> > changelog:
> > Greg: add standalone sysfs files instead of add lines to systab
> > Document them as testing ABI
> > Greg: use group attrs and is_visible
> > Boris: align comments lines
> > Boris: add macros for _show functions
> > Matt: Documentation fixes.
> > 
> > Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  Documentation/ABI/testing/sysfs-firmware-efi | 24 +++++++++++++++++
> >  arch/x86/platform/efi/efi.c                  |  4 +++
> >  drivers/firmware/efi/efi.c                   | 39 ++++++++++++++++++++++++++++
> >  include/linux/efi.h                          |  3 +++
> >  4 files changed, 70 insertions(+)
> >  create mode 100644 Documentation/ABI/testing/sysfs-firmware-efi
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-firmware-efi b/Documentation/ABI/testing/sysfs-firmware-efi
> > new file mode 100644
> > index 0000000..8c6e460
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-firmware-efi
> > @@ -0,0 +1,24 @@
> > +What:		/sys/firmware/efi/fw_vendor
> > +Date:		December 2013
> > +Contact:	Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > +Description:
> > +		It shows the physical address of firmware vendor field in the
> 
> Why doesn't this start at the same line as "Description:"?

It can, just in 1st version I copied the format from some template, I have
found it's better so updated the Users line but missed the Description.

Will do in next version.

> 
> > +		EFI system table.
> > +
> 
> Superfluous newline.

Will remove it.

[snip]
> > +
> >  static struct attribute *efi_subsys_attrs[] = {
> >  	&efi_attr_systab.attr,
> > +	&efi_attr_fw_vendor.attr,
> > +	&efi_attr_runtime.attr,
> > +	&efi_attr_config_table.attr,
> >  	NULL,	/* maybe more in the future? */
> 		^^^^^
> 
> Now that there's more, you can drop that wise guy comment :)

Ok.

--
Thanks for review
Dave
