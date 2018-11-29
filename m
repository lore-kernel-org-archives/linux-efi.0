From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [GIT PULL 00/11] EFI updates
Date: Thu, 29 Nov 2018 18:27:43 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F485F14B8@ORSMSX114.amr.corp.intel.com>
References: <20181129171230.18699-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181129171230.18699-1-ard.biesheuvel@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Arend van Spriel <arend.vanspriel@broadcom.com>, Bhupesh Sharma <bhsharma@redhat.com>, Borislav Petkov <bp@alien8.de>, "Hansen, Dave" <dave.hansen@intel.com>, Eric Snowberg <eric.snowberg@oracle.com>, Hans de Goede <hdegoede@redhat.com>, Joe Perches <joe@perches.com>, Jon Hunter <jonathanh@nvidia.com>, Julien Thierry <julien.thierry@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Nathan Chancellor <natechancellor@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Sedat Dilek <sedat.dilek@gmail.com>, YiFei Zhu <zhuyifei1999@gmail.com>
List-Id: linux-efi@vger.kernel.org

Hi Ard,

While building from next branch of efi tree, I noticed the below warning. Could you please check the same on your side?

  CC      lib/list_debug.o
drivers/firmware/efi/efi.c: In function 'efi_mem_reserve_persistent':
drivers/firmware/efi/efi.c:1000:6: warning: unused variable 'rsvsize' [-Wunused-variable]
  int rsvsize = EFI_MEMRESERVE_SIZE(1);
      ^~~~~~~
  CC      lib/bitrev.o
  CC      net/core/sock_reuseport.o

> -----Original Message-----
> From: Ard Biesheuvel [mailto:ard.biesheuvel@linaro.org]
> Sent: Thursday, November 29, 2018 9:12 AM
> To: linux-efi@vger.kernel.org; Ingo Molnar <mingo@kernel.org>; Thomas
> Gleixner <tglx@linutronix.de>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>; linux-kernel@vger.kernel.org;
> Andy Lutomirski <luto@kernel.org>; Arend van Spriel
> <arend.vanspriel@broadcom.com>; Bhupesh Sharma <bhsharma@redhat.com>;
> Borislav Petkov <bp@alien8.de>; Hansen, Dave <dave.hansen@intel.com>; Eric
> Snowberg <eric.snowberg@oracle.com>; Hans de Goede
> <hdegoede@redhat.com>; Joe Perches <joe@perches.com>; Jon Hunter
> <jonathanh@nvidia.com>; Julien Thierry <julien.thierry@arm.com>; Marc
> Zyngier <marc.zyngier@arm.com>; Nathan Chancellor
> <natechancellor@gmail.com>; Peter Zijlstra <peterz@infradead.org>; Prakhya,
> Sai Praneeth <sai.praneeth.prakhya@intel.com>; Sedat Dilek
> <sedat.dilek@gmail.com>; YiFei Zhu <zhuyifei1999@gmail.com>
> Subject: [GIT PULL 00/11] EFI updates
> 
> The following changes since commit
> 976b489120cdab2b1b3a41ffa14661db43d58190:
> 
>   efi: Prevent GICv3 WARN() by mapping the memreserve table before first use
> (2018-11-27 13:50:20 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next
> 
> for you to fetch changes up to 1d29afdbf7ae878a23627ebee81efcd213f11749:
> 
>   efi/x86: earlyprintk - Fix infinite loop on some screen widths (2018-11-28
> 17:58:42 +0100)
>

Regards,
Sai
