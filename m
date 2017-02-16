From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V10 03/10] efi: parse ARM processor error
Date: Thu, 16 Feb 2017 18:26:46 +0000
Message-ID: <CAKv+Gu_gRqjfj9y=_9F5Qj+odDOdUZ1dKohmerXERp252BQjKw@mail.gmail.com>
References: <1487188282-2568-1-git-send-email-tbaicar@codeaurora.org> <1487188282-2568-4-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487188282-2568-4-git-send-email-tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Robert Moore <robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lv Zheng <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, eun.taik.lee-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, shijie.huang-5wv7dgnIgG8@public.gmane.orgRichard Ruigrok <r>
List-Id: linux-efi@vger.kernel.org

On 15 February 2017 at 19:51, Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
> Add support for ARM Common Platform Error Record (CPER).
> UEFI 2.6 specification adds support for ARM specific
> processor error information to be reported as part of the
> CPER records. This provides more detail on for processor error logs.
>
> Signed-off-by: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Signed-off-by: Naveen Kaje <nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Reviewed-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

> ---
>  drivers/firmware/efi/cper.c | 133 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/cper.h        |  54 ++++++++++++++++++
>  2 files changed, 187 insertions(+)
>
> diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
> index 8fa4e23..c2b0a12 100644
> --- a/drivers/firmware/efi/cper.c
> +++ b/drivers/firmware/efi/cper.c
> @@ -110,12 +110,15 @@ void cper_print_bits(const char *pfx, unsigned int bits,
>  static const char * const proc_type_strs[] = {
>         "IA32/X64",
>         "IA64",
> +       "ARM",
>  };
>
>  static const char * const proc_isa_strs[] = {
>         "IA32",
>         "IA64",
>         "X64",
> +       "ARM A32/T32",
> +       "ARM A64",
>  };
>
>  static const char * const proc_error_type_strs[] = {
> @@ -139,6 +142,18 @@ void cper_print_bits(const char *pfx, unsigned int bits,
>         "corrected",
>  };
>
> +static const char * const arm_reg_ctx_strs[] = {
> +       "AArch32 general purpose registers",
> +       "AArch32 EL1 context registers",
> +       "AArch32 EL2 context registers",
> +       "AArch32 secure context registers",
> +       "AArch64 general purpose registers",
> +       "AArch64 EL1 context registers",
> +       "AArch64 EL2 context registers",
> +       "AArch64 EL3 context registers",
> +       "Misc. system register structure",
> +};
> +
>  static void cper_print_proc_generic(const char *pfx,
>                                     const struct cper_sec_proc_generic *proc)
>  {
> @@ -184,6 +199,114 @@ static void cper_print_proc_generic(const char *pfx,
>                 printk("%s""IP: 0x%016llx\n", pfx, proc->ip);
>  }
>
> +static void cper_print_proc_arm(const char *pfx,
> +                               const struct cper_sec_proc_arm *proc)
> +{
> +       int i, len, max_ctx_type;
> +       struct cper_arm_err_info *err_info;
> +       struct cper_arm_ctx_info *ctx_info;
> +       char newpfx[64];
> +
> +       printk("%s""section length: %d\n", pfx, proc->section_length);
> +       printk("%s""MIDR: 0x%016llx\n", pfx, proc->midr);
> +
> +       len = proc->section_length - (sizeof(*proc) +
> +               proc->err_info_num * (sizeof(*err_info)));
> +       if (len < 0) {
> +               printk("%s""section length is too small\n", pfx);
> +               printk("%s""firmware-generated error record is incorrect\n", pfx);
> +               printk("%s""ERR_INFO_NUM is %d\n", pfx, proc->err_info_num);
> +               return;
> +       }
> +
> +       if (proc->validation_bits & CPER_ARM_VALID_MPIDR)
> +               printk("%s""MPIDR: 0x%016llx\n", pfx, proc->mpidr);
> +       if (proc->validation_bits & CPER_ARM_VALID_AFFINITY_LEVEL)
> +               printk("%s""error affinity level: %d\n", pfx,
> +                       proc->affinity_level);
> +       if (proc->validation_bits & CPER_ARM_VALID_RUNNING_STATE) {
> +               printk("%s""running state: 0x%x\n", pfx, proc->running_state);
> +               printk("%s""PSCI state: %d\n", pfx, proc->psci_state);
> +       }
> +
> +       snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
> +
> +       err_info = (struct cper_arm_err_info *)(proc + 1);
> +       for (i = 0; i < proc->err_info_num; i++) {
> +               printk("%s""Error info structure %d:\n", pfx, i);
> +               printk("%s""version:%d\n", newpfx, err_info->version);
> +               printk("%s""length:%d\n", newpfx, err_info->length);
> +               if (err_info->validation_bits &
> +                   CPER_ARM_INFO_VALID_MULTI_ERR) {
> +                       if (err_info->multiple_error == 0)
> +                               printk("%s""single error\n", newpfx);
> +                       else if (err_info->multiple_error == 1)
> +                               printk("%s""multiple errors\n", newpfx);
> +                       else
> +                               printk("%s""multiple errors count:%u\n",
> +                               newpfx, err_info->multiple_error);
> +               }
> +               if (err_info->validation_bits & CPER_ARM_INFO_VALID_FLAGS) {
> +                       if (err_info->flags & CPER_ARM_INFO_FLAGS_FIRST)
> +                               printk("%s""first error captured\n", newpfx);
> +                       if (err_info->flags & CPER_ARM_INFO_FLAGS_LAST)
> +                               printk("%s""last error captured\n", newpfx);
> +                       if (err_info->flags & CPER_ARM_INFO_FLAGS_PROPAGATED)
> +                               printk("%s""propagated error captured\n",
> +                                      newpfx);
> +                       if (err_info->flags & CPER_ARM_INFO_FLAGS_OVERFLOW)
> +                               printk("%s""overflow occurred, error info is incomplete\n",
> +                                      newpfx);
> +               }
> +               printk("%s""error_type: %d, %s\n", newpfx, err_info->type,
> +                       err_info->type < ARRAY_SIZE(proc_error_type_strs) ?
> +                       proc_error_type_strs[err_info->type] : "unknown");
> +               if (err_info->validation_bits & CPER_ARM_INFO_VALID_ERR_INFO)
> +                       printk("%s""error_info: 0x%016llx\n", newpfx,
> +                              err_info->error_info);
> +               if (err_info->validation_bits & CPER_ARM_INFO_VALID_VIRT_ADDR)
> +                       printk("%s""virtual fault address: 0x%016llx\n",
> +                               newpfx, err_info->virt_fault_addr);
> +               if (err_info->validation_bits &
> +                   CPER_ARM_INFO_VALID_PHYSICAL_ADDR)
> +                       printk("%s""physical fault address: 0x%016llx\n",
> +                               newpfx, err_info->physical_fault_addr);
> +               err_info += 1;
> +       }
> +       ctx_info = (struct cper_arm_ctx_info *)err_info;
> +       max_ctx_type = ARRAY_SIZE(arm_reg_ctx_strs) - 1;
> +       for (i = 0; i < proc->context_info_num; i++) {
> +               int size = sizeof(*ctx_info) + ctx_info->size;
> +
> +               printk("%s""Context info structure %d:\n", pfx, i);
> +               if (len < size) {
> +                       printk("%s""section length is too small\n", newpfx);
> +                       printk("%s""firmware-generated error record is incorrect\n", pfx);
> +                       return;
> +               }
> +               if (ctx_info->type > max_ctx_type) {
> +                       printk("%s""Invalid context type: %d\n", newpfx,
> +                                                       ctx_info->type);
> +                       printk("%s""Max context type: %d\n", newpfx,
> +                                                       max_ctx_type);
> +                       return;
> +               }
> +               printk("%s""register context type %d: %s\n", newpfx,
> +                       ctx_info->type, arm_reg_ctx_strs[ctx_info->type]);
> +               print_hex_dump(newpfx, "", DUMP_PREFIX_OFFSET, 16, 4,
> +                               (ctx_info + 1), ctx_info->size, 0);
> +               len -= size;
> +               ctx_info = (struct cper_arm_ctx_info *)((long)ctx_info + size);
> +       }
> +
> +       if (len > 0) {
> +               printk("%s""Vendor specific error info has %u bytes:\n", pfx,
> +                      len);
> +               print_hex_dump(newpfx, "", DUMP_PREFIX_OFFSET, 16, 4, ctx_info,
> +                               len, 0);
> +       }
> +}
> +
>  static const char * const mem_err_type_strs[] = {
>         "unknown",
>         "no error",
> @@ -458,6 +581,16 @@ static void cper_estatus_print_section(
>                         cper_print_pcie(newpfx, pcie, gdata);
>                 else
>                         goto err_section_too_small;
> +       } else if ((IS_ENABLED(CONFIG_ARM64) || IS_ENABLED(CONFIG_ARM)) &&
> +                  !uuid_le_cmp(*sec_type, CPER_SEC_PROC_ARM)) {
> +               struct cper_sec_proc_arm *arm_err;
> +
> +               arm_err = acpi_hest_generic_data_payload(gdata);
> +               printk("%ssection_type: ARM processor error\n", newpfx);
> +               if (gdata->error_data_length >= sizeof(*arm_err))
> +                       cper_print_proc_arm(newpfx, arm_err);
> +               else
> +                       goto err_section_too_small;
>         } else
>                 printk("%s""section type: unknown, %pUl\n", newpfx, sec_type);
>
> diff --git a/include/linux/cper.h b/include/linux/cper.h
> index dcacb1a..85450f3 100644
> --- a/include/linux/cper.h
> +++ b/include/linux/cper.h
> @@ -180,6 +180,10 @@ enum {
>  #define CPER_SEC_PROC_IPF                                              \
>         UUID_LE(0xE429FAF1, 0x3CB7, 0x11D4, 0x0B, 0xCA, 0x07, 0x00,     \
>                 0x80, 0xC7, 0x3C, 0x88, 0x81)
> +/* Processor Specific: ARM */
> +#define CPER_SEC_PROC_ARM                                              \
> +       UUID_LE(0xE19E3D16, 0xBC11, 0x11E4, 0x9C, 0xAA, 0xC2, 0x05,     \
> +               0x1D, 0x5D, 0x46, 0xB0)
>  /* Platform Memory */
>  #define CPER_SEC_PLATFORM_MEM                                          \
>         UUID_LE(0xA5BC1114, 0x6F64, 0x4EDE, 0xB8, 0x63, 0x3E, 0x83,     \
> @@ -255,6 +259,22 @@ enum {
>
>  #define CPER_PCIE_SLOT_SHIFT                   3
>
> +#define CPER_ARM_VALID_MPIDR                   0x00000001
> +#define CPER_ARM_VALID_AFFINITY_LEVEL          0x00000002
> +#define CPER_ARM_VALID_RUNNING_STATE           0x00000004
> +#define CPER_ARM_VALID_VENDOR_INFO             0x00000008
> +
> +#define CPER_ARM_INFO_VALID_MULTI_ERR          0x0001
> +#define CPER_ARM_INFO_VALID_FLAGS              0x0002
> +#define CPER_ARM_INFO_VALID_ERR_INFO           0x0004
> +#define CPER_ARM_INFO_VALID_VIRT_ADDR          0x0008
> +#define CPER_ARM_INFO_VALID_PHYSICAL_ADDR      0x0010
> +
> +#define CPER_ARM_INFO_FLAGS_FIRST              0x0001
> +#define CPER_ARM_INFO_FLAGS_LAST               0x0002
> +#define CPER_ARM_INFO_FLAGS_PROPAGATED         0x0004
> +#define CPER_ARM_INFO_FLAGS_OVERFLOW           0x0008
> +
>  /*
>   * All tables and structs must be byte-packed to match CPER
>   * specification, since the tables are provided by the system BIOS
> @@ -340,6 +360,40 @@ struct cper_ia_proc_ctx {
>         __u64   mm_reg_addr;
>  };
>
> +/* ARM Processor Error Section */
> +struct cper_sec_proc_arm {
> +       __u32   validation_bits;
> +       __u16   err_info_num; /* Number of Processor Error Info */
> +       __u16   context_info_num; /* Number of Processor Context Info Records*/
> +       __u32   section_length;
> +       __u8    affinity_level;
> +       __u8    reserved[3];    /* must be zero */
> +       __u64   mpidr;
> +       __u64   midr;
> +       __u32   running_state; /* Bit 0 set - Processor running. PSCI = 0 */
> +       __u32   psci_state;
> +};
> +
> +/* ARM Processor Error Information Structure */
> +struct cper_arm_err_info {
> +       __u8    version;
> +       __u8    length;
> +       __u16   validation_bits;
> +       __u8    type;
> +       __u16   multiple_error;
> +       __u8    flags;
> +       __u64   error_info;
> +       __u64   virt_fault_addr;
> +       __u64   physical_fault_addr;
> +};
> +
> +/* ARM Processor Context Information Structure */
> +struct cper_arm_ctx_info {
> +       __u16   version;
> +       __u16   type;
> +       __u32   size;
> +};
> +
>  /* Old Memory Error Section UEFI 2.1, 2.2 */
>  struct cper_sec_mem_err_old {
>         __u64   validation_bits;
> --
> Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
> Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project.
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
