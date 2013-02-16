From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efi: split efisubsystem from efivars
Date: Sat, 16 Feb 2013 09:52:05 +0000
Message-ID: <1361008325.8381.7.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1359128215-1331-1-git-send-email-teg@jklm.no>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359128215-1331-1-git-send-email-teg-B22kvLQNl6c@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Chun-Yi Lee <jlee-IBi9RG/b67k@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2013-01-25 at 16:36 +0100, Tom Gundersen wrote:
> This registers /sys/firmware/efi{,/efivars} whenever EFI is enabled
> and the system supports it.
> 
> This allows
>  *) userspace to check for the existence of /sys/firmware/efi as a way
>     to determine whether or it is running on an EFI system.
>  *) 'mount -t efivarfs none /sys/firmware/efi/efivars' without manually
>     loading any modules.
> 
> Signed-off-by: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>
> Cc: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
> Cc: Chun-Yi Lee <jlee-IBi9RG/b67k@public.gmane.org>
> Cc: Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>  drivers/firmware/Makefile    |  1 +
>  drivers/firmware/efisubsys.c | 52 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/firmware/efivars.c   | 30 +++++--------------------
>  3 files changed, 59 insertions(+), 24 deletions(-)
>  create mode 100644 drivers/firmware/efisubsys.c

Tom, could you have a go at rebasing this patch on top of the 'chainsaw'
branch at,

    git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/linux.git

Though, instead of drivers/firmware/efisubsys.c just put the core stuff
in drivers/firmware/efi/efi.c. The efivar_entry() API code should
probably be moved to drivers/firmware/efi/variable.c or
drivers/firmware/efi/vars.c, etc. That way, we can finally delete
efivars.c and have all the EFI code under drivers/firmware/efi/.

Make sense?

P.s I ended up dropping your MODULE_ALIAS() patch on this branch because
I feel that moving the efivarfs code into fs/efivarfs is a better way to
fix up the confusion that efivars != efivarfs, plus building fs/efivarfs
as a module results in an efivarfs.ko file ;-)
