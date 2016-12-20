From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] efi/libstub: arm*: Pass latest memory map to the kernel
Date: Tue, 20 Dec 2016 22:32:33 +0000
Message-ID: <CAKv+Gu8_8+GdaV86_ctf=PzKxPvT3tbUOcuz5OkyBya5OC+ekw@mail.gmail.com>
References: <20161219142419.16780-1-james.morse@arm.com> <20161219213859.GA2225@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161219213859.GA2225-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Jeff Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 19 December 2016 at 21:38, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Mon, 19 Dec, at 02:24:19PM, James Morse wrote:
>> From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>
>> As reported by James, the current libstub code involving the annotated
>> memory map only works somewhat correctly by accident, due to the fact
>> that a pool allocation happens to be reused immediately, retaining its
>> former contents.
>>
>> Instead of juggling memory maps, which makes the code more complex than
>> it needs to be, simply put a placholder value into the FDT, and only
>> write the actual value after ExitBootServices() has been called.
>>
>> Reported-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> [Update mmap-size too, remove updated_fdt()s unused params and header entry]
>> Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
>> ---
>> Hi Ard,
>>
>> This is a v2 of your patch that updates the mmap-size too. This solves the
>> truncated memmap problem I saw with v1 on Seattle.
>>
>> The original patch was CC-stable, so I think this should also have:
>> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>> Fixes: ed9cc156c42f ("efi/libstub: Use efi_exit_boot_services() in FDT")
>>
>>
>> Thanks,
>>
>> James
>>
>>  drivers/firmware/efi/libstub/efistub.h |  8 ----
>>  drivers/firmware/efi/libstub/fdt.c     | 75 +++++++++++++++++++++-------------
>>  2 files changed, 47 insertions(+), 36 deletions(-)
>
> Thanks James. I've queued this one up in the 'urgent' queue and tagged
> it for stable. I'll send it to tip before the end of the week.

Could we fold the hunk below, please?

diff --git a/drivers/firmware/efi/libstub/fdt.c
b/drivers/firmware/efi/libstub/fdt.c
index 9b11b0559a23..90ab96845937 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -149,26 +149,25 @@ static efi_status_t
update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 static efi_status_t update_fdt_memmap(void *fdt, u64 memmap, u32 map_size)
 {
        int node = fdt_path_offset(fdt, "/chosen");
-       efi_status_t status;
+       int err;

        if (node < 0)
                return EFI_LOAD_ERROR;

        memmap = cpu_to_fdt64(memmap);
-       status = fdt_setprop_inplace(fdt, node, "linux,uefi-mmap-start",
-                                    &memmap, sizeof(memmap));
+       err = fdt_setprop_inplace(fdt, node, "linux,uefi-mmap-start",
+                                 &memmap, sizeof(memmap));

        if (status)
                return EFI_LOAD_ERROR;

        map_size = cpu_to_fdt32(map_size);
-       status = fdt_setprop_inplace(fdt, node, "linux,uefi-mmap-size",
-                                    &map_size, sizeof(map_size));
+       err = fdt_setprop_inplace(fdt, node, "linux,uefi-mmap-size",
+                                 &map_size, sizeof(map_size));

        if (status)
                return EFI_LOAD_ERROR;

-
        return EFI_SUCCESS;
 }

My mistake, and harmless in practice, but sloppy nonetheless
