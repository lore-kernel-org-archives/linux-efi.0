From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 08/11] firmware: efi: add NULL pointer checks in efivars
 api functions
Date: Fri, 30 Nov 2018 09:11:59 +0100
Message-ID: <20181130081159.GD16084@gmail.com>
References: <20181129171230.18699-1-ard.biesheuvel@linaro.org>
 <20181129171230.18699-9-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181129171230.18699-9-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Arend van Spriel <arend.vanspriel@broadcom.com>, Bhupesh Sharma <bhsharma@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>, Eric Snowberg <eric.snowberg@oracle.com>, Hans de Goede <hdegoede@redhat.com>, Joe Perches <joe@perches.com>, Jon Hunter <jonathanh@nvidia.com>, Julien Thierry <julien.thierry@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Nathan Chancellor <natechancellor@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Sedat Dilek <sedat.dilek@gmail.com>, YiFei Zhu <zhuyifei1999@gmail.com>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> From: Arend van Spriel <arend.vanspriel@broadcom.com>
> 
> Since commit:
> 
>    ce2e6db554fa ("brcmfmac: Add support for getting nvram contents from
>                  EFI variables")

This commit ID is not upstream AFAICS. Which tree is it from? Mentioning 
non-upstream sha1's is discouraged in changelogs, as there's no guarantee 
that the sha1 will make it upstream.

> we have a device driver accessing the efivars API. Several functions in
> the efivars API assume __efivars is set, i.e., that they will be accessed
> only after efivars_register() has been called. However, the following NULL
> pointer access was reported calling efivar_entry_size() from the brcmfmac
> device driver.
> 
>   Unable to handle kernel NULL pointer dereference at virtual address 00000008
>   pgd = 60bfa5f1
>   [00000008] *pgd=00000000
>   Internal error: Oops: 5 [#1] SMP ARM
>   ...
>   Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
>   Workqueue: events request_firmware_work_func
>   PC is at efivar_entry_size+0x28/0x90
>   LR is at brcmf_fw_complete_request+0x3f8/0x8d4 [brcmfmac]
>   pc : [<c0c40718>]    lr : [<bf2a3ef4>]    psr: a00d0113
>   sp : ede7fe28  ip : ee983410  fp : c1787f30
>   r10: 00000000  r9 : 00000000  r8 : bf2b2258
>   r7 : ee983000  r6 : c1604c48  r5 : ede7fe88  r4 : edf337c0
>   r3 : 00000000  r2 : 00000000  r1 : ede7fe88  r0 : c17712c8
>   Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
>   Control: 10c5387d  Table: ad16804a  DAC: 00000051
> 
> Disassembly showed that the local static variable __efivars is NULL,
> which is not entirely unexpected given that it is a non-EFI platform.
> So add a NULL pointer check to efivar_entry_size(), and to related
> functions while at it. In efivars_register() a couple of sanity checks
> are added as well.
> 
> Cc: Hans de Goede <hdegoede@redhat.com>
> Reported-by: Jon Hunter <jonathanh@nvidia.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Will that new commit be backported? If yes I suppose we could mark this 
fix -stable too? If not then it's fine for a v4.21 merge.

Thanks,

	Ingo
