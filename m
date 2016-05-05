From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] efi/capsule: Make efi_capsule_pending() lockless
Date: Thu, 5 May 2016 14:27:16 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C4A914755@PGSMSX102.gar.corp.intel.com>
References: <1462054407-9735-1-git-send-email-matt@codeblueprint.co.uk>
 <20160503090229.GC27540@pd.tnic> <20160503141201.GW2839@codeblueprint.co.uk>
 <20160504093031.GA4074@pd.tnic> <20160504114605.GH2839@codeblueprint.co.uk>
 <20160504122042.GB4074@pd.tnic> <20160504143531.GK2839@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160504143531.GK2839-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Ong, Kean Chai" <kean.chai.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> -----Original Message-----
> From: Matt Fleming [mailto:matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org]
> Sent: Wednesday, May 04, 2016 10:36 PM
> To: Kweh, Hock Leong; Bryan O'Donoghue
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Ard Biesheuvel;
> joeyli; Borislav Petkov
> Subject: Re: [PATCH] efi/capsule: Make efi_capsule_pending() lockless
> 
> On Wed, 04 May, at 02:20:42PM, Borislav Petkov wrote:
> >
> > Blergh.
> 
> Wilson, Bryan, what kind of rollback support does the Intel Quark have if its
> firmware update is interrupted?
> 
> The interruption could be for a number of reasons including power loss, or
> the example in this case, rebooting due to panic().

If not mistaken, the EFI firmware will not update a partially uploaded binary due to checksum error.
User is required to re-update the efi capsule again on the next boot up.


Regards,
Wilson
