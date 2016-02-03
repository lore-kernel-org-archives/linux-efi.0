From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 5/5] efi: Make efivarfs entries immutable by default.
Date: Wed, 3 Feb 2016 14:13:54 +0000
Message-ID: <20160203141354.GH2597@codeblueprint.co.uk>
References: <1454504567-2826-1-git-send-email-pjones@redhat.com>
 <1454504567-2826-5-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454504567-2826-5-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 03 Feb, at 08:02:47AM, Peter Jones wrote:
> "rm -rf" is bricking some peoples' laptops because of variables being
> used to store non-reinitializable firmware driver data that's required
> to POST the hardware.
> 
> These are 100% bugs, and they need to be fixed, but in the mean time it
> shouldn't be easy to *accidentally* brick machines.
> 
> We have to have delete working, and picking which variables do and don't
> work for deletion is quite intractable, so instead make everything
> immutable by default (except for a whitelist), and make tools that
> aren't quite so broad-spectrum unset the immutable flag.
> 
> v2: adds Timeout to our whitelist.
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/firmware/efi/vars.c | 83 +++++++++++++++++++++++++++++++++------------
>  fs/efivarfs/file.c          | 69 +++++++++++++++++++++++++++++++++++++
>  fs/efivarfs/inode.c         | 32 +++++++++++------
>  fs/efivarfs/internal.h      |  3 +-
>  fs/efivarfs/super.c         |  9 +++--
>  include/linux/efi.h         |  2 ++
>  6 files changed, 163 insertions(+), 35 deletions(-)

I see no mention of the benefit of using the immutable flag versus
making all protected files read-only.

Is it not possible to just make everything that needs protecting 444?
That way users can use standard tools if they really, really want to
delete/write to a variable. It has the added benefit of protecting
users from trashing variables that are important for POST too (as
opposed to deleting them altogether).
