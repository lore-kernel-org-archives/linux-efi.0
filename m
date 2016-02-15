From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v11 1/1] efi: a misc char interface for user to update
 efi firmware
Date: Mon, 15 Feb 2016 06:46:33 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C4A8E04F6@PGSMSX102.gar.corp.intel.com>
References: <1454042394-21507-1-git-send-email-hock.leong.kweh@intel.com>
 <1454042394-21507-2-git-send-email-hock.leong.kweh@intel.com>
 <20160208151342.GB2413@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160208151342.GB2413-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Anvin, H Peter" <h.peter.anvin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> -----Original Message-----
> From: Matt Fleming [mailto:matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org]
> Sent: Monday, February 08, 2016 11:14 PM
> 
> On Fri, 29 Jan, at 12:39:54PM, Kweh Hock Leong wrote:
> > From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > Introducing a kernel module to expose capsule loader interface
> > (misc char device file note) for users to upload capsule binaries.
> >
> > Example:
> > cat firmware.bin > /dev/efi_capsule_loader
> >
> > This patch also export efi_capsule_supported() function symbol for
> > verifying the submitted capsule header in this kernel module.
> >
> > Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> > Signed-off-by: Kweh, Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  drivers/firmware/efi/Kconfig          |    9 +
> >  drivers/firmware/efi/Makefile         |    1 +
> >  drivers/firmware/efi/capsule-loader.c |  334
> +++++++++++++++++++++++++++++++++
> >  drivers/firmware/efi/capsule.c        |    1 +
> >  4 files changed, 345 insertions(+)
> >  create mode 100644 drivers/firmware/efi/capsule-loader.c
> 
> OK, I've picked this up. I did make some modifications based on
> Bryan's comments from v10 of this patch.
> 
> You can see a diff of the changes below, but roughly,
> 
>  1. Use Bryan's comments for changelog and expand it a bit
>  2. Add more detail to Kconfig entry, most people don't need this
>  3. Sprinkled comments from Bryan in the kerneldoc comments
>  4. Deleted a level of indentation in efi_capsule_setup_info()
>  5. Local variable instead of indexing ->pages in efi_capsule_write()
>  6. Fix memory leak in efi_capsule_open()
> 
> My plan is to include this patch in the EFI capsule series, and resend
> the whole thing out.
> 

Thank Matt and also appreciate others who helped on reviewing, testing
as well as provided design idea.


Thanks & Regards,
Wilson
