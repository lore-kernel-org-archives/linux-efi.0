From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v6 0/5] efi/firmware/platform-x86: Add EFI embedded fw support
Date: Wed, 6 Jun 2018 11:40:52 -0700
Message-ID: <CALCETrVEw9cfHrxRmY3z+B9hS3X=QT0A4_bsX3nPp3h6oLBY7Q@mail.gmail.com>
References: <20180601125330.25054-1-hdegoede@redhat.com> <20180605204623.GB4511@wotan.suse.de>
 <350930d6-5a0f-11e1-1b04-e5c11961931b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <350930d6-5a0f-11e1-1b04-e5c11961931b@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Greg KH <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Peter Jones <pjones@redhat.com>, dave@bewaar.me, Will Deacon <will.deacon@arm.com>, Andrew Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Josh Triplett <josh@joshtriplett.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Martin Fuzzey <mfuzzey@parkeon.com>, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Linus Torvalds <torvalds@linux-foundation.org>, Nicolas Broeking <nbroeking@me.com>
List-Id: linux-efi@vger.kernel.org

On Wed, Jun 6, 2018 at 11:17 AM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi,
>
> On 05-06-18 22:46, Luis R. Rodriguez wrote:
> > On Fri, Jun 01, 2018 at 02:53:25PM +0200, Hans de Goede wrote:
> >> Hi All,
> >>
> >> Here is v6 of my patch-set to add support for EFI embedded fw to the kernel.
> >>
> >> This patch-set applies on top of the "[PATCH v7 00/14] firmware_loader
> >> changes for v4.18" series from mcgrof.
> >>
> >> It now also depends on the series from Andy Lutomirski which allow using the
> >> sha256 code in a standalone manner. Andy what is the status of those?
> >>
> >> Changes since v5:
> >> -Rework code to remove casts from if (prefix == mem) comparison
> >> -Use SHA256 hashes instead of crc32 sums
> >
> > Nice! I see no updates on this progress, but it would seem this
> > may then mean this cannot be merged until the release after?
>
> Once the sha256 bits are in place the subsys tree which has them
> merged can create an immutable branch for Greg to merge and
> then these can be applied on top of that merge.
>
> But yes this means that these probably won't go in for another
> cycle or 2, that is fine.
>
> >> -Add new READING_FIRMWARE_EFI_EMBEDDED read_file_id and use it
> >> -Call security_kernel_read_file(NULL, READING_FIRMWARE_EFI_EMBEDDED)
> >>   to check if this is allowed before looking at EFI embedded fw
> >
> > There's a discussion over having security_kernel_read_file(NULL,
> > READING_WHATEVER) become another LSM hook. So your series would conflict with
> > that at the moment.
> >
> > So yet another piece of code which this series depends on.
>
> Ah well, I'm in no big hurry to get this merged. OTOH if this is
> ready and that discussion is not yet finished it might be better
> to merge this as is and then have the security_kernel_read_file / LSM
> hook series fix this up as necessary when it is merged.
>

Let's give Jason a bit longer to reply.  I know he's actively working
on this thing, but it's part of a bigger project.
