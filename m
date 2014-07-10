From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v2] x86/efi: autoload efivars
Date: Thu, 10 Jul 2014 19:25:31 +0100
Message-ID: <20140710182531.GA5952@console-pimps.org>
References: <1404902369-19434-1-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1404902369-19434-1-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 09 Jul, at 06:39:29PM, Lee, Chun-Yi wrote:
> The original patch is from Ben Hutchings's contribution to debian
> kernel. Got Ben's permission to remove the code of efi-pstore.c and
> send to linux-efi:
> https://github.com/BlankOn/linux-debian/blob/master/debian/patches/features/all/efi-autoload-efivars.patch
> 
> efivars is generally useful to have on EFI systems, and in some cases
> it may be impossible to load it after a kernel upgrade in order to
> complete a boot loader update. At the same time we don't want to waste
> memory on non-EFI systems by making them built-in.
> 
> Instead, give them module aliases as if they are platform drivers, and
> register a corresponding platform device whenever EFI runtime services
> are available.  This should trigger udev to load them.
> 
> v2:
> Moving platform device register code to drivers/firmware/efi/efi.c
> ARM64 folks could also benefit from it.
> 
> Cc: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> ---
>  drivers/firmware/efi/efi.c     | 15 +++++++++++++++
>  drivers/firmware/efi/efivars.c |  1 +
>  2 files changed, 16 insertions(+)

Thanks, applied.

-- 
Matt Fleming, Intel Open Source Technology Center
