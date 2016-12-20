From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [efi:urgent 1/1] drivers/firmware/efi/libstub/fdt.c:303:9:
 warning: cast from pointer to integer of different size
Date: Tue, 20 Dec 2016 11:39:56 +0000
Message-ID: <20161220113956.GB2225@codeblueprint.co.uk>
References: <201612200741.F41hYqms%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201612200741.F41hYqms%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 20 Dec, at 07:04:42AM, Fengguang Wu wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git urgent
> head:   5615742edc64c99bbdec5e98bf9d9d872756d99c
> commit: 5615742edc64c99bbdec5e98bf9d9d872756d99c [1/1] efi/libstub: arm*: Pass latest memory map to the kernel
> config: arm-multi_v7_defconfig (attached as .config)
> compiler: arm-linux-gnueabi-gcc (Debian 6.1.1-9) 6.1.1 20160705
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 5615742edc64c99bbdec5e98bf9d9d872756d99c
>         # save the attached .config to linux build tree
>         make.cross ARCH=arm 
> 
> All warnings (new ones prefixed by >>):
> 
>    drivers/firmware/efi/libstub/fdt.c: In function 'allocate_new_fdt_and_exit_boot':
> >> drivers/firmware/efi/libstub/fdt.c:303:9: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>             (u64)memory_map, (u32)map_size);
>             ^
> 
> vim +303 drivers/firmware/efi/libstub/fdt.c
> 
>    287				new_fdt_size += EFI_PAGE_SIZE;
>    288			} else {
>    289				pr_efi_err(sys_table, "Unable to construct new device tree.\n");
>    290				goto fail_free_new_fdt;
>    291			}
>    292		}
>    293	
>    294		priv.runtime_map = runtime_map;
>    295		priv.runtime_entry_count = &runtime_entry_count;
>    296		status = efi_exit_boot_services(sys_table, handle, &map, &priv,
>    297						exit_boot_func);
>    298	
>    299		if (status == EFI_SUCCESS) {
>    300			efi_set_virtual_address_map_t *svam;
>    301	
>    302			status = update_fdt_memmap((void *)*new_fdt_addr,
>  > 303						   (u64)memory_map, (u32)map_size);
>    304			if (status != EFI_SUCCESS) {
>    305				/*
>    306				 * The kernel won't get far without the memory map, but
>    307				 * may still be able to print something meaningful so
>    308				 * return success here.
>    309				 */
>    310				return EFI_SUCCESS;
>    311			}
> 

James, could you take care of fixing this up? You need to cast
memory_map to unsigned long before u64 on ARM.
