From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] arm64: add EFI stub
Date: Thu, 05 Dec 2013 09:43:23 -0500
Message-ID: <1386254603.1861.120.camel@deneb.redhat.com>
References: <1385762712-17043-1-git-send-email-msalter@redhat.com>
	 <1385762712-17043-2-git-send-email-msalter@redhat.com>
	 <20131205141853.GA974@darko.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131205141853.GA974-rtzwXk+D4rEjOxct69p1ducL+3YJyIBv@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2013-12-05 at 14:18 +0000, Catalin Marinas wrote:
> On Fri, Nov 29, 2013 at 10:05:10PM +0000, Mark Salter wrote:
> > This patch adds PE/COFF header fields to the start of the Image
> > so that it appears as an EFI application to EFI firmware. An EFI
> > stub is included to allow direct booting of the kernel Image. Due
> > to EFI firmware limitations, only little endian kernels with 4K
> > page sizes are supported at this time.
> 
> I don't fully understand the EFI firmware limitations but for big endian
> we could have the EFI_STUB wrapper in little endian and get the kernel
> to switch to big endian once booted. The image header should always be
> little endian.

That would be fun. :) You'd also have to switch back and forth to make
EFI runtime services calls.

> 
> And I have to dig further into the 4K limitation (or you could give a
> quick summary ;)).

Just that the current UEFI spec mandates 4K pages for UEFI. So if UEFI
maps two 4k pages with different attributes and those two pages are
within the same 64k kernel page, there'd be a problem. I'd be better if
UEFI used 64k pages, then the kernel could easily use 4k or 64k.

--Mark
