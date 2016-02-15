From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/5] efi: Make efivarfs entries immutable by default. (v5)
Date: Mon, 15 Feb 2016 12:02:16 -0500
Message-ID: <20160215170215.GC785@redhat.com>
References: <1454600074-14854-1-git-send-email-pjones@redhat.com>
 <1454600074-14854-6-git-send-email-pjones@redhat.com>
 <56BDDFDC.406@redhat.com>
 <20160212150948.GC31573@redhat.com>
 <20160215104801.GB2591@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160215104801.GB2591-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, efi kernel list <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Feb 15, 2016 at 10:48:01AM +0000, Matt Fleming wrote:
> On Fri, 12 Feb, at 10:09:49AM, Peter Jones wrote:
> > On Fri, Feb 12, 2016 at 02:36:28PM +0100, Laszlo Ersek wrote:
> > > On 02/04/16 16:34, Peter Jones wrote:
> > > > "rm -rf" is bricking some peoples' laptops because of variables being
> > > > used to store non-reinitializable firmware driver data that's required
> > > > to POST the hardware.
> > > > 
> > > > These are 100% bugs, and they need to be fixed, but in the mean time it
> > > > shouldn't be easy to *accidentally* brick machines.
> > > > 
> > > > We have to have delete working, and picking which variables do and don't
> > > > work for deletion is quite intractable, so instead make everything
> > > > immutable by default (except for a whitelist), and make tools that
> > > > aren't quite so broad-spectrum unset the immutable flag.
> > > 
> > > I think that the whitelist should include the following pattern
> > > (permitting deletion):
> > > - GUID:                  LINUX_EFI_CRASH_GUID
> > > - variable name pattern: "dump-type*"
> > > 
> > > This is because the pstore filesystem can be backed by UEFI variables,
> > > and (for example) a crash might dump the last kilobytes of the dmesg
> > > into a number of pstore entries, each entry backed by a separate UEFI
> > > variable in the above GUID namespace, and with a variable name according
> > > to the above pattern.
> > > 
> > > Please see "drivers/firmware/efi/efi-pstore.c".
> > > 
> > > While this patch series will not prevent the user from deleting those
> > > UEFI variables via the pstore filesystem (i.e., deleting a pstore fs
> > > entry will continue to delete the backing UEFI variable), I think it
> > > would be nice to preserve the possibility for the sysadmin to delete
> > > Linux-created UEFI variables that carry portions of the crash log,
> > > *without* having to mount the pstore filesystem.
> > 
> > They still have that ability with this patch - they have to chattr -i it
> > manually, or use libefivar's efi_del_variable() with a suitably new
> > libefivar, but we aren't ever actually stopping deletion.
> > 
> > Which doesn't mean you're wrong, mind you, but it does remove urgency.
> 
> Well, we should avoid having different whitelists in different kernel
> versions, so I think there is some urgency in fixing the efi-pstore
> case now.
> 
> Remember, we're breaking userspace ABI with these changes, which is a
> major downside that is only offset by the risk of bricking the
> machine. There's no chance of bricking by deleting the efi-pstore
> variables, so we'd be breaking userspace ABI for no reason.
> 
> Would something like this allow efi-pstore variables to be deleted
> (and anything else that uses LINUX_EFI_CRASH_GUID in future)?

Yes, this patch works as expected:

Acked-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Tested-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

> 
> ---
> 
> diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
> index 50f10bad2604..7f2ea21c730d 100644
> --- a/drivers/firmware/efi/vars.c
> +++ b/drivers/firmware/efi/vars.c
> @@ -198,6 +198,7 @@ static const struct variable_validate variable_validate[] = {
>  	{ EFI_GLOBAL_VARIABLE_GUID, "OsIndications", NULL },
>  	{ EFI_GLOBAL_VARIABLE_GUID, "PlatformLang", validate_ascii_string },
>  	{ EFI_GLOBAL_VARIABLE_GUID, "Timeout", validate_uint16 },
> +	{ LINUX_EFI_CRASH_GUID, "*", NULL },
>  	{ NULL_GUID, "", NULL },
>  };
