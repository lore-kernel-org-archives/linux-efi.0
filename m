From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi: Use LocateHandleBuffer instead of LocateHandle
Date: Fri, 9 Sep 2016 11:52:32 +0100
Message-ID: <CAKv+Gu_kfnHfiBH__Wnvh39KMPj_-s39YyY=pT3roNv7iPPzrA@mail.gmail.com>
References: <1d7915dc0dd328ca04088f6b8b3fcfad5cec55a0.1473275006.git.lukas@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1d7915dc0dd328ca04088f6b8b3fcfad5cec55a0.1473275006.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 8 September 2016 at 01:02, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> Use LocateHandleBuffer instead of the LocateHandle + AllocatePool +
> LocateHandle combo to save a bit on code.
>
> Usage of LocateHandle for UGA and GOP has been present in the efistub
> since its introduction with commit 291f36325f9f ("x86, efi: EFI boot
> stub support"). It was subsequently inherited by the PCI ROM retrieval
> with commit dd5fc854de5f ("EFI: Stash ROMs if they're not in the PCI
> BAR").
>
> One valid reason to not use LocateHandleBuffer would be if a specific
> memory type is required for the buffer, and particularly if the buffer
> needs to persist across ExitBootServices. The spec does not mandate
> which type is used, edk2 seems to default to EfiBootServicesData.
> In the three use cases modified by this commit (UGA, GOP, PCI), the
> buffer is freed before ExitBootServices is called. Hence the memory
> type is irrelevant.
>
> No functional change intended.
>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
> ---
>

What is the oldest UEFI version we claim to support? For ARM, this is
not an issue, but it appears that LocateHandleBuffer () was introduced
in v1.10

> The patch can be reviewed somewhat more comfortably with green/red
> highlighting on GitHub:
> https://github.com/l1k/linux/commit/2ff1fc10c84f
>
> It depends on two patches which are already queued in Matt's tree for 4.9:
>
> "x86/efi: Optimize away setup_gop32/64 if unused"
> https://patchwork.kernel.org/patch/9315763/
>
> "x86/efi: Allow invocation of arbitrary boot services"
> https://patchwork.kernel.org/patch/9293371/
>
>  arch/x86/boot/compressed/eboot.c        | 90 ++++++++++-----------------------
>  drivers/firmware/efi/libstub/arm-stub.c | 17 ++++---
>  drivers/firmware/efi/libstub/gop.c      | 29 +++--------
>  include/linux/efi.h                     |  5 +-
>  4 files changed, 47 insertions(+), 94 deletions(-)
>
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index 447a6a2..87c8d31 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -340,13 +340,12 @@ free_struct:
>
>  static void
>  setup_efi_pci32(struct boot_params *params, void **pci_handle,
> -               unsigned long size)
> +               unsigned long nr_pci)
>  {
>         efi_pci_io_protocol_32 *pci = NULL;
>         efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
>         u32 *handles = (u32 *)(unsigned long)pci_handle;
>         efi_status_t status;
> -       unsigned long nr_pci;
>         struct setup_data *data;
>         int i;
>
> @@ -355,7 +354,6 @@ setup_efi_pci32(struct boot_params *params, void **pci_handle,
>         while (data && data->next)
>                 data = (struct setup_data *)(unsigned long)data->next;
>
> -       nr_pci = size / sizeof(u32);
>         for (i = 0; i < nr_pci; i++) {
>                 struct pci_setup_rom *rom = NULL;
>                 u32 h = handles[i];
> @@ -447,13 +445,12 @@ free_struct:
>
>  static void
>  setup_efi_pci64(struct boot_params *params, void **pci_handle,
> -               unsigned long size)
> +               unsigned long nr_pci)
>  {
>         efi_pci_io_protocol_64 *pci = NULL;
>         efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
>         u64 *handles = (u64 *)(unsigned long)pci_handle;
>         efi_status_t status;
> -       unsigned long nr_pci;
>         struct setup_data *data;
>         int i;
>
> @@ -462,7 +459,6 @@ setup_efi_pci64(struct boot_params *params, void **pci_handle,
>         while (data && data->next)
>                 data = (struct setup_data *)(unsigned long)data->next;
>
> -       nr_pci = size / sizeof(u64);
>         for (i = 0; i < nr_pci; i++) {
>                 struct pci_setup_rom *rom = NULL;
>                 u64 h = handles[i];
> @@ -502,53 +498,38 @@ setup_efi_pci64(struct boot_params *params, void **pci_handle,
>  static void setup_efi_pci(struct boot_params *params)
>  {
>         efi_status_t status;
> -       void **pci_handle = NULL;
> +       void **pci_handle;
>         efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
> -       unsigned long size = 0;
> +       unsigned long nr_pci;
>
> -       status = efi_call_early(locate_handle,
> +       status = efi_call_early(locate_handle_buffer,
>                                 EFI_LOCATE_BY_PROTOCOL,
> -                               &pci_proto, NULL, &size, pci_handle);
> +                               &pci_proto, NULL, &nr_pci, &pci_handle);
>
> -       if (status == EFI_BUFFER_TOO_SMALL) {
> -               status = efi_call_early(allocate_pool,
> -                                       EFI_LOADER_DATA,
> -                                       size, (void **)&pci_handle);
> -
> -               if (status != EFI_SUCCESS) {
> -                       efi_printk(sys_table, "Failed to alloc mem for pci_handle\n");
> -                       return;
> -               }
> -
> -               status = efi_call_early(locate_handle,
> -                                       EFI_LOCATE_BY_PROTOCOL, &pci_proto,
> -                                       NULL, &size, pci_handle);
> -       }
> +       if (status == EFI_OUT_OF_RESOURCES)
> +               efi_printk(sys_table, "Failed to alloc mem for pci_handle\n");
>
>         if (status != EFI_SUCCESS)
> -               goto free_handle;
> +               return;
>
>         if (efi_early->is64)
> -               setup_efi_pci64(params, pci_handle, size);
> +               setup_efi_pci64(params, pci_handle, nr_pci);
>         else
> -               setup_efi_pci32(params, pci_handle, size);
> +               setup_efi_pci32(params, pci_handle, nr_pci);
>
> -free_handle:
>         efi_call_early(free_pool, pci_handle);
>  }
>
>  static efi_status_t
> -setup_uga32(void **uga_handle, unsigned long size, u32 *width, u32 *height)
> +setup_uga32(void **uga_handle, unsigned long nr_ugas, u32 *width, u32 *height)
>  {
>         struct efi_uga_draw_protocol *uga = NULL, *first_uga;
>         efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
> -       unsigned long nr_ugas;
>         u32 *handles = (u32 *)uga_handle;;
>         efi_status_t status = EFI_INVALID_PARAMETER;
>         int i;
>
>         first_uga = NULL;
> -       nr_ugas = size / sizeof(u32);
>         for (i = 0; i < nr_ugas; i++) {
>                 efi_guid_t pciio_proto = EFI_PCI_IO_PROTOCOL_GUID;
>                 u32 w, h, depth, refresh;
> @@ -583,17 +564,15 @@ setup_uga32(void **uga_handle, unsigned long size, u32 *width, u32 *height)
>  }
>
>  static efi_status_t
> -setup_uga64(void **uga_handle, unsigned long size, u32 *width, u32 *height)
> +setup_uga64(void **uga_handle, unsigned long nr_ugas, u32 *width, u32 *height)
>  {
>         struct efi_uga_draw_protocol *uga = NULL, *first_uga;
>         efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
> -       unsigned long nr_ugas;
>         u64 *handles = (u64 *)uga_handle;;
>         efi_status_t status = EFI_INVALID_PARAMETER;
>         int i;
>
>         first_uga = NULL;
> -       nr_ugas = size / sizeof(u64);
>         for (i = 0; i < nr_ugas; i++) {
>                 efi_guid_t pciio_proto = EFI_PCI_IO_PROTOCOL_GUID;
>                 u32 w, h, depth, refresh;
> @@ -631,30 +610,18 @@ setup_uga64(void **uga_handle, unsigned long size, u32 *width, u32 *height)
>   * See if we have Universal Graphics Adapter (UGA) protocol
>   */
>  static efi_status_t setup_uga(struct screen_info *si, efi_guid_t *uga_proto,
> -                             unsigned long size)
> +                             unsigned long nr_ugas, void **uga_handle)
>  {
>         efi_status_t status;
>         u32 width, height;
> -       void **uga_handle = NULL;
> -
> -       status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
> -                               size, (void **)&uga_handle);
> -       if (status != EFI_SUCCESS)
> -               return status;
> -
> -       status = efi_call_early(locate_handle,
> -                               EFI_LOCATE_BY_PROTOCOL,
> -                               uga_proto, NULL, &size, uga_handle);
> -       if (status != EFI_SUCCESS)
> -               goto free_handle;
>
>         height = 0;
>         width = 0;
>
>         if (efi_early->is64)
> -               status = setup_uga64(uga_handle, size, &width, &height);
> +               status = setup_uga64(uga_handle, nr_ugas, &width, &height);
>         else
> -               status = setup_uga32(uga_handle, size, &width, &height);
> +               status = setup_uga32(uga_handle, nr_ugas, &width, &height);
>
>         if (!width && !height)
>                 goto free_handle;
> @@ -686,27 +653,26 @@ void setup_graphics(struct boot_params *boot_params)
>         struct screen_info *si;
>         efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
>         efi_status_t status;
> -       unsigned long size;
> -       void **gop_handle = NULL;
> -       void **uga_handle = NULL;
> +       unsigned long nr;
> +       void **gop_handle;
> +       void **uga_handle;
>
>         si = &boot_params->screen_info;
>         memset(si, 0, sizeof(*si));
>
> -       size = 0;
> -       status = efi_call_early(locate_handle,
> +       status = efi_call_early(locate_handle_buffer,
>                                 EFI_LOCATE_BY_PROTOCOL,
> -                               &graphics_proto, NULL, &size, gop_handle);
> -       if (status == EFI_BUFFER_TOO_SMALL)
> -               status = efi_setup_gop(NULL, si, &graphics_proto, size);
> +                               &graphics_proto, NULL, &nr, &gop_handle);
> +       if (status == EFI_SUCCESS)
> +               status = efi_setup_gop(NULL, si, &graphics_proto, nr,
> +                                      gop_handle);
>
>         if (status != EFI_SUCCESS) {
> -               size = 0;
> -               status = efi_call_early(locate_handle,
> +               status = efi_call_early(locate_handle_buffer,
>                                         EFI_LOCATE_BY_PROTOCOL,
> -                                       &uga_proto, NULL, &size, uga_handle);
> -               if (status == EFI_BUFFER_TOO_SMALL)
> -                       setup_uga(si, &uga_proto, size);
> +                                       &uga_proto, NULL, &nr, &uga_handle);
> +               if (status == EFI_SUCCESS)
> +                       setup_uga(si, &uga_proto, nr, uga_handle);
>         }
>  }
>
> diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
> index 993aa56..27fd62d 100644
> --- a/drivers/firmware/efi/libstub/arm-stub.c
> +++ b/drivers/firmware/efi/libstub/arm-stub.c
> @@ -173,18 +173,19 @@ static struct screen_info *setup_graphics(efi_system_table_t *sys_table_arg)
>  {
>         efi_guid_t gop_proto = EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID;
>         efi_status_t status;
> -       unsigned long size;
> -       void **gop_handle = NULL;
> +       unsigned long nr;
> +       void **gop_handle;
>         struct screen_info *si = NULL;
>
> -       size = 0;
> -       status = efi_call_early(locate_handle, EFI_LOCATE_BY_PROTOCOL,
> -                               &gop_proto, NULL, &size, gop_handle);
> -       if (status == EFI_BUFFER_TOO_SMALL) {
> +       status = efi_call_early(locate_handle_buffer, EFI_LOCATE_BY_PROTOCOL,
> +                               &gop_proto, NULL, &nr, &gop_handle);
> +       if (status == EFI_SUCCESS) {
>                 si = alloc_screen_info(sys_table_arg);
> -               if (!si)
> +               if (!si) {
> +                       efi_call_early(free_pool, gop_handle);
>                         return NULL;
> -               efi_setup_gop(sys_table_arg, si, &gop_proto, size);
> +               }
> +               efi_setup_gop(sys_table_arg, si, &gop_proto, nr, gop_handle);
>         }
>         return si;
>  }
> diff --git a/drivers/firmware/efi/libstub/gop.c b/drivers/firmware/efi/libstub/gop.c
> index 932742e..a2dca32 100644
> --- a/drivers/firmware/efi/libstub/gop.c
> +++ b/drivers/firmware/efi/libstub/gop.c
> @@ -111,10 +111,9 @@ __gop_query32(efi_system_table_t *sys_table_arg,
>
>  static efi_status_t
>  setup_gop32(efi_system_table_t *sys_table_arg, struct screen_info *si,
> -            efi_guid_t *proto, unsigned long size, void **gop_handle)
> +           efi_guid_t *proto, unsigned long nr_gops, void **gop_handle)
>  {
>         struct efi_graphics_output_protocol_32 *gop32, *first_gop;
> -       unsigned long nr_gops;
>         u16 width, height;
>         u32 pixels_per_scan_line;
>         u32 ext_lfb_base;
> @@ -128,7 +127,6 @@ setup_gop32(efi_system_table_t *sys_table_arg, struct screen_info *si,
>         first_gop = NULL;
>         gop32 = NULL;
>
> -       nr_gops = size / sizeof(u32);
>         for (i = 0; i < nr_gops; i++) {
>                 struct efi_graphics_output_mode_info *info = NULL;
>                 efi_guid_t conout_proto = EFI_CONSOLE_OUT_DEVICE_GUID;
> @@ -136,6 +134,7 @@ setup_gop32(efi_system_table_t *sys_table_arg, struct screen_info *si,
>                 void *dummy = NULL;
>                 efi_handle_t h = (efi_handle_t)(unsigned long)handles[i];
>                 u64 current_fb_base;
> +               unsigned long size;
>
>                 status = efi_call_early(handle_protocol, h,
>                                         proto, (void **)&gop32);
> @@ -228,10 +227,9 @@ __gop_query64(efi_system_table_t *sys_table_arg,
>
>  static efi_status_t
>  setup_gop64(efi_system_table_t *sys_table_arg, struct screen_info *si,
> -           efi_guid_t *proto, unsigned long size, void **gop_handle)
> +           efi_guid_t *proto, unsigned long nr_gops, void **gop_handle)
>  {
>         struct efi_graphics_output_protocol_64 *gop64, *first_gop;
> -       unsigned long nr_gops;
>         u16 width, height;
>         u32 pixels_per_scan_line;
>         u32 ext_lfb_base;
> @@ -245,7 +243,6 @@ setup_gop64(efi_system_table_t *sys_table_arg, struct screen_info *si,
>         first_gop = NULL;
>         gop64 = NULL;
>
> -       nr_gops = size / sizeof(u64);
>         for (i = 0; i < nr_gops; i++) {
>                 struct efi_graphics_output_mode_info *info = NULL;
>                 efi_guid_t conout_proto = EFI_CONSOLE_OUT_DEVICE_GUID;
> @@ -253,6 +250,7 @@ setup_gop64(efi_system_table_t *sys_table_arg, struct screen_info *si,
>                 void *dummy = NULL;
>                 efi_handle_t h = (efi_handle_t)(unsigned long)handles[i];
>                 u64 current_fb_base;
> +               unsigned long size;
>
>                 status = efi_call_early(handle_protocol, h,
>                                         proto, (void **)&gop64);
> @@ -324,31 +322,18 @@ out:
>   */
>  efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
>                            struct screen_info *si, efi_guid_t *proto,
> -                          unsigned long size)
> +                          unsigned long nr_gops, void **gop_handle)
>  {
>         efi_status_t status;
> -       void **gop_handle = NULL;
> -
> -       status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
> -                               size, (void **)&gop_handle);
> -       if (status != EFI_SUCCESS)
> -               return status;
> -
> -       status = efi_call_early(locate_handle,
> -                               EFI_LOCATE_BY_PROTOCOL,
> -                               proto, NULL, &size, gop_handle);
> -       if (status != EFI_SUCCESS)
> -               goto free_handle;
>
>         if (efi_is_64bit()) {
> -               status = setup_gop64(sys_table_arg, si, proto, size,
> +               status = setup_gop64(sys_table_arg, si, proto, nr_gops,
>                                      gop_handle);
>         } else {
> -               status = setup_gop32(sys_table_arg, si, proto, size,
> +               status = setup_gop32(sys_table_arg, si, proto, nr_gops,
>                                      gop_handle);
>         }
>
> -free_handle:
>         efi_call_early(free_pool, gop_handle);
>         return status;
>  }
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 4ae1a1a..52fe49d 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -304,7 +304,8 @@ typedef struct {
>         void *close_protocol;
>         void *open_protocol_information;
>         void *protocols_per_handle;
> -       void *locate_handle_buffer;
> +       efi_status_t (*locate_handle_buffer)(int, efi_guid_t *, void *,
> +                                            unsigned long *, efi_handle_t **);
>         efi_status_t (*locate_protocol)(efi_guid_t *, void *, void **);
>         void *install_multiple_protocol_interfaces;
>         void *uninstall_multiple_protocol_interfaces;
> @@ -1424,7 +1425,7 @@ efi_status_t efi_parse_options(char *cmdline);
>
>  efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
>                            struct screen_info *si, efi_guid_t *proto,
> -                          unsigned long size);
> +                          unsigned long nr_gops, void **gop_handle);
>
>  bool efi_runtime_disabled(void);
>  extern void efi_call_virt_check_flags(unsigned long flags, const char *call);
> --
> 2.9.3
>
