From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 06/10] arm64: efi: add EFI stub
Date: Thu, 10 Apr 2014 08:54:02 -0400
Message-ID: <1397134442.31272.38.camel@deneb.redhat.com>
References: <1396637113-22790-1-git-send-email-leif.lindholm@linaro.org>
	 <1396637113-22790-7-git-send-email-leif.lindholm@linaro.org>
	 <20140409142013.GC26210@e106331-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140409142013.GC26210-NuALmloUBlrZROr8t4l/smS4ubULX0JqMm0uRHvK7Nw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2014-04-09 at 15:20 +0100, Mark Rutland wrote:
> >
> > +config EFI
> > +       bool "UEFI firmware support"
> > +       depends on OF
> 
> I note we're not depending on !CPU_BIG_ENDIAN here, and it looks like
> the implementation is not endian-clean (I've pointed out a few issues
> below).
> 
> We need to fix that up for CPU_BIG_ENDIAN. For the moment we could
> depend on !CPU_BIG_ENDIAN which would at least to make it clear we don't
> support EFI && CPU_BIG_ENDIAN yet. The commit message should be updated
> to mention that.
> 

Yes, the !CPU_BIG_ENDIAN was there at one point but got lost along
the way. It may be best to put it back for now, but I'll take a
stab at getting the stub part sorted out based on your comments.
Full runtime services will be trickier and need a followup patch in
the future after the initial patch series goes in.
