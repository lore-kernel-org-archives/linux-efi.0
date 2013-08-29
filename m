From: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Subject: Re: EFI mode after running kexec
Date: Thu, 29 Aug 2013 08:18:39 -0400
Message-ID: <CA+5PVA7jec5DAxgKachkBw1VFobz4rVMQwcqzYQ7ynk7=+d+zg@mail.gmail.com>
References: <20130829022632.GA26862@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130829022632.GA26862-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Aug 28, 2013 at 10:26 PM, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> Hi all,
>
> I've been messing with UEFI booting a kernel and then later on, using
> kexec to boot another kernel, and noticed that the kexec'ed kernel is
> not really in EFI mode, although the EFI framebuffer seems present and
> able to be used.
>
> Is this to be expected?  I'd think that the EFI framebuffer wouldn't be
> around anymore.  Odds are this is a BIOS bug, given that the machine I'm
> using is a really old UEFI mode (i.e. before secure boot mode ever
> showed up), but should it work this way?

AFAIK, it's to be expected at this point.  kexec doesn't work as it
should with UEFI.  I believe Matthew and/or Matt can elaborate
further, but it has to do with only being able to call
ExitBootServices once and providing mappings to the UEFI Runtime
services functions.

> And, to get kexec to run the kernel in EFI mode, would require kexec to
> treat the kernel as a EFI binary and run it that way, instead of the
> "normal" way it currently is, right?

I think so.

josh
