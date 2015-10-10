From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 2/2] x86, efi: Add "efi_fake_mem" boot option
Date: Sat, 10 Oct 2015 21:36:17 +0100
Message-ID: <20151010203617.GE2723@codeblueprint.co.uk>
References: <201509300948.PGoujrqX%fengguang.wu@intel.com>
 <1443621716-209818-1-git-send-email-izumi.taku@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443621716-209818-1-git-send-email-izumi.taku@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org, matt.fleming@intel.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, tony.luck@intel.com, qiuxishi@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, ard.biesheuvel@linaro.org
List-Id: linux-efi@vger.kernel.org

On Wed, 30 Sep, at 11:01:56PM, Taku Izumi wrote:
> This patch introduces new boot option named "efi_fake_mem".
> By specifying this parameter, you can add arbitrary attribute
> to specific memory range.
> This is useful for debugging of Address Range Mirroring feature.
> 
> For example, if "efi_fake_mem=2G@4G:0x10000,2G@0x10a0000000:0x10000"
> is specified, the original (firmware provided) EFI memmap will be
> updated so that the specified memory regions have
> EFI_MEMORY_MORE_RELIABLE attribute (0x10000):
> 
>  <original>
>    efi: mem36: [Conventional Memory|  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000100000000-0x00000020a0000000) (129536MB)
> 
>  <updated>
>    efi: mem36: [Conventional Memory|  |MR|  |  |  |   |WB|WT|WC|UC] range=[0x0000000100000000-0x0000000180000000) (2048MB)
>    efi: mem37: [Conventional Memory|  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000180000000-0x00000010a0000000) (61952MB)
>    efi: mem38: [Conventional Memory|  |MR|  |  |  |   |WB|WT|WC|UC] range=[0x00000010a0000000-0x0000001120000000) (2048MB)
>    efi: mem39: [Conventional Memory|  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000001120000000-0x00000020a0000000) (63488MB)
> 
> And you will find that the following message is output:
> 
>    efi: Memory: 4096M/131455M mirrored memory
> 
> Signed-off-by: Taku Izumi <izumi.taku@jp.fujitsu.com>
> ---
>  Documentation/kernel-parameters.txt |  15 +++
>  arch/x86/kernel/setup.c             |   4 +-
>  drivers/firmware/efi/Kconfig        |  22 ++++
>  drivers/firmware/efi/Makefile       |   1 +
>  drivers/firmware/efi/fake_mem.c     | 238 ++++++++++++++++++++++++++++++++++++
>  include/linux/efi.h                 |   6 +
>  6 files changed, 285 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/firmware/efi/fake_mem.c
 
Looks good to me! I've queued this up with one minor change...

> +config EFI_MAX_FAKE_MEM
> +	int "maximum allowable number of ranges in efi_fake_mem boot option"
> +	depends on EFI && X86 && EFI_FAKE_MEMMAP

We can simplify this depends line since EFI_FAKE_MEMMAP itself is
dependent on EFI and X86, and we should use that level of indirection
to our advantage to save updating this line if/when arm64 support is
added.

-- 
Matt Fleming, Intel Open Source Technology Center
