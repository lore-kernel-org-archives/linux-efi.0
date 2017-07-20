From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v1 1/6] efi: Switch to use new generic UUID API
Date: Thu, 20 Jul 2017 13:18:37 +0100
Message-ID: <CAKv+Gu8Et3smOv9Of47q6VGa9yn9u+vuhS_1B5yg_QULsS4Obg@mail.gmail.com>
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com> <20170719182857.73693-2-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170719182857.73693-2-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, devel@linuxdriverproject.org, sparmaintainer@unisys.com, devel@driverdev.osuosl.org, "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>, linux-watchdog@vger.kernel.org, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Lukas Wunner <lukas@wunner.de>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

On 19 July 2017 at 19:28, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> There are new types and helpers that are supposed to be used in new code.
>
> As a preparation to get rid of legacy types and API functions do
> the conversion here.
>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  drivers/firmware/efi/cper.c | 10 ++---
>  include/linux/cper.h        | 94 ++++++++++++++++++++++-----------------------
>  include/linux/efi.h         |  4 +-
>  3 files changed, 54 insertions(+), 54 deletions(-)
>
> diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
> index 48a8f69da42a..684e65c11dde 100644
> --- a/drivers/firmware/efi/cper.c
> +++ b/drivers/firmware/efi/cper.c
> @@ -534,7 +534,7 @@ static void
>  cper_estatus_print_section(const char *pfx, struct acpi_hest_generic_data *gdata,
>                            int sec_no)
>  {
> -       uuid_le *sec_type = (uuid_le *)gdata->section_type;
> +       guid_t *sec_type = (guid_t *)gdata->section_type;
>         __u16 severity;
>         char newpfx[64];
>
> @@ -545,12 +545,12 @@ cper_estatus_print_section(const char *pfx, struct acpi_hest_generic_data *gdata
>         printk("%s""Error %d, type: %s\n", pfx, sec_no,
>                cper_severity_str(severity));
>         if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
> -               printk("%s""fru_id: %pUl\n", pfx, (uuid_le *)gdata->fru_id);
> +               printk("%s""fru_id: %pUl\n", pfx, gdata->fru_id);
>         if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
>                 printk("%s""fru_text: %.20s\n", pfx, gdata->fru_text);
>
>         snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
> -       if (!uuid_le_cmp(*sec_type, CPER_SEC_PROC_GENERIC)) {
> +       if (guid_equal(sec_type, &CPER_SEC_PROC_GENERIC)) {
>                 struct cper_sec_proc_generic *proc_err = acpi_hest_get_payload(gdata);
>
>                 printk("%s""section_type: general processor error\n", newpfx);
> @@ -558,7 +558,7 @@ cper_estatus_print_section(const char *pfx, struct acpi_hest_generic_data *gdata
>                         cper_print_proc_generic(newpfx, proc_err);
>                 else
>                         goto err_section_too_small;
> -       } else if (!uuid_le_cmp(*sec_type, CPER_SEC_PLATFORM_MEM)) {
> +       } else if (guid_equal(sec_type, &CPER_SEC_PLATFORM_MEM)) {
>                 struct cper_sec_mem_err *mem_err = acpi_hest_get_payload(gdata);
>
>                 printk("%s""section_type: memory error\n", newpfx);
> @@ -568,7 +568,7 @@ cper_estatus_print_section(const char *pfx, struct acpi_hest_generic_data *gdata
>                                        gdata->error_data_length);
>                 else
>                         goto err_section_too_small;
> -       } else if (!uuid_le_cmp(*sec_type, CPER_SEC_PCIE)) {
> +       } else if (guid_equal(sec_type, &CPER_SEC_PCIE)) {
>                 struct cper_sec_pcie *pcie = acpi_hest_get_payload(gdata);
>
>                 printk("%s""section_type: PCIe error\n", newpfx);
> diff --git a/include/linux/cper.h b/include/linux/cper.h
> index 4c671fc2081e..723e952fde0d 100644
> --- a/include/linux/cper.h
> +++ b/include/linux/cper.h
> @@ -74,36 +74,36 @@ enum {
>   * Corrected Machine Check
>   */
>  #define CPER_NOTIFY_CMC                                                        \
> -       UUID_LE(0x2DCE8BB1, 0xBDD7, 0x450e, 0xB9, 0xAD, 0x9C, 0xF4,     \
> -               0xEB, 0xD4, 0xF8, 0x90)
> +       GUID_INIT(0x2DCE8BB1, 0xBDD7, 0x450e, 0xB9, 0xAD, 0x9C, 0xF4,   \
> +                 0xEB, 0xD4, 0xF8, 0x90)
>  /* Corrected Platform Error */
>  #define CPER_NOTIFY_CPE                                                        \
> -       UUID_LE(0x4E292F96, 0xD843, 0x4a55, 0xA8, 0xC2, 0xD4, 0x81,     \
> -               0xF2, 0x7E, 0xBE, 0xEE)
> +       GUID_INIT(0x4E292F96, 0xD843, 0x4a55, 0xA8, 0xC2, 0xD4, 0x81,   \
> +                 0xF2, 0x7E, 0xBE, 0xEE)
>  /* Machine Check Exception */
>  #define CPER_NOTIFY_MCE                                                        \
> -       UUID_LE(0xE8F56FFE, 0x919C, 0x4cc5, 0xBA, 0x88, 0x65, 0xAB,     \
> -               0xE1, 0x49, 0x13, 0xBB)
> +       GUID_INIT(0xE8F56FFE, 0x919C, 0x4cc5, 0xBA, 0x88, 0x65, 0xAB,   \
> +                 0xE1, 0x49, 0x13, 0xBB)
>  /* PCI Express Error */
>  #define CPER_NOTIFY_PCIE                                               \
> -       UUID_LE(0xCF93C01F, 0x1A16, 0x4dfc, 0xB8, 0xBC, 0x9C, 0x4D,     \
> -               0xAF, 0x67, 0xC1, 0x04)
> +       GUID_INIT(0xCF93C01F, 0x1A16, 0x4dfc, 0xB8, 0xBC, 0x9C, 0x4D,   \
> +                 0xAF, 0x67, 0xC1, 0x04)
>  /* INIT Record (for IPF) */
>  #define CPER_NOTIFY_INIT                                               \
> -       UUID_LE(0xCC5263E8, 0x9308, 0x454a, 0x89, 0xD0, 0x34, 0x0B,     \
> -               0xD3, 0x9B, 0xC9, 0x8E)
> +       GUID_INIT(0xCC5263E8, 0x9308, 0x454a, 0x89, 0xD0, 0x34, 0x0B,   \
> +                 0xD3, 0x9B, 0xC9, 0x8E)
>  /* Non-Maskable Interrupt */
>  #define CPER_NOTIFY_NMI                                                        \
> -       UUID_LE(0x5BAD89FF, 0xB7E6, 0x42c9, 0x81, 0x4A, 0xCF, 0x24,     \
> -               0x85, 0xD6, 0xE9, 0x8A)
> +       GUID_INIT(0x5BAD89FF, 0xB7E6, 0x42c9, 0x81, 0x4A, 0xCF, 0x24,   \
> +                 0x85, 0xD6, 0xE9, 0x8A)
>  /* BOOT Error Record */
>  #define CPER_NOTIFY_BOOT                                               \
> -       UUID_LE(0x3D61A466, 0xAB40, 0x409a, 0xA6, 0x98, 0xF3, 0x62,     \
> -               0xD4, 0x64, 0xB3, 0x8F)
> +       GUID_INIT(0x3D61A466, 0xAB40, 0x409a, 0xA6, 0x98, 0xF3, 0x62,   \
> +                 0xD4, 0x64, 0xB3, 0x8F)
>  /* DMA Remapping Error */
>  #define CPER_NOTIFY_DMAR                                               \
> -       UUID_LE(0x667DD791, 0xC6B3, 0x4c27, 0x8A, 0x6B, 0x0F, 0x8E,     \
> -               0x72, 0x2D, 0xEB, 0x41)
> +       GUID_INIT(0x667DD791, 0xC6B3, 0x4c27, 0x8A, 0x6B, 0x0F, 0x8E,   \
> +                 0x72, 0x2D, 0xEB, 0x41)
>
>  /*
>   * Flags bits definitions for flags in struct cper_record_header
> @@ -170,50 +170,50 @@ enum {
>   * Processor Generic
>   */
>  #define CPER_SEC_PROC_GENERIC                                          \
> -       UUID_LE(0x9876CCAD, 0x47B4, 0x4bdb, 0xB6, 0x5E, 0x16, 0xF1,     \
> -               0x93, 0xC4, 0xF3, 0xDB)
> +       GUID_INIT(0x9876CCAD, 0x47B4, 0x4bdb, 0xB6, 0x5E, 0x16, 0xF1,   \
> +                 0x93, 0xC4, 0xF3, 0xDB)
>  /* Processor Specific: X86/X86_64 */
>  #define CPER_SEC_PROC_IA                                               \
> -       UUID_LE(0xDC3EA0B0, 0xA144, 0x4797, 0xB9, 0x5B, 0x53, 0xFA,     \
> -               0x24, 0x2B, 0x6E, 0x1D)
> +       GUID_INIT(0xDC3EA0B0, 0xA144, 0x4797, 0xB9, 0x5B, 0x53, 0xFA,   \
> +                 0x24, 0x2B, 0x6E, 0x1D)
>  /* Processor Specific: IA64 */
>  #define CPER_SEC_PROC_IPF                                              \
> -       UUID_LE(0xE429FAF1, 0x3CB7, 0x11D4, 0x0B, 0xCA, 0x07, 0x00,     \
> -               0x80, 0xC7, 0x3C, 0x88, 0x81)
> +       GUID_INIT(0xE429FAF1, 0x3CB7, 0x11D4, 0x0B, 0xCA, 0x07, 0x00,   \
> +                 0x80, 0xC7, 0x3C, 0x88, 0x81)
>  /* Processor Specific: ARM */
>  #define CPER_SEC_PROC_ARM                                              \
> -       UUID_LE(0xE19E3D16, 0xBC11, 0x11E4, 0x9C, 0xAA, 0xC2, 0x05,     \
> -               0x1D, 0x5D, 0x46, 0xB0)
> +       GUID_INIT(0xE19E3D16, 0xBC11, 0x11E4, 0x9C, 0xAA, 0xC2, 0x05,   \
> +                 0x1D, 0x5D, 0x46, 0xB0)
>  /* Platform Memory */
>  #define CPER_SEC_PLATFORM_MEM                                          \
> -       UUID_LE(0xA5BC1114, 0x6F64, 0x4EDE, 0xB8, 0x63, 0x3E, 0x83,     \
> -               0xED, 0x7C, 0x83, 0xB1)
> +       GUID_INIT(0xA5BC1114, 0x6F64, 0x4EDE, 0xB8, 0x63, 0x3E, 0x83,   \
> +                 0xED, 0x7C, 0x83, 0xB1)
>  #define CPER_SEC_PCIE                                                  \
> -       UUID_LE(0xD995E954, 0xBBC1, 0x430F, 0xAD, 0x91, 0xB4, 0x4D,     \
> -               0xCB, 0x3C, 0x6F, 0x35)
> +       GUID_INIT(0xD995E954, 0xBBC1, 0x430F, 0xAD, 0x91, 0xB4, 0x4D,   \
> +                 0xCB, 0x3C, 0x6F, 0x35)
>  /* Firmware Error Record Reference */
>  #define CPER_SEC_FW_ERR_REC_REF                                                \
> -       UUID_LE(0x81212A96, 0x09ED, 0x4996, 0x94, 0x71, 0x8D, 0x72,     \
> -               0x9C, 0x8E, 0x69, 0xED)
> +       GUID_INIT(0x81212A96, 0x09ED, 0x4996, 0x94, 0x71, 0x8D, 0x72,   \
> +                 0x9C, 0x8E, 0x69, 0xED)
>  /* PCI/PCI-X Bus */
>  #define CPER_SEC_PCI_X_BUS                                             \
> -       UUID_LE(0xC5753963, 0x3B84, 0x4095, 0xBF, 0x78, 0xED, 0xDA,     \
> -               0xD3, 0xF9, 0xC9, 0xDD)
> +       GUID_INIT(0xC5753963, 0x3B84, 0x4095, 0xBF, 0x78, 0xED, 0xDA,   \
> +                 0xD3, 0xF9, 0xC9, 0xDD)
>  /* PCI Component/Device */
>  #define CPER_SEC_PCI_DEV                                               \
> -       UUID_LE(0xEB5E4685, 0xCA66, 0x4769, 0xB6, 0xA2, 0x26, 0x06,     \
> -               0x8B, 0x00, 0x13, 0x26)
> +       GUID_INIT(0xEB5E4685, 0xCA66, 0x4769, 0xB6, 0xA2, 0x26, 0x06,   \
> +                 0x8B, 0x00, 0x13, 0x26)
>  #define CPER_SEC_DMAR_GENERIC                                          \
> -       UUID_LE(0x5B51FEF7, 0xC79D, 0x4434, 0x8F, 0x1B, 0xAA, 0x62,     \
> -               0xDE, 0x3E, 0x2C, 0x64)
> +       GUID_INIT(0x5B51FEF7, 0xC79D, 0x4434, 0x8F, 0x1B, 0xAA, 0x62,   \
> +                 0xDE, 0x3E, 0x2C, 0x64)
>  /* Intel VT for Directed I/O specific DMAr */
>  #define CPER_SEC_DMAR_VT                                               \
> -       UUID_LE(0x71761D37, 0x32B2, 0x45cd, 0xA7, 0xD0, 0xB0, 0xFE,     \
> -               0xDD, 0x93, 0xE8, 0xCF)
> +       GUID_INIT(0x71761D37, 0x32B2, 0x45cd, 0xA7, 0xD0, 0xB0, 0xFE,   \
> +                 0xDD, 0x93, 0xE8, 0xCF)
>  /* IOMMU specific DMAr */
>  #define CPER_SEC_DMAR_IOMMU                                            \
> -       UUID_LE(0x036F84E1, 0x7F37, 0x428c, 0xA7, 0x9E, 0x57, 0x5F,     \
> -               0xDF, 0xAA, 0x84, 0xEC)
> +       GUID_INIT(0x036F84E1, 0x7F37, 0x428c, 0xA7, 0x9E, 0x57, 0x5F,   \
> +                 0xDF, 0xAA, 0x84, 0xEC)
>
>  #define CPER_PROC_VALID_TYPE                   0x0001
>  #define CPER_PROC_VALID_ISA                    0x0002
> @@ -290,10 +290,10 @@ struct cper_record_header {
>         __u32   validation_bits;
>         __u32   record_length;
>         __u64   timestamp;
> -       uuid_le platform_id;
> -       uuid_le partition_id;
> -       uuid_le creator_id;
> -       uuid_le notification_type;
> +       guid_t  platform_id;
> +       guid_t  partition_id;
> +       guid_t  creator_id;
> +       guid_t  notification_type;
>         __u64   record_id;
>         __u32   flags;
>         __u64   persistence_information;
> @@ -309,8 +309,8 @@ struct cper_section_descriptor {
>         __u8    validation_bits;
>         __u8    reserved;               /* must be zero */
>         __u32   flags;
> -       uuid_le section_type;
> -       uuid_le fru_id;
> +       guid_t  section_type;
> +       guid_t  fru_id;
>         __u32   section_severity;
>         __u8    fru_text[20];
>  };
> @@ -343,7 +343,7 @@ struct cper_sec_proc_ia {
>
>  /* IA32/X64 Processor Error Information Structure */
>  struct cper_ia_err_info {
> -       uuid_le err_type;
> +       guid_t  err_type;
>         __u64   validation_bits;
>         __u64   check_info;
>         __u64   target_id;
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 8269bcb8ccf7..7a322aed979f 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -47,10 +47,10 @@ typedef u16 efi_char16_t;           /* UNICODE character */
>  typedef u64 efi_physical_addr_t;
>  typedef void *efi_handle_t;
>
> -typedef uuid_le efi_guid_t;
> +typedef guid_t efi_guid_t;
>
>  #define EFI_GUID(a,b,c,d0,d1,d2,d3,d4,d5,d6,d7) \
> -       UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)
> +       GUID_INIT(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)
>
>  /*
>   * Generic EFI table header
> --
> 2.11.0
>
