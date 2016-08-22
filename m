From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 0/6] Apple device properties
Date: Mon, 22 Aug 2016 11:58:50 +0200
Message-ID: <20160822095850.GA22131@wunner.de>
References: <cover.1469616641.git.lukas@wunner.de>
 <20160804145710.GL3636@codeblueprint.co.uk>
 <20160809133816.GA6571@wunner.de>
 <20160815115414.GE30909@codeblueprint.co.uk>
 <20160815161358.GA9603@wunner.de>
 <20160818203433.GP30909@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160818203433.GP30909-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Aug 18, 2016 at 09:34:33PM +0100, Matt Fleming wrote:
> On Mon, 15 Aug, at 06:13:58PM, Lukas Wunner wrote:
> > But I would like to understand the "cannot jump through pointers at
> > runtime" argument because the binary code looks to me like it should
> > work on 32 bit. I guess I must be missing something obvious?
> 
> Ah no, I forgot that efi_boot_services_{32,64}_t doesn't contain
> pointers - it contains u32/u64 objects. So yeah, your patch looks
> fine.
> 
> It does trigger the following warnings when building for i386 though,
> 
> In file included from /dev/shm/mfleming/git/efi/drivers/firmware/efi/libstub/efi-stub-helper.c:14:0:
> /dev/shm/mfleming/git/efi/drivers/firmware/efi/libstub/efi-stub-helper.c: In function ???efi_get_memory_map???:
> /dev/shm/mfleming/git/efi/arch/x86/include/asm/efi.h:205:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>   ((efi_boot_services_64_t *)__efi_early()->boot_services)->f : \
>    ^

Right, sorry, I didn't compile-test that version on x86_32.

I'm sending out a new version now which compiles cleanly in all three
cases (x86_32, x86_64 with and without mixed-mode), works fine on my
64-bit EFI and the 32-bit code at least *looks* okay when disassembled.

By the way, arch/x86/Kconfig says that "it is not possible to boot a
mixed-mode enabled kernel via the EFI boot stub - a bootloader that
supports the EFI handover protocol must be used".

Is this still correct? With all the mixed-mode support in head_64.S
and eboot.c, I'm wondering what's missing?

Thanks,

Lukas
