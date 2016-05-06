From: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Subject: Re: [PATCH] efi/capsule: Make efi_capsule_pending() lockless
Date: Fri, 06 May 2016 02:32:03 +0100
Message-ID: <1462498323.2404.8.camel@nexus-software.ie>
References: <1462054407-9735-1-git-send-email-matt@codeblueprint.co.uk>
	 <20160503090229.GC27540@pd.tnic>
	 <20160503141201.GW2839@codeblueprint.co.uk> <20160504093031.GA4074@pd.tnic>
	 <20160504114605.GH2839@codeblueprint.co.uk> <20160504122042.GB4074@pd.tnic>
	 <20160504143531.GK2839@codeblueprint.co.uk>
	 <F54AEECA5E2B9541821D670476DAE19C4A914755@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C4A914755-j2khPEwRog0FyVwBAnZdSLfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Ong, Kean Chai" <kean.chai.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2016-05-05 at 14:27 +0000, Kweh, Hock Leong wrote:
> > -----Original Message-----
> > From: Matt Fleming [mailto:matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org]
> > Sent: Wednesday, May 04, 2016 10:36 PM
> > To: Kweh, Hock Leong; Bryan O'Donoghue
> > Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Ard
> > Biesheuvel;
> > joeyli; Borislav Petkov
> > Subject: Re: [PATCH] efi/capsule: Make efi_capsule_pending()
> > lockless
> > 
> > On Wed, 04 May, at 02:20:42PM, Borislav Petkov wrote:
> > > 
> > > Blergh.
> > 
> > Wilson, Bryan, what kind of rollback support does the Intel Quark
> > have if its
> > firmware update is interrupted?
> > 
> > The interruption could be for a number of reasons including power
> > loss, or
> > the example in this case, rebooting due to panic().
> 
> If not mistaken, the EFI firmware will not update a partially
> uploaded binary due to checksum error.
> User is required to re-update the efi capsule again on the next boot
> up.
> 

If the checksum fails then you're fine since you won't update flash.

OTOH if you pull the plug we actually have a backup image - so even a
partially flashed update shouldn't brick the system.

How well that actually works i.e. is it tested in anger ? Meh - YMMV
there fore sure.

---
bod
