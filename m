From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [BUG/RFC] efi/libstub: Preserve the memory map pointed to by the FDT
Date: Fri, 9 Dec 2016 17:51:43 +0000
Message-ID: <CAKv+Gu9ObGf97ysyOwLZaaah=88=CMMQiX47t3JY=gj3wCVShQ@mail.gmail.com>
References: <20161209171501.21269-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161209171501.21269-1-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi James,

On 9 December 2016 at 17:15, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org> wrote:
> allocate_new_fdt_and_exit_boot() bakes a pointer to the UEFI memory map
> into the FDT for later use. The corresponding memory is then free()d
> and (hopefully) allocated again via efi_exit_boot_services() calling
> efi_get_memory_map() as part of the exit_boot_services() loop. The
> final copy is annotated with virtual mappings and used to create the
> runtime map.
>
> Linux expects the FDT to contain a pointer to the UEFI memory map
> with the virtual mapping annotations, which will only happen if
> AllocatePool() returns memory to the stub that was just FreePool()d
> by the stub. This behaviour doesn't appear to guaranteed by the spec.
>
> Platforms that don't do this will use the stale memory map (assuming
> no later owner of the freed() memory changed it) and fail to initialise
> runtime services.
>
> Instead, keep the memory map we baked info the FDT, and create a new
> 'exit_map' pointer for use in the exit_boot_services() loop. (This was
> already different, it just had the same name and we hoped it would be
> in the same place).
>
> Annotate the memory map pointed to by the FDT with virtual mappings.
> This assumes the final memory map (which may be different), has
> not moved any of the regions with the runtime attribute.
>
> (Take the opportunity to remove some comments that are stale since
>  commit ed9cc156c42f ("efi/libstub: Use efi_exit_boot_services() in FDT"))
>
> Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
> Fixes: ed9cc156c42f ("efi/libstub: Use efi_exit_boot_services() in FDT")
> Cc: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

 ---
> I haven't seen this causing problems on any real platforms, only kvmtool
> which I'm busily hacking up to have primitive UEFI support. Needless to
> say my AllocatePool() doesn't re-use memory.
>

Thanks for the report. This is obviously a serious bug, and should be
fixed asap.

However, the approach is not correct. The whole point of the memory
map dance is that *only* the final version is correct, and the code
Jeffrey added is to ensure that even if ExitBootServices() fails the
first time (which can occur when a timer event fires between
GetMemoryMap() and ExitBootServices()), the memory map is retrieved
again.

The only correct approach is to annotate the final version with
virtual addresses, and pass /that/ address to the kernel. So the bug
is arguably that we pass the wrong version of the memory map to the
OS.

I think we need to fix this by using fdt_setprop_inplace() to poke the
correct value into the FDT after ExitBootServices() returns.

-- 
Ard.


>  drivers/firmware/efi/libstub/fdt.c | 23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
> index a6a93116a8f0..f623894c633c 100644
> --- a/drivers/firmware/efi/libstub/fdt.c
> +++ b/drivers/firmware/efi/libstub/fdt.c
> @@ -181,10 +181,6 @@ static efi_status_t exit_boot_func(efi_system_table_t *sys_table_arg,
>   * which are fixed at 4K bytes, so in most cases the first
>   * allocation should succeed.
>   * EFI boot services are exited at the end of this function.
> - * There must be no allocations between the get_memory_map()
> - * call and the exit_boot_services() call, so the exiting of
> - * boot services is very tightly tied to the creation of the FDT
> - * with the final memory map in it.
>   */
>
>  efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
> @@ -199,7 +195,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
>         unsigned long map_size, desc_size, buff_size;
>         u32 desc_ver;
>         unsigned long mmap_key;
> -       efi_memory_desc_t *memory_map, *runtime_map;
> +       efi_memory_desc_t *memory_map, *runtime_map, *exit_map;
>         unsigned long new_fdt_size;
>         efi_status_t status;
>         int runtime_entry_count = 0;
> @@ -243,11 +239,6 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
>                         goto fail;
>                 }
>
> -               /*
> -                * Now that we have done our final memory allocation (and free)
> -                * we can get the memory map key  needed for
> -                * exit_boot_services().
> -                */
>                 status = efi_get_memory_map(sys_table, &map);
>                 if (status != EFI_SUCCESS)
>                         goto fail_free_new_fdt;
> @@ -259,8 +250,16 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
>                                     memory_map, map_size, desc_size, desc_ver);
>
>                 /* Succeeding the first time is the expected case. */
> -               if (status == EFI_SUCCESS)
> +               if (status == EFI_SUCCESS) {
> +                       /*
> +                        * Annotate the memory_map in the FDT with virtual
> +                        * addresses. These shouldn't change as the placement
> +                        * of EFI_MEMORY_RUNTIME regions should be fixed.
> +                        */
> +                       efi_get_virtmap(memory_map, map_size, desc_size,
> +                                       runtime_map, &runtime_entry_count);
>                         break;
> +               }
>
>                 if (status == EFI_BUFFER_TOO_SMALL) {
>                         /*
> @@ -279,7 +278,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
>                 }
>         }
>
> -       sys_table->boottime->free_pool(memory_map);
> +       map.map = &exit_map;
>         priv.runtime_map = runtime_map;
>         priv.runtime_entry_count = &runtime_entry_count;
>         status = efi_exit_boot_services(sys_table, handle, &map, &priv,
> --
> 2.10.1
>
