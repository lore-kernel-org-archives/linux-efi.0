From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v6 0/5] efi/firmware/platform-x86: Add EFI embedded fw support
Date: Sun, 3 Jun 2018 18:39:09 +0200
Message-ID: <CAKv+Gu9v+BUTySe=0OWmjPSCe5qShO5r4P4Np7M8q2jR_tMcDQ@mail.gmail.com>
References: <20180601125330.25054-1-hdegoede@redhat.com> <CALCETrXC2iuvHnTsnz=6Z_OqeMhiv9aSs372cGpsii021jsZrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXC2iuvHnTsnz=6Z_OqeMhiv9aSs372cGpsii021jsZrg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Martin Fuzzey <mfuzzey@parkeon.com>, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Linus Torvalds <torvalds@linux-foundation.org>, Nicolas Broeking <nbr>
List-Id: linux-efi@vger.kernel.org

On 2 June 2018 at 05:39, Andy Lutomirski <luto@kernel.org> wrote:
> On Fri, Jun 1, 2018 at 5:53 AM Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> Hi All,
>>
>> Here is v6 of my patch-set to add support for EFI embedded fw to the kernel.
>>
>> This patch-set applies on top of the "[PATCH v7 00/14] firmware_loader
>> changes for v4.18" series from mcgrof.
>>
>> It now also depends on the series from Andy Lutomirski which allow using the
>> sha256 code in a standalone manner. Andy what is the status of those?
>
> They're currently sort of on hold, since Jason Donenfeld is working on
> a more comprehensive solution to the same problem.  Jason, I don't
> suppose the sha256 part of your patch set is ready?
>
> Ard, if Jason's patches are too far in the future, would you be okay
> with merging a cleaned-up version of my patch for sha256 even if the
> sha512 equivalent isn't there?
>

I'm not sure what you are asking me here. I'd be fine merging a
version of Hans's patches that uses a suitable cryptographic hash
algorithm, but the implementation of that would likely belong
somewhere under crypto/, and so it is ultimately someone else's call
(although I'm happy to review)
