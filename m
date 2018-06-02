From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v6 0/5] efi/firmware/platform-x86: Add EFI embedded fw support
Date: Fri, 1 Jun 2018 20:39:18 -0700
Message-ID: <CALCETrXC2iuvHnTsnz=6Z_OqeMhiv9aSs372cGpsii021jsZrg@mail.gmail.com>
References: <20180601125330.25054-1-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180601125330.25054-1-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Peter Jones <pjones@redhat.com>, dave@bewaar.me, Will Deacon <will.deacon@arm.com>, Andrew Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Martin Fuzzey <mfuzzey@parkeon.com>, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Linus Torvalds <torvalds@linux-foundation.org>, Nicolas Broeking <nbroeking@me.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Jun 1, 2018 at 5:53 AM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi All,
>
> Here is v6 of my patch-set to add support for EFI embedded fw to the kernel.
>
> This patch-set applies on top of the "[PATCH v7 00/14] firmware_loader
> changes for v4.18" series from mcgrof.
>
> It now also depends on the series from Andy Lutomirski which allow using the
> sha256 code in a standalone manner. Andy what is the status of those?

They're currently sort of on hold, since Jason Donenfeld is working on
a more comprehensive solution to the same problem.  Jason, I don't
suppose the sha256 part of your patch set is ready?

Ard, if Jason's patches are too far in the future, would you be okay
with merging a cleaned-up version of my patch for sha256 even if the
sha512 equivalent isn't there?

--Andy
