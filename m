From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] efi: add firmware version information to sysfs
Date: Tue, 6 Sep 2016 11:35:17 -0400
Message-ID: <20160906153516.GA23610@redhat.com>
References: <20160902185758.GB9082@redhat.com>
 <1472849873-32041-1-git-send-email-pjones@redhat.com>
 <1472849873-32041-2-git-send-email-pjones@redhat.com>
 <20160905120006.GA27048@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160905120006.GA27048-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Sep 05, 2016 at 02:00:06PM +0200, Lukas Wunner wrote:
> On Fri, Sep 02, 2016 at 04:57:52PM -0400, Peter Jones wrote:
> > This adds the EFI Spec version from the system table to sysfs as
> > /sys/firmware/efi/spec_version .
> > 
> > Userland tools need this information in order to work around
> > specification deficiencies in 2.4 and earlier firmwares.  Specifically,
> > UEFI 2.4 and 2.5+ treat management of BootOrder very differently (See
> > UEFI 2.4 section 3.1.1 vs UEFI 2.5 section 3.1), which means on older
> > firmware we'll want to work around BDS's boot order management by adding
> > fwupdate entries to BootOrder.  We'd prefer not to do this on newer
> > firmware, as it is both non-sensical in terms of what it expresses, and
> > it results in more relatively failure prone flash writes.
> > 
> > Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  Documentation/ABI/testing/sysfs-firmware-efi |  6 +++
> >  drivers/firmware/efi/efi.c                   | 55 ++++++++++++++++++++++++++++
> >  2 files changed, 61 insertions(+)
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-firmware-efi b/Documentation/ABI/testing/sysfs-firmware-efi
> > index e794eac..4eec7c2 100644
> > --- a/Documentation/ABI/testing/sysfs-firmware-efi
> > +++ b/Documentation/ABI/testing/sysfs-firmware-efi
> > @@ -28,3 +28,9 @@ Description:	Displays the physical addresses of all EFI Configuration
> >  		versions are always printed first, i.e. ACPI20 comes
> >  		before ACPI.
> >  Users:		dmidecode
> > +
> > +What:		/sys/firmware/efi/spec_version
> > +Date:		August 2016
> > +Contact:	linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > +Description:	Displays the UEFI Specification revision the firmware claims to
> > +		be based upon.
> > diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> > index 5a2631a..3ef3a2a 100644
> > --- a/drivers/firmware/efi/efi.c
> > +++ b/drivers/firmware/efi/efi.c
> > @@ -141,11 +141,65 @@ static ssize_t fw_platform_size_show(struct kobject *kobj,
> >  	return sprintf(buf, "%d\n", efi_enabled(EFI_64BIT) ? 64 : 32);
> >  }
> >  
> > +static ssize_t spec_version_show(struct kobject *kobj,
> > +				 struct kobj_attribute *attr,
> > +				 char *buf)
> 
> The function is renamed efi_spec_version_format() in the next patch.
> Why not call it that right away in this patch?

Well, I'd rather leave the _show bit there so we can use the same macro
as everything else for the real declaration.  It's less code, and more
readable.

> I'd change the return type to void and make this function copy
> "(unknown)" to buf on error. That way you don't have to repeat
> that over and over again in the next patch.

I've done... almost that.  I'm not sure one way is really better or
worse, to be honest.

> > +	if (!buf)
> > +		return -EINVAL;
> 
> Move that check to the top of the function so that you avoid calculating
> major and minor in vain if buf is NULL.

Sure.  Updated set to follow.

-- 
  Peter
