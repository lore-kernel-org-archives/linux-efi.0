From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi: Free existing memory map before installing new
 memory map
Date: Wed, 27 Jun 2018 09:01:51 +0200
Message-ID: <CAKv+Gu982OPp73Tg5Rru3+1ymq6_P8XpFPROQPdZMSUDdwEOmw@mail.gmail.com>
References: <1529980892-11833-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <CAKv+Gu-_tQsYMUMp4NGrEkRrbFGJvE=vJVciaO6TEAC_u5bmfQ@mail.gmail.com> <FFF73D592F13FD46B8700F0A279B802F4605BA0F@ORSMSX111.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <FFF73D592F13FD46B8700F0A279B802F4605BA0F@ORSMSX111.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Cc: linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Dave Young <dyoung@redhat.com>, Laszlo Ersek <lersek@redhat.com>, Bhupesh Sharma <bhsharma@redhat.com>, "Neri, Ricardo" <ricardo.neri@intel.com>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

On 27 June 2018 at 06:51, Prakhya, Sai Praneeth
<sai.praneeth.prakhya@intel.com> wrote:
>> > +       /* Free the memory allocated to the existing memory map */
>> > +       efi_memmap_free(efi.memmap.phys_map, efi.memmap.nr_map,
>> > + efi.memmap.late);
>> > +
>> >         data.phys_map = addr;
>> >         data.size = efi.memmap.desc_size * nr_map;
>> >         data.desc_version = efi.memmap.desc_version;
>> > --
>> > 2.7.4
>> >
>>
>> If only it were so simple :-)
>>
>> At this point, efi.memmap.phys_map could point to memory that was allocated
>> early, allocated late or simply passed to the OS at boot time by the stub (in
>> which case it was memblock_reserve()d but not memblock_alloc()d, and it
>> should not be freed)
>>
>
> Yes, completely agree that there could be three types of allocations for memmap.
> I thought,
> efi_memmap_free(efi.memmap.phys_map, efi.memmap.nr_map, efi.memmap.late);
>
> should work because the previous type of allocation should have been recorded in efi.memmap.late.
> But, now I see this will fail for memblock_reserved() memory because it will be mistaken to
> memblock_alloced() (I assumed both are almost similar :().
>
>> So only allocations made with efi_memmap_alloc() should be freed here.
>
> Makes sense and I think that also means efi_memmap_free() should be called from function
> that called efi_memmap_alloc() and not efi_memmap_install().
>
>> I'm not sure /how/ we should keep track of that: perhaps it is simply a matter of
>> replacing the boolean 'late' with an enum that describes where the memory
>> came from that phys_map points to.
>
> I did try changing boolean late to enum and it seems to be working fine. I will do more
> testing/clean up and will submit a patch for review.
>
> Also, could you please clarify if there is any specific reason why memory allocated
> using memblock_reserve() shouldn't be freed. I mean, not with memblock_free() but I
> think we could make it _available_ using free_bootmem() (or something similar, please
> correct me if this is not the right API).

On arm64, the memory map is provided to the core kernel by the stub,
and after kexec, a pointer to the same memory map will be passed to
the next kernel. So the kernel does not 'own' that allocation, and it
should not free it or overwrite it.

> If we allocate and install a new memory map (as
> in case with efi_fake_memmap()), I think we should free the memory used by memory map
> originally passed by EFI stub, because, at any point of time there should only be one active
> memory map. If we don't free the original memory map passed by EFI stub, we will be having
> two and hence will be leaking memory.
>
> Regards,
> Sai
