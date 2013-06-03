From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH 0/4] EFI 1:1 mapping
Date: Mon, 03 Jun 2013 07:27:22 -0700
Message-ID: <1370269642.2910.4.camel@dabdike>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
	 <20130602225620.GA5496@srcf.ucam.org> <20130603081148.GB13607@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130603081148.GB13607-K5JNixvcfoxupOikMc4+xw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, X86-ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2013-06-03 at 10:11 +0200, Borislav Petkov wrote:
> On Sun, Jun 02, 2013 at 11:56:20PM +0100, Matthew Garrett wrote:
> > I've just run Windows 8 under a hacked up copy of OVMF that dumps
> > the data passed to SetVirtualAddressMap. It seems that Windows *is*
> > mapping the runtime services to higher addresses - so presumably the
> > 1:1 mapping is in addition to the virtual mapping.
> 
> But but, once we call SetVirtualAddressMap with the set of addresses of
> the runtime services, only those can be used after, right? If so, we
> can't have both (this is at least my understanding)...

That's correct.  I think not calling SetVirtualAddressMap() and just
using a 1:1 mapping is far safer (having looked at what tianocore does
for SetVirtualAddressMap()).  The chances are that all the UEFI bioses
are only tested with windows, so the pointer chases it has to do to
switch address maps only work with the operations windows does.

James
