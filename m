From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Tue, 3 Mar 2015 13:56:30 -0800
Message-ID: <CALCETrVVC2bqM9KAbb6A_2kN=fwbKer5VZ-nZdKW8J_MNrM-MA@mail.gmail.com>
References: <F54AEECA5E2B9541821D670476DAE19C2B8AD9CA@PGSMSX102.gar.corp.intel.com>
 <20150302122955.GB24476@codeblueprint.co.uk> <F54AEECA5E2B9541821D670476DAE19C2B8ADC41@PGSMSX102.gar.corp.intel.com>
 <CALCETrXfjbKcYSSRQXZbam7TgHU34LXM0BhvMuba_vYyCCPTig@mail.gmail.com> <20150303204956.GG25768@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150303204956.GG25768@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>, Ong Boon Leong <boon.leong.ong@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sam Protsenko <semen.protsenko@linaro.org>, "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, LKML <linux-kernel@vger.kernel.org>, Ming Lei <ming.lei@canonical.com>
List-Id: linux-efi@vger.kernel.org

On Mar 3, 2015 12:51 PM, "Borislav Petkov" <bp@alien8.de> wrote:
>
> On Tue, Mar 03, 2015 at 12:37:54PM -0800, Andy Lutomirski wrote:
> > The user *should not* be required to have write access to anything in
> > /lib to install a UEFI capsule that they download from their
> > motherboard vendor's website.  /lib belongs to the distro, and UEFI
> > capsules do not belong to the distro.  In this regard, UEFI capsules
> > are completely unlike your wireless card firmware, your cpu microcode,
> > etc.
>
> Oh oh but but, if an UEFI capsule can brick the system, a normal user
> would be able to brick that system then. I think we should forbid that.

Absolutely.  That's why I said

# uefi-load-capsule

and not

$ uefi-load-capsule

:)

>
> I agree with the rest of your note that a simple
>
> cat <fw_blob> > /sys/...
>
> should be enough.
>
> --
> Regards/Gruss,
>     Boris.
>
> ECO tip #101: Trim your mails when you reply.
> --
