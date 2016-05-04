From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: efi: Add 'capsule' update support
Date: Wed, 4 May 2016 14:28:50 +0200
Message-ID: <CAKv+Gu9zw2ydSrRADz0RWa7N-9+bw4fqqPJua+3gC2i+RLNc4w@mail.gmail.com>
References: <20160502182500.GA3461@mwanda>
	<20160503145050.GY2839@codeblueprint.co.uk>
	<CAKv+Gu-CBymL85xJnmC9d9nuUOuMU3kBAONWtj1-_ck4hEzxiQ@mail.gmail.com>
	<20160504121241.GI2839@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160504121241.GI2839-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 4 May 2016 at 14:12, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Tue, 03 May, at 05:58:18PM, Ard Biesheuvel wrote:
>>
>> Well, I suppose we could simply allocate the pointer array and the
>> single member statically, i.e.,
>>
>> efi_capsule_header_t capsule1;
>> efi_capsule_header_t *capsule[] = { &capsule1 };
>>
>> That way, we can get rid of the heap allocation entirely, and we take
>> the address of the array, i.e., without the &
>
> This?
>

Yes, that looks correct to me, although I haven't tried to compile it.

Acked-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>


> ---
>
> From cc80265af2073e99627933d9a2192a175dddaca0 Mon Sep 17 00:00:00 2001
> From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Date: Wed, 4 May 2016 12:52:06 +0100
> Subject: [PATCH] efi/capsule: Move 'capsule' to the stack in
>  efi_capsule_supported()
>
> Dan reports that passing the address of the pointer to the kmalloc()'d
> memory for 'capsule' is dangerous,
>
>  "drivers/firmware/efi/capsule.c:109 efi_capsule_supported()
>   warn: did you mean to pass the address of 'capsule'
>
>    108
>    109          status = efi.query_capsule_caps(&capsule, 1, &max_size, reset);
>                                                 ^^^^^^^^
>   If we modify capsule inside this function call then at the end of the
>   function we aren't freeing the original pointer that we allocated."
>
> Ard noted that we don't even need to call kmalloc() since the object
> we allocate isn't very big and doesn't need to persist after the
> function returns.
>
> Place 'capsule' on the stack instead.
>
> Suggested-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
> Cc: Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
> Cc: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
> Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> ---
>  drivers/firmware/efi/capsule.c | 29 +++++++++++------------------
>  1 file changed, 11 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
> index 4703dc9b8fbd..7593108f5402 100644
> --- a/drivers/firmware/efi/capsule.c
> +++ b/drivers/firmware/efi/capsule.c
> @@ -86,33 +86,26 @@ bool efi_capsule_pending(int *reset_type)
>   */
>  int efi_capsule_supported(efi_guid_t guid, u32 flags, size_t size, int *reset)
>  {
> -       efi_capsule_header_t *capsule;
> +       efi_capsule_header_t capsule;
> +       efi_capsule_header_t *cap_list[] = { &capsule };
>         efi_status_t status;
>         u64 max_size;
> -       int rv = 0;
>
>         if (flags & ~EFI_CAPSULE_SUPPORTED_FLAG_MASK)
>                 return -EINVAL;
>
> -       capsule = kmalloc(sizeof(*capsule), GFP_KERNEL);
> -       if (!capsule)
> -               return -ENOMEM;
> -
> -       capsule->headersize = capsule->imagesize = sizeof(*capsule);
> -       memcpy(&capsule->guid, &guid, sizeof(efi_guid_t));
> -       capsule->flags = flags;
> +       capsule.headersize = capsule.imagesize = sizeof(capsule);
> +       memcpy(&capsule.guid, &guid, sizeof(efi_guid_t));
> +       capsule.flags = flags;
>
> -       status = efi.query_capsule_caps(&capsule, 1, &max_size, reset);
> -       if (status != EFI_SUCCESS) {
> -               rv = efi_status_to_err(status);
> -               goto out;
> -       }
> +       status = efi.query_capsule_caps(cap_list, 1, &max_size, reset);
> +       if (status != EFI_SUCCESS)
> +               return efi_status_to_err(status);
>
>         if (size > max_size)
> -               rv = -ENOSPC;
> -out:
> -       kfree(capsule);
> -       return rv;
> +               return -ENOSPC;
> +
> +       return 0;
>  }
>  EXPORT_SYMBOL_GPL(efi_capsule_supported);
>
> --
> 2.7.3
>
