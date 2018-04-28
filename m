From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v2] efi: Ignore unrealistically large option roms
Date: Sat, 28 Apr 2018 22:11:47 +0200
Message-ID: <253539f8-a24b-72f0-ef6e-27fb3eac2408@redhat.com>
References: <20180427213509.20385-1-hdegoede@redhat.com>
 <CAKv+Gu9xxSy2XXN446etRC5xaXdeOBBBYBxZZy=0bZbdZA_K8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9xxSy2XXN446etRC5xaXdeOBBBYBxZZy=0bZbdZA_K8Q@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

Hi,

On 28-04-18 08:40, Ard Biesheuvel wrote:
> Hi Hans,
> 
> On 27 April 2018 at 23:35, Hans de Goede <hdegoede@redhat.com> wrote:
>> setup_efi_pci() tries to save a copy of each PCI option ROM as this may
>> be necessary for the device driver for the PCI device to have access too.
>>
>> On some systems the efi_pci_io_protocol_64's romimage and romsize fields
>> contain invalid data, which looks a bit like pointers pointing back into
>> other EFI code or data. Interpreting these pointers as romsize leads to
>> a very large value and if we then try to alloc this amount of memory to
>> save a copy the alloc call fails.
>>
>> This leads to a "Failed to alloc mem for rom" error being printed on the
>> EFI console for each PCI device.
>>
>> This commit avoids the printing of these errors, by checking romsize
>> before doing the alloc and if it is larger then 256M silently ignore the
>> ROM fields instead of trying to alloc mem and fail.
>>
> 
> The UEFI spec limits the size of option ROMs to 16 MiB, so I'd prefer
> we use that as the upper bound instead.
> 
> With that changed,
> 
> Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Thanks for the review, fixed for v3 which I'm about to send.

> or I can take it via the EFI tree if desired.

I've no preference for how this goes upstream. x86 folks, please let
us know if you will take this, or if you would prefer for this to
go upstream through the EFI tree.

Regards,

Hans
