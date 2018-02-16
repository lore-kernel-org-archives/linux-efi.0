From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 0/2] efivars: reading variables can generate SMIs
Date: Fri, 16 Feb 2018 21:45:19 +0000
Message-ID: <CALCETrXD4qCwgnDcwnybUXzVk7zyJtzHC2xzLfcZvzrXvAB8PQ@mail.gmail.com>
References: <20180215182208.35003-1-joe.konno@linux.intel.com>
 <CAKv+Gu80pJ5tbGoJqBm8CCKrEZXdkE83c944383KbQ5jREUC0Q@mail.gmail.com>
 <1518814319.4419.10.camel@HansenPartnership.com> <3908561D78D1C84285E8C5FCA982C28F7B37942B@ORSMSX110.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F7B37942B@ORSMSX110.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luck, Tony" <tony.luck@intel.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Joe Konno <joe.konno@linux.intel.com>, Matthew Garrett <mjg59@google.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jeremy Kerr <jk@ozlabs.org>, Andi Kleen <ak@linux.intel.com>, Benjamin Drung <benjamin.drung@profitbricks.com>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Feb 16, 2018 at 9:09 PM, Luck, Tony <tony.luck@intel.com> wrote:
>> That said, I'm not sure how many non-root users run the toolkit to
>> extract their EFI certificates or check on the secure boot status of
>> the system, but I suspect it might be non-zero: I can see the tinfoil
>> hat people wanting at least to check the secure boot status when they
>> log in.
>
> Another fix option might be to rate limit EFI calls for non-root users (on X86
> since only we have the SMI problem). That would:
>
> 1) Avoid using memory to cache all the variables
> 2) Catch any other places where non-root users can call EFI

I'm going to go out on a limb and suggest that the fact that
unprivileged users can read efi variables at all is a mistake
regardless of SMI issues.

Also, chmod() just shouldn't work on efi variables, and the mode
passed to creat() should be ignored.  After all, there's no backing
store for the mode.
