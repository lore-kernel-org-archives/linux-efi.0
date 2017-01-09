From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH v3 2/2] efi: efi_mem_reserve(): don't reserve through
 memblock after mm_init()
Date: Mon, 9 Jan 2017 13:07:02 +0000
Message-ID: <20170109130702.GI16838@codeblueprint.co.uk>
References: <20170105125130.2815-1-nicstange@gmail.com>
 <20170105125130.2815-2-nicstange@gmail.com>
 <CAKv+Gu8RHsMKmEHBqNv=q4SB-spCtuydbCshs2ut1+Kk8vraOQ@mail.gmail.com>
 <87wpe8mjdk.fsf@gmail.com>
 <CAKv+Gu_BnSf_LMsWHTeFaTak8iV1Cwex7WBEsufwYRrBzY8KzQ@mail.gmail.com>
 <87showm682.fsf@gmail.com>
 <CAKv+Gu9B_amUwKuQCfMj6d96EpcLdeBDm732E0iqKSkRp11Z4w@mail.gmail.com>
 <8760lqiejy.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8760lqiejy.fsf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicolai Stange <nicstange@gmail.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@nextfour.com>, Dan Williams <dan.j.williams@intel.com>, Dave Young <dyoung@redhat.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 08 Jan, at 01:24:49AM, Nicolai Stange wrote:
> 
> Out of curiosity, I had a deeper look at the BootServices*-md
> requirement though:
> 
> > Another problem is that we never check that the reservation is covered
> > by a BootServicesData region, which are the only ones that are
> > guaranteed to be retained up to this point.
> 
> I think the "only ones that are guaranteed to be retained" part might
> not be completely correct: at least my firmware seems to report only the
> EFI_CONVENTIONAL_MEMORY, EFI_LOADER_DATA, EFI_LOADER_CODE,
> EFI_BOOT_SERVICES_CODE and EFI_BOOT_SERVICES_DATA as E820_RAM
> (I think that these mappings are dictated by table 15-330 of ACPI 6.1:
> "UEFI Memory Types and mapping to ACPI address range types").
> 
> This would mean, that memblock_x86_fill() adds only these regions to
> memblock.memory.
 
Data required at runtime should only be in EFI_LOADER* regions if it's
part of some setup_data object (see things like SETUP_EFI), and
subsequently has been memblock_reserve()'d at some point.

Nothing valuable should be in EFI_CONVENTIONAL_MEMORY because, by
definition, it's free memory. 

> free_all_bootmem() only operates on the (non-highmem) regions given by
> memblock.memory and thus, any region of a type different from the ones
> listed above would never get freed to the buddy allocator anyway, AFAICS.
 
This is true.

> Thus, the only md type where ranges efi_mem_reserve()'d therein aren't
> retained are EFI_CONVENTIONAL_MEMORY, EFI_LOADER_DATA and
> EFI_LOADER_CODE (and possibly highmem). Hopefully, nobody would ever
> call efi_mem_reserve() on such a range but that assumption might be
> wrong.

I would happily welcome some diagnostic checks to ensure we never get
silently stung by this.
