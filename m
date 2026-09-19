Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9003368B0
	for <linux-efi@vger.kernel.org>; Sat, 19 Sep 2026 14:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789827340; cv=none; b=tqmkjnTr68GPMpOBtN4cRwbHH/j7j5sXmhQ8GXubVsUL6p6zLvTp8aKFK6NR8YlcsSEKkQ2ufK+fY+zfeLSetXwE0iexZIhkcHFXL3xsAPWcjLYXy/uwPhl3aAZCQWJ6m1/ffkLv+lQG2D7ppnKZ+xEq+U/9V7xo+54/v3djUQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789827340; c=relaxed/simple;
	bh=5/JbgOtWtvivQO4EjtYI9odqCeO4xYIysG5n+LHmkj0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lX210A3QoXhh1HbpbvHj0H1eyYF3lWvxMd9hQ6W3J1ENk1c4LslqsEgMne6zu5X0nBs+lC4NDxK1kTFdrZKZyfnZAkmrgpDKw82l/2CP0jnbrkJgBZr3oc7oyUICrDWJ3fHzQK9I3k33ZYwGjqFw8wu7VpzcYC+568AngTGBr4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IBPv+D/4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IBPv+D/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05151F00899
	for <linux-efi@vger.kernel.org>; Sat, 19 Sep 2026 14:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789827338;
	bh=oJ/TNEaABlE8fSBuYZubv6hF281KP4m/bl7sa4jtdbY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IBPv+D/4BTtk3dPwt4wmVFDpt0Pz+YAmdKOF4GtjtQz8o2k+4Sb25nmAT4LNxNp37
	 N1WVrz+/1TBWSYizOebLdtvEtkosdxqF2MGiINme2ogpbrhfK9uWGfi5d2jF+GLf6I
	 tTXjDCkftsN1UjlXtuqrzg/rgFNrw4sGFNJXY6YIz4dwudMR18mEq4/tlG22znghAK
	 x51hhMaAkt+rR67/9y5mpZGce/vFl5J0LSmOhgAUa0xf6cVLdt1MLxNLq6KJe+mmqq
	 h4pPx2htqIStUyNgR85VLBBzP18/UvCBWAGcdlecO63G0bmHZ1IMwA6aMZY4zc4CTV
	 O2/NLfF7SBO2g==
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254fa650c8so256638266b.0
        for <linux-efi@vger.kernel.org>; Sat, 19 Sep 2026 07:15:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxnT3Zbou8B1apBAX5cToGu9MJqe6XAmWfTUW3fbT1BxgcVAtsCJJUFR9Q5zYPlnnE7LdGPhW8ynPw=@vger.kernel.org
X-Gm-Message-State: AFuF++lN24ItYw+QPOJfN/S8/TZ8njjKXLFiKIcfuqgAMvCg/vOSty3F
	KEexhL585UjW+PLVVufoxadEik9y6WnBhGzhNTh/QsnfoCFyhvBjVGIzlnnNhn4vWUOIxUFMJli
	TO/pUzDFoHjrn0AFCDDdxvw9TI3sotKw=
X-Received: by 2002:a17:907:8e86:b0:c29:4513:f6fd with SMTP id
 a640c23a62f3a-c2a157fc1cdmr427461966b.35.1789827337280; Sat, 19 Sep 2026
 07:15:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260904100852.26006-1-dongtai.guo@linux.dev> <20260904100852.26006-2-dongtai.guo@linux.dev>
In-Reply-To: <20260904100852.26006-2-dongtai.guo@linux.dev>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 19 Sep 2026 22:15:28 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5-Xr3NsRn+KW47pah42sgON0g0onQ=ExWDYe8=iMiMFg@mail.gmail.com>
X-Gm-Features: AcwNN1Wu2ezGxwQSPYeopFPyOTbuuxRXz-YiTV5Ounc_KY47HsAgFsQWeJyn7EM
Message-ID: <CAAhV-H5-Xr3NsRn+KW47pah42sgON0g0onQ=ExWDYe8=iMiMFg@mail.gmail.com>
Subject: Re: [PATCH v5 1/5] efi: add a KHO configuration table channel
To: George Guo <dongtai.guo@linux.dev>
Cc: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	ardb@kernel.org, shuah@kernel.org, ilias.apalodimas@linaro.org, 
	akpm@linux-foundation.org, baoquan.he@linux.dev, ruirui.yang@linux.dev, 
	guodongtai@kylinos.cn, kernel@xen0n.name, graf@amazon.com, 
	liukexin@kylinos.cn, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, George,

