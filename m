From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: default CONFIG_EFI_STUB=y
Date: Tue, 13 Aug 2013 11:52:04 -0700
Message-ID: <520A8054.1030108@zytor.com>
References: <52050985.9070107@zytor.com>  <1376062345.2087.16.camel@dabdike.int.hansenpartnership.com>  <52050D03.4030805@zytor.com> <520A7B48.3020304@zytor.com> <1376419410.3467.67.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1376419410.3467.67.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

On 08/13/2013 11:43 AM, James Bottomley wrote:
>> James, does this address your concerns?
> 
> You mean for globally enabling CONFIG_EFI on x86?  not really for 32
> bit, you say above it's pretty much unusable; I'd prefer just to enable
> it for 64 bit.  As you said in your original post "since EFI now is a
> significant percentage of all systems" but you actually mean EFI64 ...
> EFI32 is a pretty insignificant percentage of all systems.

For better or worse, there will be more.

> Can we actually boot a 32 bit kernel on an EFI64 system?  The last time
> I tried on my Secure Boot SDV it wouldn't work; the problem is getting
> someting in the transfer of control path to boot the processor back to
> 32 bit mode.

We can boot with a bootloader in "skip stub" mode; no runtime services
yet.  We are working on making it possible to boot via a EFI stub in
assisted mode (still needing a bootloader, but with the boot stub in the
kernel.)

Runtime services will be the last piece, obviously, but even that looks
reasonably doable.

	-hpa
