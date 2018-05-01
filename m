From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2] efi: Ignore unrealistically large option roms
Date: Tue, 1 May 2018 15:57:54 +0200
Message-ID: <CAKv+Gu9KNEWCY7eXJ1edpKdve5Em831f_rW2z1CSCaE5kWNCMw@mail.gmail.com>
References: <20180427213509.20385-1-hdegoede@redhat.com> <CAKv+Gu9xxSy2XXN446etRC5xaXdeOBBBYBxZZy=0bZbdZA_K8Q@mail.gmail.com>
 <96034903ca984624a5972f7bb5aea975@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <96034903ca984624a5972f7bb5aea975@AcuMS.aculab.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Laight <David.Laight@aculab.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 1 May 2018 at 15:52, David Laight <David.Laight@aculab.com> wrote:
> From: Ard Biesheuvel
>> Sent: 28 April 2018 07:41
>> On 27 April 2018 at 23:35, Hans de Goede <hdegoede@redhat.com> wrote:
>> > setup_efi_pci() tries to save a copy of each PCI option ROM as this may
>> > be necessary for the device driver for the PCI device to have access too.
>> >
>> > On some systems the efi_pci_io_protocol_64's romimage and romsize fields
>> > contain invalid data, which looks a bit like pointers pointing back into
>> > other EFI code or data. Interpreting these pointers as romsize leads to
>> > a very large value and if we then try to alloc this amount of memory to
>> > save a copy the alloc call fails.
>> >
>> > This leads to a "Failed to alloc mem for rom" error being printed on the
>> > EFI console for each PCI device.
>> >
>> > This commit avoids the printing of these errors, by checking romsize
>> > before doing the alloc and if it is larger then 256M silently ignore the
>> > ROM fields instead of trying to alloc mem and fail.
>> >
>>
>> The UEFI spec limits the size of option ROMs to 16 MiB, so I'd prefer
>> we use that as the upper bound instead.
>
> Copying even 16MB of rom data into physical memory on the 'off chance' that
> the kernel might need it seems a waste of memory.
>

16 MB is the smallest number we can use that still guarantees that we
will not misidentify a valid option ROM as bogus. But in reality,
option ROMs are rarely that large.

> I can't help feeling that some kind of caching would be more appropriate.
>

Could you elaborate?