On Fri, Sep 4, 2026 at 6:10=E2=80=AFPM George Guo <dongtai.guo@linux.dev> w=
rote:
>
> From: George Guo <guodongtai@kylinos.cn>
>
> Add an architecture-agnostic EFI configuration table channel for kexec
> handover (KHO): a LINUX_EFI_KEXEC_HANDOVER_GUID table entry pointing at
> a struct linux_efi_kho_data that carries the KHO state FDT and scratch
> area addresses from one kernel to the next.
>
> This is the channel for architectures that boot through EFI without a
> device tree (e.g. LoongArch), where the /chosen linux,kho-fdt and
> linux,kho-scratch properties read by early_init_dt_check_kho() are not
> available.  Architectures with a boot FDT (arm64, riscv) keep using the
> FDT path and do not select this.
>
> The design mirrors the LINUX_EFI_MEMRESERVE_TABLE_GUID channel:
>
>   - The EFI stub allocates and installs the table once at boot
>     (install_kho_table(), next to install_memreserve_table()), so the
>     config table entry is inherited across kexec for free.
>
>   - The reader is a common_tables[] entry in
>     efi_config_parse_tables().  It reserves the stub-allocated table
>     with memblock_reserve(), the same way the memreserve entries are
>     reserved there, so the table is neither handed out by the buddy
>     allocator nor placed on by kexec segments.  It then maps the table
>     and calls kho_populate().  No arch-specific setup.c hook is
>     needed.
>
>   - efi_kho_update() rewrites the table contents in place before a
>     kexec; the config table array is never rebuilt and st->tables is
>     never switched, unlike the per-arch approach it replaces.  The
>     table stays persistently mapped from an early_initcall, the same
>     way the memreserve root is, so the update also works on the crash
>     kexec path.
>
> Gated behind CONFIG_EFI_KHO, selected by architectures that use this
> channel.
>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> ---
>  drivers/firmware/efi/Kconfig            | 12 ++++
>  drivers/firmware/efi/efi.c              | 78 +++++++++++++++++++++++++
>  drivers/firmware/efi/libstub/efi-stub.c | 25 ++++++++
>  include/linux/efi.h                     | 36 ++++++++++++
>  4 files changed, 151 insertions(+)
>
> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> index 29e0729299f5..d6c1372484b4 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -314,6 +314,18 @@ config EFI_SBAT_FILE
>
>           If unsure, leave blank.
>
> +config EFI_KHO
> +       bool
> +       depends on EFI_STUB && EFI_GENERIC_STUB && KEXEC_HANDOVER
> +       help
> +         Carry the KHO state (the KHO state FDT and the scratch area) fr=
om
> +         one kernel to the next across kexec via an EFI configuration ta=
ble
> +         entry under LINUX_EFI_KEXEC_HANDOVER_GUID, for architectures th=
at
> +         boot through EFI without a device tree (e.g. LoongArch).
> +
> +         Architectures with a boot FDT (arm64, riscv) use the /chosen FD=
T
> +         path instead and do not select this.
> +
>  endmenu
>
>  config UEFI_CPER
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 0327a39d31fa..6380cfab1493 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -24,6 +24,7 @@
>  #include <linux/initrd.h>
>  #include <linux/io.h>
>  #include <linux/kexec.h>
> +#include <linux/kexec_handover.h>
>  #include <linux/platform_device.h>
>  #include <linux/random.h>
>  #include <linux/reboot.h>
> @@ -62,6 +63,9 @@ unsigned long __ro_after_init efi_rng_seed =3D EFI_INVA=
LID_TABLE_ADDR;
>  static unsigned long __initdata mem_reserve =3D EFI_INVALID_TABLE_ADDR;
>  static unsigned long __initdata rt_prop =3D EFI_INVALID_TABLE_ADDR;
>  static unsigned long __initdata initrd =3D EFI_INVALID_TABLE_ADDR;
> +#ifdef CONFIG_EFI_KHO
> +static unsigned long __ro_after_init efi_kho_table_phys =3D EFI_INVALID_=
TABLE_ADDR;
I think it is better to define:
static unsigned long __initdata efi_kho =3D EFI_INVALID_TABLE_ADDR;

