From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/2] efivars: reading variables can generate SMIs
Date: Fri, 16 Feb 2018 10:58:47 +0000
Message-ID: <CAKv+Gu8qm2wFxY56-eRLkLZB6fRUCmZbZo=4cvo5e4JDFh01Gg@mail.gmail.com>
References: <20180215182208.35003-1-joe.konno@linux.intel.com>
 <CAKv+Gu80pJ5tbGoJqBm8CCKrEZXdkE83c944383KbQ5jREUC0Q@mail.gmail.com> <20180216105548.GA29042@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180216105548.GA29042@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Joe Konno <joe.konno@linux.intel.com>, Matthew Garrett <mjg59@google.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jeremy Kerr <jk@ozlabs.org>, Andi Kleen <ak@linux.intel.com>, Tony Luck <tony.luck@intel.com>, Benjamin Drung <benjamin.drung@profitbricks.com>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

On 16 February 2018 at 10:55, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Feb 16, 2018 at 10:41:45AM +0000, Ard Biesheuvel wrote:
>> On 15 February 2018 at 18:22, Joe Konno <joe.konno@linux.intel.com> wrote:
>> > From: Joe Konno <joe.konno@intel.com>
>> >
>> > It was pointed out that normal, unprivileged users reading certain EFI
>> > variables (through efivarfs) can generate SMIs. Given these nodes are created
>> > with 0644 permissions, normal users could generate a lot of SMIs. By
>> > restricting permissions a bit (patch 1), we can make it harder for normal users
>> > to generate spurious SMIs.
>> >
>> > A normal user could generate lots of SMIs by reading the efivarfs in a trivial
>> > loop:
>> >
>> > ```
>> > while true; do
>> >     cat /sys/firmware/efi/evivars/* > /dev/null
>> > done
>> > ```
>> >
>> > Patch 1 in this series limits read and write permissions on efivarfs to the
>> > owner/superuser. Group and world cannot access.
>> >
>> > Patch 2 is for consistency and hygiene. If we restrict permissions for either
>> > efivarfs or efi/vars, the other interface should get the same treatment.
>> >
>>
>> I am inclined to apply this as a fix, but I will give the x86 guys a
>> chance to respond as well.
>
> That stinking pile EFI never ceases to amaze me...
>
> Just one question: by narrowing permissions this way, aren't you
> breaking some userspace which reads those?
>
> And if you do, then that's a no-no.
>
> Which then would mean that you'd have to come up with some caching
> scheme to protect the firmware from itself.
>
> Or we could simply admit that EFI is a piece of crap, kill it and
> start anew, this time much more conservatively and not add a whole OS
> underneath the actual OS.
>

By your own reasoning above, that's a no-no as well.

But thanks for your input. Anyone else got something constructive to contribute?
