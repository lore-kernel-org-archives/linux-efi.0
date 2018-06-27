From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [kbuild-all] [PATCH] efi: Free existing memory map before
 installing new memory map
Date: Wed, 27 Jun 2018 06:32:46 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F4605BA4E@ORSMSX111.amr.corp.intel.com>
References: <1529980892-11833-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <201806261053.B3CmI5Dm%fengguang.wu@intel.com>
 <FFF73D592F13FD46B8700F0A279B802F45FD1614@ORSMSX111.amr.corp.intel.com>
 <20180627060257.GD18756@yexl-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180627060257.GD18756@yexl-desktop>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Ye, Xiaolong" <xiaolong.ye@intel.com>
Cc: lkp <lkp@intel.com>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, Laszlo Ersek <lersek@redhat.com>, Bhupesh Sharma <bhsharma@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, "kbuild-all@01.org" <kbuild-all@01.org>, Dave Young <dyoung@redhat.com>
List-Id: linux-efi@vger.kernel.org

> >Since efi_memmap_free() is a recently introduced API [1], please note
> >that the patch is based on efi tree
> >@https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git
> 
> I noticed the official efi tree recored in MAINTAINERS is
> git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git,
> are they identical?
> 
> EXTENSIBLE FIRMWARE INTERFACE (EFI)
> M:      Matt Fleming <matt@codeblueprint.co.uk>
> L:      linux-efi@vger.kernel.org
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
> S:      Maintained
> F:      Documentation/efi-stub.txt
> F:      arch/ia64/kernel/efi.c
> F:      arch/x86/boot/compressed/eboot.[ch]
> F:      arch/x86/include/asm/efi.h
> F:      arch/x86/platform/efi/*
> F:      drivers/firmware/efi/*
> F:      include/linux/efi*.h

Hi Xiaolong,

Ard replaced Matt as EFI maintainer. Please see updated MAINTAINERS file for more details.
https://elixir.bootlin.com/linux/v4.18-rc2/source/MAINTAINERS

EXTENSIBLE FIRMWARE INTERFACE (EFI)
M:	Ard Biesheuvel <ard.biesheuvel@linaro.org>
L:	linux-efi@vger.kernel.org
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git
S:	Maintained
F:	Documentation/efi-stub.txt
F:	arch/*/kernel/efi.c
F:	arch/x86/boot/compressed/eboot.[ch]
F:	arch/*/include/asm/efi.h
F:	arch/x86/platform/efi/
F:	drivers/firmware/efi/
F:	include/linux/efi*.h
F:	arch/arm/boot/compressed/efi-header.S
F:	arch/arm64/kernel/efi-entry.S

Regards,
Sai
