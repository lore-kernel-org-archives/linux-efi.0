From: Ye Xiaolong <xiaolong.ye@intel.com>
Subject: Re: [kbuild-all] [PATCH] efi: Free existing memory map before
 installing new memory map
Date: Wed, 27 Jun 2018 14:02:57 +0800
Message-ID: <20180627060257.GD18756@yexl-desktop>
References: <1529980892-11833-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <201806261053.B3CmI5Dm%fengguang.wu@intel.com>
 <FFF73D592F13FD46B8700F0A279B802F45FD1614@ORSMSX111.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <FFF73D592F13FD46B8700F0A279B802F45FD1614@ORSMSX111.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Cc: lkp <lkp@intel.com>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, Laszlo Ersek <lersek@redhat.com>, Bhupesh Sharma <bhsharma@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, "kbuild-all@01.org" <kbuild-all@01.org>, Dave Young <dyoung@redhat.com>
List-Id: linux-efi@vger.kernel.org

Hi,

On 06/26, Prakhya, Sai Praneeth wrote:
>> 
>> Hi Sai,
>> 
>> Thank you for the patch! Yet something to improve:
>> 
>> [auto build test ERROR on linus/master]
>> [also build test ERROR on v4.18-rc2 next-20180625] [if your patch is applied to
>> the wrong git tree, please drop us a note to help improve the system]
>
>Since efi_memmap_free() is a recently introduced API [1], please note that the patch 
>is based on efi tree @https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git

I noticed the official efi tree recored in MAINTAINERS is git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git,
are they identical?

EXTENSIBLE FIRMWARE INTERFACE (EFI)
M:      Matt Fleming <matt@codeblueprint.co.uk>
L:      linux-efi@vger.kernel.org
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
S:      Maintained
F:      Documentation/efi-stub.txt
F:      arch/ia64/kernel/efi.c
F:      arch/x86/boot/compressed/eboot.[ch]
F:      arch/x86/include/asm/efi.h
F:      arch/x86/platform/efi/*
F:      drivers/firmware/efi/*
F:      include/linux/efi*.h


Thanks,
Xiaolong

>
>[1] https://lkml.org/lkml/2018/6/22/39
>
>Regards,
>Sai
>_______________________________________________
>kbuild-all mailing list
>kbuild-all@lists.01.org
>https://lists.01.org/mailman/listinfo/kbuild-all
