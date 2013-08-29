From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: EFI mode after running kexec
Date: Thu, 29 Aug 2013 13:53:08 -0700
Message-ID: <20130829205308.GA23141@kroah.com>
References: <20130829022632.GA26862@kroah.com>
 <CA+5PVA7jec5DAxgKachkBw1VFobz4rVMQwcqzYQ7ynk7=+d+zg@mail.gmail.com>
 <20130829191543.GA11624@kroah.com>
 <CA+5PVA5PHc4vOcWwCgTHS=CP8oei-Jc5GK2dfi=EdD_wGVZpXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+5PVA5PHc4vOcWwCgTHS=CP8oei-Jc5GK2dfi=EdD_wGVZpXQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Aug 29, 2013 at 04:36:53PM -0400, Josh Boyer wrote:
> On Thu, Aug 29, 2013 at 3:15 PM, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> > On Thu, Aug 29, 2013 at 08:18:39AM -0400, Josh Boyer wrote:
> >> On Wed, Aug 28, 2013 at 10:26 PM, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> >> > Hi all,
> >> >
> >> > I've been messing with UEFI booting a kernel and then later on, using
> >> > kexec to boot another kernel, and noticed that the kexec'ed kernel is
> >> > not really in EFI mode, although the EFI framebuffer seems present and
> >> > able to be used.
> >> >
> >> > Is this to be expected?  I'd think that the EFI framebuffer wouldn't be
> >> > around anymore.  Odds are this is a BIOS bug, given that the machine I'm
> >> > using is a really old UEFI mode (i.e. before secure boot mode ever
> >> > showed up), but should it work this way?
> >>
> >> AFAIK, it's to be expected at this point.  kexec doesn't work as it
> >> should with UEFI.
> >
> > How "should" it work?  It seems to boot a kernel just fine, although not
> > in EFI mode, which makes sense (I had forgotten about the BootServices
> > stuff.)
> 
> Right, well in my ideal world if you kexec a kernel on a UEFI machine,
> the resulting kernel is up and running as the previous kernel was.
> Which is to say, it's in UEFI mode.

I agree, that would be ideal.

> Maybe that's more hassle than it's worth but that was what I was
> thinking when I said "should".  It may be possible to use a kexec'd
> kernel as it boots today on these machines.  I believe the current
> line of thought from the kdump people is that kdump kernels could
> operate in this mode, for example.  That's a short-lived uptime and
> scoped usecase though.

For kdump, yes, but other people use kexec for "real" kernels.  Some
people use kexec as the bootloader itself, as that's the only way to
boot Linux on a platform, so they are not always short-lived at all.

thanks,

greg k-h
