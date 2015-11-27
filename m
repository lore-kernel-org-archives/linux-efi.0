From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 13/13] ARM: add UEFI stub support
Date: Fri, 27 Nov 2015 10:38:05 +0100
Message-ID: <CAKv+Gu_RC5qG=BGPSEf=j7AV4SbjXELjBxmcboj1oVs-Dn87qw@mail.gmail.com>
References: <1448269593-20758-1-git-send-email-ard.biesheuvel@linaro.org>
	<1448269593-20758-14-git-send-email-ard.biesheuvel@linaro.org>
	<20151126104711.GH2765@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151126104711.GH2765-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alexander Kuleshov <kuleshovmail-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Ryan Harkin <ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 26 November 2015 at 11:47, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Mon, 23 Nov, at 10:06:33AM, Ard Biesheuvel wrote:
>> From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>
>> This patch adds EFI stub support for the ARM Linux kernel.
>>
>> The EFI stub operates similarly to the x86 and arm64 stubs: it is a
>> shim between the EFI firmware and the normal zImage entry point, and
>> sets up the environment that the zImage is expecting. This includes
>> optionally loading the initrd and device tree from the system partition
>> based on the kernel command line.
>>
>> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  arch/arm/Kconfig                          |  19 +++
>>  arch/arm/boot/compressed/Makefile         |   4 +-
>>  arch/arm/boot/compressed/efi-header.S     | 130 ++++++++++++++++++++
>>  arch/arm/boot/compressed/head.S           |  54 +++++++-
>>  arch/arm/boot/compressed/vmlinux.lds.S    |   7 ++
>>  arch/arm/include/asm/efi.h                |  23 ++++
>>  drivers/firmware/efi/libstub/Makefile     |   9 ++
>>  drivers/firmware/efi/libstub/arm-stub.c   |   4 +-
>>  drivers/firmware/efi/libstub/arm32-stub.c |  85 +++++++++++++
>>  9 files changed, 331 insertions(+), 4 deletions(-)
>
> [...]
>
>> +
>> +     /*
>> +      * Relocate the zImage, if required. ARM doesn't have a
>> +      * preferred address, so we set it to 0, as we want to allocate
>> +      * as low in memory as possible.
>> +      */
>> +     *image_size = image->image_size;
>> +     status = efi_relocate_kernel(sys_table, image_addr, *image_size,
>> +                                  *image_size, 0, 0);
>> +     if (status != EFI_SUCCESS) {
>> +             pr_efi_err(sys_table, "Failed to relocate kernel.\n");
>> +             efi_free(sys_table, *reserve_size, *reserve_addr);
>> +             *reserve_size = 0;
>> +             return status;
>> +     }
>
> If efi_relocate_kernel() successfully allocates memory at address 0x0,
> is that going to cause issues with NULL pointer checking?

Actually, it is the reservation done a bit earlier that could
potentially end up at 0x0, and the [compressed] kernel is always at
least 32 MB up in memory, so that it can be decompressed as close to
the base of DRAM as possible.

As far as I can tell, efi_free() deals correctly with allocations at
address 0x0, and that is the only dealing we have with the
reservation. So I don't think there is an issue here.

-- 
Ard.
