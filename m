From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH] x86/efi: Don't unmap EFI boot services code/data
 regions for EFI_OLD_MEMMAP and EFI_MIXED_MODE
Date: Sat, 22 Dec 2018 19:05:39 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F48607FBC@ORSMSX114.amr.corp.intel.com>
References: <20181222022234.7573-1-sai.praneeth.prakhya@intel.com>
 <20181222105410.GA130780@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181222105410.GA130780@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

> 
> * Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com> wrote:
> 
> > Commit d5052a7130a6 ("x86/efi: Unmap EFI boot services code/data
> > regions from efi_pgd") forgets to take two EFI modes into
> > consideration namely EFI_OLD_MEMMAP and EFI_MIXED_MODE.
> 
> So the commit sha1 ended up being this one in tip:efi/core:
> 
>   08cfb38f3ef4: x86/efi: Unmap EFI boot services code/data regions from
> efi_pgd

Ya.. sorry! I took the sha1 from efi tree.

> 
> > EFI_OLD_MEMMAP is a legacy way of mapping EFI regions into
> > swapper_pg_dir using ioremap() and init_memory_mapping(). This feature
> > can be enabled by passing "efi=old_map" as kernel command line
> > argument. But,
> > efi_unmap_pages() unmaps EFI boot services code/data regions *only*
> > from efi_pgd and hence cannot be used for unmapping EFI boot services
> > code/data regions from swapper_pg_dir.


[.........]


> > +	/*
> > +	 * EFI mixed mode has all RAM mapped to access arguments while
> making
> > +	 * EFI runtime calls, hence don't unmap EFI boot services code/data
> > +	 * regions.
> > +	 */
> > +	if (!efi_is_native() && IS_ENABLED(CONFIG_EFI_MIXED))
> > +		return;
> 
> I suppose old_mmap and mixed mode stopped working altogether after the
> unmapping changes?

Yes.. that's true.

> What are the symptoms, instant reboots, crasher, or some
> more benign behavior like non-working runtime EFI functionality?

I noticed a kernel panic due to page fault.

AFAIK, it happens because efi_pgd is not defined for old_map and mixed mode.
Hence efi_unmap_pages() which calls __change_page_attr() unmaps mappings 
from swapper_pg_dir (please note that this my theory but I haven't checked if
this is really true).

> 
> If Ard acks this I'll apply it immediately, as these bugs look like show-stoppers for
> merging the EFI tree into v4.21.
> 
> Thanks,
> 
> 	Ingo
