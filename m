From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 0/6] Apple device properties
Date: Thu, 18 Aug 2016 21:34:33 +0100
Message-ID: <20160818203433.GP30909@codeblueprint.co.uk>
References: <cover.1469616641.git.lukas@wunner.de>
 <20160804145710.GL3636@codeblueprint.co.uk>
 <20160809133816.GA6571@wunner.de>
 <20160815115414.GE30909@codeblueprint.co.uk>
 <20160815161358.GA9603@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160815161358.GA9603@wunner.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Andreas Noever <andreas.noever@gmail.com>, x86@kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Mon, 15 Aug, at 06:13:58PM, Lukas Wunner wrote:
> 
> But I would like to understand the "cannot jump through pointers at
> runtime" argument because the binary code looks to me like it should
> work on 32 bit. I guess I must be missing something obvious?

Ah no, I forgot that efi_boot_services_{32,64}_t doesn't contain
pointers - it contains u32/u64 objects. So yeah, your patch looks
fine.

It does trigger the following warnings when building for i386 though,

In file included from /dev/shm/mfleming/git/efi/drivers/firmware/efi/libstub/efi-stub-helper.c:14:0:
/dev/shm/mfleming/git/efi/drivers/firmware/efi/libstub/efi-stub-helper.c: In function ‘efi_get_memory_map’:
/dev/shm/mfleming/git/efi/arch/x86/include/asm/efi.h:205:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
  ((efi_boot_services_64_t *)__efi_early()->boot_services)->f : \
   ^
/dev/shm/mfleming/git/efi/drivers/firmware/efi/libstub/efi-stub-helper.c:85:11: note: in expansion of macro ‘efi_call_early’
  status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
           ^
/dev/shm/mfleming/git/efi/arch/x86/include/asm/efi.h:206:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
  ((efi_boot_services_32_t *)__efi_early()->boot_services)->f, \
   ^
/dev/shm/mfleming/git/efi/drivers/firmware/efi/libstub/efi-stub-helper.c:85:11: note: in expansion of macro ‘efi_call_early’
  status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
           ^
/dev/shm/mfleming/git/efi/arch/x86/include/asm/efi.h:205:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
  ((efi_boot_services_64_t *)__efi_early()->boot_services)->f : \
   ^
/dev/shm/mfleming/git/efi/drivers/firmware/efi/libstub/efi-stub-helper.c:92:11: note: in expansion of macro ‘efi_call_early’
  status = efi_call_early(get_memory_map, map_size, m,
           ^
etc.
