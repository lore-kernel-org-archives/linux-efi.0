From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v6 0/2] Enable capsule loader interface for efi firmware updating
Date: Fri, 2 Oct 2015 21:18:05 -0700
Message-ID: <CALCETrVB_QbG3Se2YHqUQx2SiZBrsNw95wRJrtLtFPJmxn_svA@mail.gmail.com>
References: <1443733554-22743-1-git-send-email-hock.leong.kweh@intel.com> <20151002173704.GD16538@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151002173704.GD16538-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ong Boon Leong <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Fleming Matt <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Oct 2, 2015 10:37 AM, "Borislav Petkov" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org> wrote:
>
> On Fri, Oct 02, 2015 at 05:05:52AM +0800, Kweh, Hock Leong wrote:
> > From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > Dear maintainers & communities,
> >
> > This patchset is created on top of Matt's patchset:
> > 1.)https://lkml.org/lkml/2014/10/7/390
> > "[PATCH 1/2] efi: Move efi_status_to_err() to efi.h"
> > 2.)https://lkml.org/lkml/2014/10/7/391
> > "[PATCH 2/2] efi: Capsule update support"
> >
> > It expose a misc char interface for user to upload the capsule binary and
> > calling efi_capsule_update() API to pass the binary to EFI firmware.
> >
> > The steps to update efi firmware are:
> > 1.) cat firmware.cap > /dev/efi_capsule_loader
> > 2.) reboot
> >
> > Any failed upload error message will be returned while doing "cat" through
> > Write() function call.
> >
> > Tested the code with Intel Quark Galileo platform.
>
> What does the error case look like? A standard glibc message about
> write(2) failing?
>

close(2), right?

--Andy
