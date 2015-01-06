From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [GIT PULL] EFI changes for next
Date: Tue, 6 Jan 2015 13:04:36 +0000
Message-ID: <20150106130436.GJ3163@console-pimps.org>
References: <1420486089.17206.35.camel@ranerica-desk01>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1420486089.17206.35.camel@ranerica-desk01>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 05 Jan, at 11:28:09AM, Ricardo Neri wrote:
> Hi Matt,
> 
> Please pull the following changes for next. This includes a change in
> the help text of EFI firmware Kconfig to update the URL of efibootgr.
> 
> It also renames the efi_guid_unparse to reflect better the behavior of
> the function.
> 
> Thanks and BR,
> Ricardo
> 
> The following changes since commit
> b7392d2247cfe6771f95d256374f1a8e6a6f48d6:
> 
>   Linux 3.19-rc2 (2014-12-28 16:49:37 -0800)
 
Is there a reason that you based the patches onto -rc2?

What I tend to do is try and apply the patches onto the existing EFI
'next' branch first. If they don't apply only then will I rebase 'next'
onto a more recent release tag.

This is a habit I picked up from the tip folks, and it keeps the history
much cleaner.

Both of the below commits apply cleanly on 'next' (which is based on
v3.18-rc2). Could you send me another pull request against 'next'?
Thanks!

> are available in the git repository at:
> 
>   https://github.com/ricardon/efi.git tags/rneri-efi-next
> 
> for you to fetch changes up to 2364a022398a7cda70494cf53b1b529bf88830b0:
> 
>   efi: mv efi_guid_unparse -> efi_guid_to_str (2014-12-31 16:40:09
> -0800)
> 
> ----------------------------------------------------------------
> Updates on EFI firmware Kconfig help text and a function rename
> 
> ----------------------------------------------------------------
> Borislav Petkov (1):
>       efi: mv efi_guid_unparse -> efi_guid_to_str
 
Borislav, you're renaming the function, not moving it. The rest of the
commit log is fine but how about rewording the title to,

  "efi: Rename efi_guid_unparse to efi_guid_to_str"

I don't think you need to resubmit it, I'd usually fix this up when I
applied your patch, so Ricardo can do that before he resends his pull.

> Peter Jones (1):
>       Update the URLs for efibootmgr.
 
This commit needs a subsystem prefix ("efi:"), and we should probably Cc
Matt Domsch too. Ricardo could you take care of this, unless Peter
objects?

-- 
Matt Fleming, Intel Open Source Technology Center
