From: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>
Subject: Re: [PATCH 1/3] arm64: add EFI stub
Date: Fri, 06 Dec 2013 12:25:11 +0000
Message-ID: <20131206122511.301D6C40757@trevor.secretlab.ca>
References: <1385762712-17043-1-git-send-email-msalter@redhat.com> < 1385762712-17043-2-git-send-email-msalter@redhat.com> <20131205141853.GA974 @darko.cambridge.arm.com> <1386254603.1861.120.camel@deneb.redhat.com> < 20131205152806.GC974@darko.cambridge.arm.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131205152806.GC974-rtzwXk+D4rEjOxct69p1ducL+3YJyIBv@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 5 Dec 2013 15:28:06 +0000, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org> wrote:
> On Thu, Dec 05, 2013 at 02:43:23PM +0000, Mark Salter wrote:
> > On Thu, 2013-12-05 at 14:18 +0000, Catalin Marinas wrote:
> > > On Fri, Nov 29, 2013 at 10:05:10PM +0000, Mark Salter wrote:
> > > > This patch adds PE/COFF header fields to the start of the Image
> > > > so that it appears as an EFI application to EFI firmware. An EFI
> > > > stub is included to allow direct booting of the kernel Image. Due
> > > > to EFI firmware limitations, only little endian kernels with 4K
> > > > page sizes are supported at this time.
> > > 
> > > I don't fully understand the EFI firmware limitations but for big endian
> > > we could have the EFI_STUB wrapper in little endian and get the kernel
> > > to switch to big endian once booted. The image header should always be
> > > little endian.
> > 
> > That would be fun. :) You'd also have to switch back and forth to make
> > EFI runtime services calls.
> 
> OK, we'll have to live with this restriction.

Or just disable runtime services on the switch to big ending. Big endian
should not disable the stub (but getting it to work could be a follow-up
patch)

g.
