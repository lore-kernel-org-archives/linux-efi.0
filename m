From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 09/13] ARM: Xen: Initialize Xen specific UEFI runtime services
Date: Tue, 17 Nov 2015 12:28:45 +0100
Message-ID: <CAKv+Gu9-g6fttchWkg_ptCGwUD-hbyM2F0x1Wrv=dAa6bsMVBQ@mail.gmail.com>
References: <1447754231-7772-1-git-send-email-shannon.zhao@linaro.org>
	<1447754231-7772-10-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447754231-7772-10-git-send-email-shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ian Campbell <ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Stefano Stabellini <stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Julien Grall <julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Huangpeng (Peter)" <peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hangaohuai <hangaohuai-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 17 November 2015 at 10:57,  <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> When running on Xen hypervisor, runtime services are supported through
> hypercall. So call Xen specific function to initialize runtime services.
>
> Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm/include/asm/xen/hypercall.h |  1 +
>  arch/arm/xen/enlighten.c             |  1 +
>  arch/arm/xen/hypercall.S             |  1 +
>  arch/arm64/kernel/efi.c              | 20 ++++++++++++++------
>  arch/arm64/xen/hypercall.S           |  1 +
>  drivers/xen/Kconfig                  |  2 +-
>  drivers/xen/efi.c                    | 22 ++++++++++++++++++++++
>  include/xen/xen-ops.h                | 10 ++++++++++
>  8 files changed, 51 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm/include/asm/xen/hypercall.h b/arch/arm/include/asm/xen/hypercall.h
> index 712b50e..0de6074 100644
> --- a/arch/arm/include/asm/xen/hypercall.h
> +++ b/arch/arm/include/asm/xen/hypercall.h
> @@ -50,6 +50,7 @@ int HYPERVISOR_physdev_op(int cmd, void *arg);
>  int HYPERVISOR_vcpu_op(int cmd, int vcpuid, void *extra_args);
>  int HYPERVISOR_tmem_op(void *arg);
>  int HYPERVISOR_multicall(struct multicall_entry *calls, uint32_t nr);
> +int HYPERVISOR_dom0_op(void *arg);
>
>  static inline int
>  HYPERVISOR_suspend(unsigned long start_info_mfn)
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 7cb82f7..1373d6d 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -289,3 +289,4 @@ EXPORT_SYMBOL_GPL(HYPERVISOR_vcpu_op);
>  EXPORT_SYMBOL_GPL(HYPERVISOR_tmem_op);
>  EXPORT_SYMBOL_GPL(HYPERVISOR_multicall);
>  EXPORT_SYMBOL_GPL(privcmd_call);
> +EXPORT_SYMBOL_GPL(HYPERVISOR_dom0_op);
> diff --git a/arch/arm/xen/hypercall.S b/arch/arm/xen/hypercall.S
> index 10fd99c..16fc153 100644
> --- a/arch/arm/xen/hypercall.S
> +++ b/arch/arm/xen/hypercall.S
> @@ -90,6 +90,7 @@ HYPERCALL2(physdev_op);
>  HYPERCALL3(vcpu_op);
>  HYPERCALL1(tmem_op);
>  HYPERCALL2(multicall);
> +HYPERCALL1(dom0_op);
>
>  ENTRY(privcmd_call)
>         stmdb sp!, {r4}
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index 13671a9..ab1c9e9 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -34,6 +34,9 @@
>  #include <asm/mmu.h>
>  #include <asm/pgtable.h>
>
> +#include <xen/xen.h>
> +#include <xen/xen-ops.h>
> +
>  struct efi_memory_map memmap;
>
>  static u64 efi_system_table;
> @@ -308,13 +311,18 @@ static int __init arm64_enable_runtime_services(void)
>         }
>         set_bit(EFI_SYSTEM_TABLES, &efi.flags);
>
> -       if (!efi_virtmap_init()) {
> -               pr_err("No UEFI virtual mapping was installed -- runtime services will not be available\n");
> -               return -1;
> -       }
> +       if (!xen_initial_domain()) {
> +               if (!efi_virtmap_init()) {
> +                       pr_err("No UEFI virtual mapping was installed -- runtime services will not be available\n");
> +                       return -1;
> +               }
>

I'd prefer it if we could separate the code logically, rather than
putting xen_initial_domain() tests in all the code paths.

For instance, we could re-use the EFI_PARAVIRT flag, and set if from
the Xen init code. Then, we could simply test it here, and bail early.
That way, you can have a Xen specific alternative (which does not use
the virtmap etc anyway) in a xen source file.

> -       /* Set up runtime services function pointers */
> -       efi_native_runtime_setup();
> +               /* Set up runtime services function pointers */
> +               efi_native_runtime_setup();
> +       } else {
> +               /* Set up runtime services function pointers for Xen UEFI */
> +               xen_efi_runtime_setup();
> +       }
>         set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
>
>         efi.runtime_version = efi.systab->hdr.revision;
> diff --git a/arch/arm64/xen/hypercall.S b/arch/arm64/xen/hypercall.S
> index 8bbe940..f6e15aa 100644
> --- a/arch/arm64/xen/hypercall.S
> +++ b/arch/arm64/xen/hypercall.S
> @@ -81,6 +81,7 @@ HYPERCALL2(physdev_op);
>  HYPERCALL3(vcpu_op);
>  HYPERCALL1(tmem_op);
>  HYPERCALL2(multicall);
> +HYPERCALL1(dom0_op);
>
>  ENTRY(privcmd_call)
>         mov x16, x0
> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
> index 73708ac..59aec8b 100644
> --- a/drivers/xen/Kconfig
> +++ b/drivers/xen/Kconfig
> @@ -268,7 +268,7 @@ config XEN_HAVE_PVMMU
>
>  config XEN_EFI
>         def_bool y
> -       depends on X86_64 && EFI
> +       depends on ARM64 || X86_64 && EFI
>
>  config XEN_AUTO_XLATE
>         def_bool y
> diff --git a/drivers/xen/efi.c b/drivers/xen/efi.c
> index f745db2..5246d89 100644
> --- a/drivers/xen/efi.c
> +++ b/drivers/xen/efi.c
> @@ -33,6 +33,7 @@
>
>  #define INIT_EFI_OP(name) \
>         {.cmd = XENPF_efi_runtime_call, \
> +        .interface_version = XENPF_INTERFACE_VERSION, \
>          .u.efi_runtime_call.function = XEN_EFI_##name, \
>          .u.efi_runtime_call.misc = 0}
>
> @@ -261,6 +262,7 @@ static efi_status_t xen_efi_query_capsule_caps(efi_capsule_header_t **capsules,
>         return efi_data(op).status;
>  }
>
> +#ifdef CONFIG_x86
>  static efi_char16_t vendor[100] __initdata;
>
>  static efi_system_table_t efi_systab_xen __initdata = {
> @@ -319,7 +321,26 @@ static const struct efi efi_xen __initconst = {
>         .memmap                   = NULL, /* Not used under Xen. */
>         .flags                    = 0     /* Initialized later. */
>  };
> +#endif
>
> +#ifdef CONFIG_ARM64
> +void xen_efi_runtime_setup(void)
> +{
> +       efi.get_time = xen_efi_get_time;
> +       efi.set_time = xen_efi_set_time;
> +       efi.get_wakeup_time = xen_efi_get_wakeup_time;
> +       efi.set_wakeup_time = xen_efi_set_wakeup_time;
> +       efi.get_variable = xen_efi_get_variable;
> +       efi.get_next_variable = xen_efi_get_next_variable;
> +       efi.set_variable = xen_efi_set_variable;
> +       efi.query_variable_info = xen_efi_query_variable_info;
> +       efi.update_capsule = xen_efi_update_capsule;
> +       efi.query_capsule_caps = xen_efi_query_capsule_caps;
> +       efi.get_next_high_mono_count = xen_efi_get_next_high_mono_count;
> +}
> +#endif
> +
> +#ifdef CONFIG_X86
>  efi_system_table_t __init *xen_efi_probe(void)
>  {
>         struct xen_platform_op op = {
> @@ -369,3 +390,4 @@ efi_system_table_t __init *xen_efi_probe(void)
>
>         return &efi_systab_xen;
>  }
> +#endif
> diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
> index e4e214a..a6c26ad 100644
> --- a/include/xen/xen-ops.h
> +++ b/include/xen/xen-ops.h
> @@ -84,13 +84,23 @@ int xen_xlate_unmap_gfn_range(struct vm_area_struct *vma,
>  bool xen_running_on_version_or_later(unsigned int major, unsigned int minor);
>
>  #ifdef CONFIG_XEN_EFI
> +#ifdef CONFIG_X86
>  extern efi_system_table_t *xen_efi_probe(void);
> +#endif
> +#ifdef CONFIG_ARM64
> +extern void xen_efi_runtime_setup(void);
> +#endif
>  #else
> +#ifdef CONFIG_X86
>  static inline efi_system_table_t __init *xen_efi_probe(void)
>  {
>         return NULL;
>  }
>  #endif
> +#ifdef CONFIG_ARM64
> +static inline void xen_efi_runtime_setup(void) { }
> +#endif
> +#endif
>
>  #ifdef CONFIG_PREEMPT
>
> --
> 2.1.0
>
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
