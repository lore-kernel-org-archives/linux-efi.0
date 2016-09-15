From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] efi: Format EFI version prints the way the standard
 says.
Date: Thu, 15 Sep 2016 09:13:05 -0400
Message-ID: <20160915131305.5mhdpc6vql5nv2gw@redhat.com>
References: <20160907122339.GB28333@wunner.de>
 <1473260186-4500-1-git-send-email-pjones@redhat.com>
 <1473260186-4500-3-git-send-email-pjones@redhat.com>
 <20160915091822.GA16797@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160915091822.GA16797-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Sep 15, 2016 at 10:18:22AM +0100, Matt Fleming wrote:
> On Wed, 07 Sep, at 10:56:26AM, Peter Jones wrote:
> > We print "EFI v2.xx.yy vendor blahblah" at several places.  Make them
> > conform to the standard format.
> > 
> > This leaves 2 checkpatch warnings in arch/ia64/kernel/efi.c intact; the
> > old code would have produced them, and they match the nearby code in the
> > functions.
> > 
> > Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
> > ---
> >  arch/ia64/kernel/efi.c          | 14 ++++++--------
> >  arch/x86/platform/efi/efi.c     | 20 ++++++++++++--------
> >  drivers/firmware/efi/arm-init.c | 13 ++++++-------
> >  drivers/firmware/efi/efi.c      | 16 +++++++++++++---
> >  include/linux/efi.h             |  2 ++
> >  5 files changed, 39 insertions(+), 26 deletions(-)
> 
> I'm not sure about this one. Booting with this patch on my test VMs I
> see the old,
> 
>   efi: EFI v2.40 by EDK II
> 
> now reading,
> 
>   efi: EFI v2.4 by EDK II
> 
> Yes, the new string is obviously more correct but gratuitous changes
> to the strings we print on boot have caused trouble in the past. If
> people have scripts or tests that check the EFI version that gets
> printed they'll break.
> 
> Are there any additional supporting reasons for this patch?

Really I just prefer to have them say the same thing the spec does - but
your point is certainly valid.  Would you be happier with it if I put a
check in that only prints the new way for, say, revisions newer than
2.6, and prints them the older way otherwise?

-- 
  Peter
