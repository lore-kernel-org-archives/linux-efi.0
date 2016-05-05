From: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi/capsule: Make efi_capsule_pending() lockless
Date: Thu, 5 May 2016 15:55:26 +0100
Message-ID: <20160505155526.4b67d1f0@lxorguk.ukuu.org.uk>
References: <1462054407-9735-1-git-send-email-matt@codeblueprint.co.uk>
	<20160503090229.GC27540@pd.tnic>
	<20160503141201.GW2839@codeblueprint.co.uk>
	<20160504093031.GA4074@pd.tnic>
	<20160504114605.GH2839@codeblueprint.co.uk>
	<20160504122042.GB4074@pd.tnic>
	<20160504143531.GK2839@codeblueprint.co.uk>
	<F54AEECA5E2B9541821D670476DAE19C4A914755@PGSMSX102.gar.corp.intel.com>
	<20160505143643.GN2839@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160505143643.GN2839-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Ong, Kean Chai" <kean.chai.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 5 May 2016 15:36:43 +0100
Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> On Thu, 05 May, at 02:27:16PM, Kweh, Hock Leong wrote:
> > 
> > If not mistaken, the EFI firmware will not update a partially uploaded binary due to checksum error.
> > User is required to re-update the efi capsule again on the next boot up.  
> 
> Ah, so the capsule is only processed by the firmware after rebooting?
> That makes sense and alleviates my concerns about rebooting while in
> the middle of efi_capsule_update().

Yes - and in many cases the actions the firmware capsule update does are
done in a manner which once you exit the firmware cannot be done by the
OS. It acts as a way to communicate a block of (typically signed)
firmware to more hardware priviliged boot firmware.

Alan
