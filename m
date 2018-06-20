From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: Re: [PATCH V2] x86/efi: Free allocated memory if remap fails
Date: Tue, 19 Jun 2018 19:36:45 -0700
Message-ID: <1529462205.2333.83.camel@intel.com>
References: <1529350614-15555-1-git-send-email-sai.praneeth.prakhya@intel.com>
         <CAKv+Gu-yeXwLjd1Sp0jc41-9zVFOuxSBqMiHkivTLmT-u3Upjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-yeXwLjd1Sp0jc41-9zVFOuxSBqMiHkivTLmT-u3Upjg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Dave Hansen <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Ricardo Neri <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org


> > 
> Thank you Sai.
> 
> But this is not really what I meant.
> 

Ya.. sorry! about that. I had a hunch that you might be suggesting something
like below but I went ahead with this implementation as it looked very simple
(just 3 insertions and no deletions)

> How about we modify efi_memmap_alloc() like this
> 

It sounds like a good idea to me. Leaving aside the pros (which are obvious),
the only con I could see is few extra checks and some code but I don't think
it's an issue at all because this code is not in fast path and it dosen't
impact performance. So, I will post a V3 with suggested changes.

> @@ -39,10 +39,12 @@ static phys_addr_t __init
> __efi_memmap_alloc_late(unsigned long size)
>   * Returns the physical address of the allocated memory map on
>   * success, zero on failure.
>   */
> -phys_addr_t __init efi_memmap_alloc(unsigned int num_entries)
> +phys_addr_t __init efi_memmap_alloc(unsigned int num_entries, bool *late)
>  {
>         unsigned long size = num_entries * efi.memmap.desc_size;
> 
> +       if (late)
> +               *late = slab_is_available();
>         if (slab_is_available())
>                 return __efi_memmap_alloc_late(size);
> 
> and introduce efi_memmap_free() as before, but pass it the 'late'
> parameter you received from efi_memmap_alloc(). That way, it is the
> caller's job to take care of this.
> 

Sure! makes sense.

> Also, it seems to me that efi_arch_mem_reserve() leaks the old memory
> map every time you create a new one, no?

I think you are right. The issue I see is (please let me know if you think
otherwise):
1. efi_arch_mem_reserve() comes up with a new memory map and then tries to
install it via efi_memmap_install().
2. efi_memmap_install(), unmaps the existing memory map and installs the new
memory map but doesn't free the memory used by the existing memory map.
Hence, as you said, leaks the old memory map.

If this you what you meant, I think, the issue is not just limited to
efi_arch_mem_reserve() but to all the places that call efi_memmap_install().
I think, we could solve it as below

diff --git a/drivers/firmware/efi/memmap.c b/drivers/firmware/efi/memmap.c
index 678e85704054..50ae4ffbf058 100644
--- a/drivers/firmware/efi/memmap.c
+++ b/drivers/firmware/efi/memmap.c
@@ -228,6 +228,7 @@ int __init efi_memmap_install(phys_addr_t addr, unsigned
int nr_map)
        struct efi_memory_map_data data;
 
        efi_memmap_unmap();
+       efi_memmap_free(efi.memmap.phys_map, efi.memmap.nr_map,
efi.memmap.late);
 
        data.phys_map = addr;
        data.size = efi.memmap.desc_size * nr_map;

Please let me know your thoughts on it.

> That is a separate issue that
> you may want to look into, but it affects the design of this API as
> well.

Probably, I could have misunderstood you here.. but I think the
efi_memmap_free() API in V3 should work (without changes). Don't you think so?

Regards,
Sai
