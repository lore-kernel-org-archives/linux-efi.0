From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [efi:next 2/3] arch/x86/boot/compressed/eboot.c:26:16: sparse:
 incorrect type in return expression (different modifiers)
Date: Wed, 12 Nov 2014 11:31:58 +0100
Message-ID: <CAKv+Gu8Jk4z6Q+8ZstNrA5e0ictYnzq9XOeq8zbr8ADo5DyWow@mail.gmail.com>
References: <201411120724.PdeIjimc%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201411120724.PdeIjimc%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12 November 2014 00:48, kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git next
> head:   8266e31ed0fedb7ee16ebc86e80468f7cc1bbb4e
> commit: 243b6754cd17112bbf0724ed3c13446b48cf6a28 [2/3] efi/x86: Move x86 back to libstub
> reproduce:
>   # apt-get install sparse
>   git checkout 243b6754cd17112bbf0724ed3c13446b48cf6a28
>   make ARCH=x86_64 allmodconfig
>   make C=1 CF=-D__CHECK_ENDIAN__
>
>
> sparse warnings: (new ones prefixed by >>)
>
>>> arch/x86/boot/compressed/eboot.c:26:16: sparse: incorrect type in return expression (different modifiers)
>    arch/x86/boot/compressed/eboot.c:26:16:    expected struct efi_config const [pure] *
>    arch/x86/boot/compressed/eboot.c:26:16:    got struct efi_config *static [toplevel] efi_early
>

This smells like a sparse bug: __pure applies to functions only, so
there is no way we could ever return something with the __pure
modifier attached.

-- 
Ard.


> vim +26 arch/x86/boot/compressed/eboot.c
>
>     10  #include <linux/efi.h>
>     11  #include <linux/pci.h>
>     12  #include <asm/efi.h>
>     13  #include <asm/setup.h>
>     14  #include <asm/desc.h>
>     15
>     16  #undef memcpy                   /* Use memcpy from misc.c */
>     17
>     18  #include "eboot.h"
>     19
>     20  static efi_system_table_t *sys_table;
>     21
>     22  static struct efi_config *efi_early;
>     23
>     24  __pure const struct efi_config *__efi_early(void)
>     25  {
>   > 26          return efi_early;
>     27  }
>     28
>     29  #define BOOT_SERVICES(bits)                                             \
>     30  static void setup_boot_services##bits(struct efi_config *c)             \
>     31  {                                                                       \
>     32          efi_system_table_##bits##_t *table;                             \
>     33          efi_boot_services_##bits##_t *bt;                               \
>     34                                                                          \
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
