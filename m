From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: MemoryOverwriteRequestControl
Date: Mon, 04 Jul 2016 14:31:57 -0700
Message-ID: <1467667917.2288.23.camel@HansenPartnership.com>
References: <CACxGe6s7rgTBUf7jtN6J3i3w-HvAm2rFnjjwCtWRS6oHx3ZB5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACxGe6s7rgTBUf7jtN6J3i3w-HvAm2rFnjjwCtWRS6oHx3ZB5A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2016-07-04 at 20:37 +0100, Grant Likely wrote:
> Random question: Does anybody (kernel or distros) do anything with 
> the MemoryOverwriteRequestControl EFI variable? I was asked by a 
> platform engineer for input on what Linux needs, and I didn't have an 
> answer for him.

The usual answer for these cases is to do what Tianocore does.

Currently, the kernel does nothing with this, but you'd more expect
something in userspace to do something with it, probably a component of
the TSS.

> Reference: section 5 of
> https://www.trustedcomputinggroup.org/wp-content/uploads/Platform-Res
> et-Attack-Mitigation-Specification.pdf

That's a bit of an old Spec.  Microsoft has been busy updating this
stuff:

https://msdn.microsoft.com/en-us/windows/hardware/drivers/bringup/device-guard-requirements

Tianocore head seems to do all of this.

James
