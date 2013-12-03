From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] arm64: add EFI stub
Date: Tue, 03 Dec 2013 14:31:30 -0500
Message-ID: <1386099090.1861.55.camel@deneb.redhat.com>
References: <1385762712-17043-1-git-send-email-msalter@redhat.com>
	 <1385762712-17043-2-git-send-email-msalter@redhat.com>
	 <20131203183844.GA22668@mudshark.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131203183844.GA22668-MRww78TxoiP5vMa5CHWGZ34zcgK1vI+I0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2013-12-03 at 18:38 +0000, Will Deacon wrote:
> Hi Mark, Roy,
> 
> On Fri, Nov 29, 2013 at 10:05:10PM +0000, Mark Salter wrote:
> > This patch adds PE/COFF header fields to the start of the Image
> > so that it appears as an EFI application to EFI firmware. An EFI
> > stub is included to allow direct booting of the kernel Image. Due
> > to EFI firmware limitations, only little endian kernels with 4K
> > page sizes are supported at this time. Support in the COFF header
> > for signed images was provided by Ard Biesheuvel.
> 
> I haven't really jumped into this but, whilst I see the use of EFI_STUB on
> both arm and arm64, there seems to be some duplication/reinvention between
> the two series you've put together.

Indeed. As the file banner says, the arm64 stub started out from the arm
code.

> 
> Maybe I'm just being ignorant, but the stuff in efi-stub.c really looks to
> be doing the same thing on both architectures. Would you guys be able to
> work to together to produce an independent series containing the common
> parts, then add arm/arm64 backends on top of that please? In particular,
> factoring out the device-tree parts ensures that we don't introduce subtle
> differences between the two architectures when there's no real need to do
> so...
> 
> ...or shout at me because I didn't understand what you were doing!

Along the way, Roy has pulled out common bits into:
   drivers/firmware/efi-stub-helper.c
and
   drivers/firmware/fdt.c

There are arguably more bits which could be made common but there's not
really a lot left. There are differences between the two stubs which
limit what we can do. The arm stub is not part of the kernel (it is part
of the zImage wrapper) but the arm64 stub is. So arm64 has a little more
flexibility for using kernel facilities (__init attribute, LIBFDT, etc).

--Mark
