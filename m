From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH V9 2/5] x86: acpi: implement
 arch_apei_get_mem_attributes()
Date: Mon, 3 Aug 2015 17:22:23 +0100
Message-ID: <20150803162223.GP2725@codeblueprint.co.uk>
References: <1438292109-4170-1-git-send-email-zjzhang@codeaurora.org>
 <1438292109-4170-3-git-send-email-zjzhang@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438292109-4170-3-git-send-email-zjzhang@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
Cc: Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, ying.huang@intel.com, tony.luck@gmail.com, fu.wei@linaro.org, al.stone@linaro.org, bp@alien8.de, rjw@rjwysocki.net, catalin.marinas@arm.com, will.deacon@arm.com, hanjun.guo@linaro.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org, timur@codeaurora.org
List-Id: linux-efi@vger.kernel.org

On Thu, 30 Jul, at 02:35:06PM, Jonathan (Zhixiong) Zhang wrote:
> From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
>=20
> ... to allow arch specific implementation of getting page
> protection type associated with a physical address.
>=20
> On x86, we currently have no way to lookup the EFI memory map
> attributes for a region in a consistent way because the
> memmap is discarded after efi_free_boot_services(). So if
> you call efi_mem_attributes() during boot and at runtime,
> you could theoretically see different attributes.
>=20
> Since we are yet to see any x86 platforms that require
> anything other than PAGE_KERNEL (some arm64 platforms
> require the equivalent of PAGE_KERNEL_NOCACHE), return that
> until we know differently.
>=20
> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
> ---
>  arch/x86/kernel/acpi/apei.c | 19 +++++++++++++++++++
>  include/acpi/apei.h         |  1 +
>  2 files changed, 20 insertions(+)
>=20
> diff --git a/arch/x86/kernel/acpi/apei.c b/arch/x86/kernel/acpi/apei.=
c
> index c280df6b2aa2..675bd46c4e17 100644
> --- a/arch/x86/kernel/acpi/apei.c
> +++ b/arch/x86/kernel/acpi/apei.c
> @@ -60,3 +60,22 @@ void arch_apei_flush_tlb_one(unsigned long addr)
>  {
>  	__flush_tlb_one(addr);
>  }
> +
> +static inline pgprot_t arch_apei_get_mem_attribute(phys_addr_t addr)
> +{
> +
> +	/*
> +	 * We currently have no way to lookup the EFI memory map
> +	 * attributes for a region in a consistent way because the
> +	 * memmap is discarded after efi_free_boot_services(). So if
> +	 * you call efi_mem_attributes() during boot and at runtime,
> +	 * you could theoretically see different attributes.
> +	 *
> +	 * Since we are yet to see any x86 platforms that require
> +	 * anything other than PAGE_KERNEL (some arm64 platforms
> +	 * require the equivalent of PAGE_KERNEL_NOCACHE), return that
> +	 * until we know differently.
> +	 */
> +
> +	return __pgprot(PAGE_KERNEL);
> +}
> diff --git a/include/acpi/apei.h b/include/acpi/apei.h
> index 284801ac7042..64a12ce9880b 100644
> --- a/include/acpi/apei.h
> +++ b/include/acpi/apei.h
> @@ -46,6 +46,7 @@ int erst_clear(u64 record_id);
>  int arch_apei_enable_cmcff(struct acpi_hest_header *hest_hdr, void *=
data);
>  void arch_apei_report_mem_error(int sev, struct cper_sec_mem_err *me=
m_err);
>  void arch_apei_flush_tlb_one(unsigned long addr);
> +pgprot_t arch_apei_get_mem_attribute(phys_addr_t addr);
> =20
>  #endif
>  #endif

This doesn't compile :(

/home/matt/src/kernels/efi/arch/x86/kernel/acpi/apei.c:64:24: error: st=
atic declaration of =E2=80=98arch_apei_get_mem_attribute=E2=80=99 follo=
ws non-static declaration
 static inline pgprot_t arch_apei_get_mem_attribute(phys_addr_t addr)
                        ^
In file included from /home/matt/src/kernels/efi/arch/x86/kernel/acpi/a=
pei.c:15:0:
/home/matt/src/kernels/efi/include/acpi/apei.h:48:10: note: previous de=
claration of =E2=80=98arch_apei_get_mem_attribute=E2=80=99 was here
 pgprot_t arch_apei_get_mem_attribute(phys_addr_t addr);
          ^
/home/matt/src/kernels/efi/arch/x86/kernel/acpi/apei.c: In function =E2=
=80=98arch_apei_get_mem_attribute=E2=80=99:
/home/matt/src/kernels/efi/arch/x86/kernel/acpi/apei.c:80:2: error: inc=
ompatible types when initializing type =E2=80=98long unsigned int=E2=80=
=99 using type =E2=80=98pgprot_t=E2=80=99
  return __pgprot(PAGE_KERNEL);

--=20
Matt Fleming, Intel Open Source Technology Center