> +#endif
>
>  extern unsigned long primary_display_table;
>
> @@ -629,6 +633,9 @@ static const efi_config_table_type_t common_tables[] =
__initconst =3D {
>         {EFI_TCG2_FINAL_EVENTS_TABLE_GUID,      &efi.tpm_final_log,     "=
TPMFinalLog"   },
>         {EFI_CC_FINAL_EVENTS_TABLE_GUID,        &efi.tpm_final_log,     "=
CCFinalLog"    },
>         {LINUX_EFI_MEMRESERVE_TABLE_GUID,       &mem_reserve,           "=
MEMRESERVE"    },
> +#ifdef CONFIG_EFI_KHO
> +       {LINUX_EFI_KEXEC_HANDOVER_GUID,         &efi_kho_table_phys,    "=
KHO"           },
> +#endif
>         {LINUX_EFI_INITRD_MEDIA_GUID,           &initrd,                "=
INITRD"        },
>         {EFI_RT_PROPERTIES_TABLE_GUID,          &rt_prop,               "=
RTPROP"        },
>  #ifdef CONFIG_OVMF_DEBUG_LOG
> @@ -806,6 +813,31 @@ int __init efi_config_parse_tables(const efi_config_=
table_t *config_tables,
>                 }
>         }
>
> +#ifdef CONFIG_EFI_KHO
> +       if (efi_kho_table_phys !=3D EFI_INVALID_TABLE_ADDR) {
> +               struct linux_efi_kho_data *kho;
> +
> +               /*
> +                * Reserve the stub-allocated table so it is neither hand=
ed
> +                * out by the buddy allocator nor placed on by kexec
> +                * segments, mirroring the memreserve handling above.  Th=
is
> +                * runs on every boot, so it also protects the table in t=
he
> +                * next kernel until it reads it.
> +                */
> +               memblock_reserve(efi_kho_table_phys, sizeof(*kho));
> +
> +               kho =3D early_memremap(efi_kho_table_phys, sizeof(*kho));
> +               if (kho) {
> +                       if (kho->fdt_addr)
> +                               kho_populate((phys_addr_t)kho->fdt_addr,
> +                                            kho->fdt_size,
> +                                            (phys_addr_t)kho->scratch_ad=
dr,
> +                                            kho->scratch_size);
Now there is no 80 cols limit, you can just use
     kho_populate((phys_addr_t)kho->fdt_addr, kho->fdt_size,
              (phys_addr_t)kho->scratch_addr, kho->scratch_size);

> +                       early_memunmap(kho, sizeof(*kho));
> +               }
> +       }
> +#endif
> +
>         if (rt_prop !=3D EFI_INVALID_TABLE_ADDR) {
>                 efi_rt_properties_table_t *tbl;
>
> @@ -1171,6 +1203,52 @@ static int __init efi_memreserve_root_init(void)
>  }
>  early_initcall(efi_memreserve_root_init);
>
> +#ifdef CONFIG_EFI_KHO
> +static struct linux_efi_kho_data *efi_kho_table __ro_after_init;
> +
> +static int __init efi_kho_table_init(void)
> +{
> +       if (efi_kho_table_phys =3D=3D EFI_INVALID_TABLE_ADDR)
> +               return 0;
> +
> +       /*
> +        * Keep a persistent mapping of the table, the same way
> +        * efi_memreserve_root_init() keeps the memreserve root mapped:
> +        * efi_kho_update() is also called on the crash kexec path, where
> +        * memremap() is no longer an option.
> +        */
> +       efi_kho_table =3D memremap(efi_kho_table_phys, sizeof(*efi_kho_ta=
ble),
> +                                MEMREMAP_WB);
The same, just write it in one line.

> +       WARN_ON_ONCE(!efi_kho_table);
> +
> +       return 0;
> +}
> +early_initcall(efi_kho_table_init);
> +
> +/*
> + * Update the KHO config table in place before a kexec, so the next kern=
el
> + * finds the current handover state.  Mirrors efi_mem_reserve_persistent=
():
> + * the config table entry was installed once by the EFI stub and is inhe=
rited
> + * across kexec, so only the table contents are rewritten here -- the co=
nfig
> + * table array is never rebuilt and st->tables is never switched.
> + */
> +int efi_kho_update(phys_addr_t fdt_addr, u64 fdt_size,
> +                  phys_addr_t scratch_addr, u64 scratch_size)
> +{
> +       struct linux_efi_kho_data *kho =3D efi_kho_table;
> +
> +       if (!kho)
> +               return -ENODEV;
> +
> +       kho->fdt_addr           =3D fdt_addr;
> +       kho->fdt_size           =3D fdt_size;
> +       kho->scratch_addr       =3D scratch_addr;
> +       kho->scratch_size       =3D scratch_size;
> +
> +       return 0;
> +}
> +#endif
> +
>  #ifdef CONFIG_KEXEC
>  static int update_efi_random_seed(struct notifier_block *nb,
>                                   unsigned long code, void *unused)
> diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/e=
fi/libstub/efi-stub.c
> index 42d6073bcd06..751f46280433 100644
> --- a/drivers/firmware/efi/libstub/efi-stub.c
> +++ b/drivers/firmware/efi/libstub/efi-stub.c
> @@ -100,6 +100,29 @@ static void install_memreserve_table(void)
>                 efi_err("Failed to install memreserve config table!\n");
>  }
>
> +static void install_kho_table(void)
> +{
> +#ifdef CONFIG_EFI_KHO
> +       struct linux_efi_kho_data *kho;
> +       efi_guid_t kho_table_guid =3D LINUX_EFI_KEXEC_HANDOVER_GUID;
> +       efi_status_t status;
> +
> +       status =3D efi_bs_call(allocate_pool, EFI_LOADER_DATA, sizeof(*kh=
o),
> +                            (void **)&kho);
The same, just write it in one line.

> +       if (status !=3D EFI_SUCCESS) {
> +               efi_err("Failed to allocate KHO config table!\n");
> +               return;
> +       }
> +
> +       *kho =3D (struct linux_efi_kho_data){};
> +
> +       status =3D efi_bs_call(install_configuration_table, &kho_table_gu=
id,
> +                            kho);
The same, just write it in one line.


> +       if (status !=3D EFI_SUCCESS)
> +               efi_err("Failed to install KHO config table!\n");
> +#endif
> +}
> +
>  static u32 get_supported_rt_services(void)
>  {
>         const efi_rt_properties_table_t *rt_prop_table;
> @@ -180,6 +203,8 @@ efi_status_t efi_stub_common(efi_handle_t handle,
>
>         install_memreserve_table();
>
> +       install_kho_table();
> +
>         status =3D efi_boot_kernel(handle, image, image_addr, cmdline_ptr=
);
>
>         free_primary_display(dpy);
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index aa15ff88539b..564b3cbd5ccb 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -422,6 +422,7 @@ void efi_native_runtime_setup(void);
>  #define LINUX_EFI_COCO_SECRET_AREA_GUID                EFI_GUID(0xadf956=
ad, 0xe98c, 0x484c,  0xae, 0x11, 0xb5, 0x1c, 0x7d, 0x33, 0x64, 0x47)
>  #define LINUX_EFI_BOOT_MEMMAP_GUID             EFI_GUID(0x800f683f, 0xd0=
8b, 0x423a,  0xa2, 0x93, 0x96, 0x5c, 0x3c, 0x6f, 0xe2, 0xb4)
>  #define LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID    EFI_GUID(0xd5d1de3c, 0x10=
5c, 0x44f9,  0x9e, 0xa9, 0xbc, 0xef, 0x98, 0x12, 0x00, 0x31)
> +#define LINUX_EFI_KEXEC_HANDOVER_GUID          EFI_GUID(0xc941b6c7, 0x7b=
3f, 0x4af6,  0x9e, 0x50, 0xfc, 0xb3, 0xa8, 0x86, 0x8a, 0x17)
>
>  #define RISCV_EFI_BOOT_PROTOCOL_GUID           EFI_GUID(0xccd15fec, 0x6f=
73, 0x4eec,  0x83, 0x95, 0x3e, 0x69, 0xe4, 0xb9, 0x40, 0xbf)
>
> @@ -1273,6 +1274,41 @@ struct linux_efi_memreserve {
>
>  void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size);
>
> +#ifdef CONFIG_EFI_KHO
> +/*
> + * The LINUX_EFI_KEXEC_HANDOVER_GUID config table points to this structu=
re.
> + * It carries the kexec handover (KHO) state from the current kernel to =
the
> + * next one: the addresses of the KHO state FDT and of the scratch area.
> + *
> + * This is the handover channel for architectures that boot through EFI
> + * without a device tree (e.g. LoongArch), where the /chosen linux,kho-f=
dt
> + * and linux,kho-scratch properties read by early_init_dt_check_kho() ar=
e not
> + * available.  The EFI stub allocates and installs the table once at boo=
t;
> + * the current kernel updates its contents before a kexec, and the next
> + * kernel reads it back and calls kho_populate().
> + *
> + * The layout is an ABI between the two kernels and carries no version
> + * field: an incompatible change must use a new GUID.  The handover payl=
oad
> + * itself is versioned separately by the compatible string of the KHO st=
ate
> + * FDT, which kho_populate() checks.
> + */
> +struct linux_efi_kho_data {
> +       u64 fdt_addr;
> +       u64 fdt_size;
> +       u64 scratch_addr;
> +       u64 scratch_size;
> +} __packed;
> +
> +int efi_kho_update(phys_addr_t fdt_addr, u64 fdt_size,
> +                  phys_addr_t scratch_addr, u64 scratch_size);
> +#else
> +static inline int efi_kho_update(phys_addr_t fdt_addr, u64 fdt_size,
> +                                phys_addr_t scratch_addr, u64 scratch_si=
ze)
> +{
> +       return 0;
> +}
> +#endif
> +
>  /*
>   * The LINUX_EFI_MOK_VARIABLE_TABLE_GUID config table can be provided
>   * to the kernel by an EFI boot loader. The table contains a packed
> --
> 2.53.0
>
