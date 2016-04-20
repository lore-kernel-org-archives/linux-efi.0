From: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] lib: Always NUL terminate ucs2_as_utf8
Date: Wed, 20 Apr 2016 11:36:37 +0200
Message-ID: <57174DA5.6030602@redhat.com>
References: <1461141427-16361-1-git-send-email-chris@chris-wilson.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461141427-16361-1-git-send-email-chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Jason Andryuk <jandryuk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 04/20/16 10:37, Chris Wilson wrote:
> If the caller, in this case efivarfs_callback(), only provides sufficent
> room for the expanded utf8 and not enough to include the terminating NUL
> byte, that NUL byte is skipped.

How does that occur? In efivarfs_callback() [fs/efivarfs/super.c], we have

	len = ucs2_utf8size(entry->var.VariableName);

	/* name, plus '-', plus GUID, plus NUL*/
	name = kmalloc(len + 1 + EFI_VARIABLE_GUID_LEN + 1, GFP_KERNEL);
	if (!name)
		goto fail;

	ucs2_as_utf8(name, entry->var.VariableName, len);

Instead, I think the following might be happening (note that RIP points
into efivar_variable_is_removable(), and I guess variable_matches()
(which is static) is inlined):

efivarfs_callback()              [fs/efivarfs/super.c]
  efivar_variable_is_removable() [drivers/firmware/efi/vars.c]
    variable_matches()           [drivers/firmware/efi/vars.c]

The bug seems to be in variable_matches(), which doesn't consider the
"len" parameter early enough. Namely, consider that we have the
following input:

- var_name: "a"
- len: 1
- match_name "ab"

In the first iteration of the loop (i.e., *match == 0):
- c = 'a'
- u = 'a'
- *match gets incremented to 1.

In the second iteration of the loop (i.e., *match == 1):
- c = 'b'
- u = <indeterminate value> (that is, undefined behavior),
  because (*match == len).

This seems to be consistent with the error message "Caught 8-bit read
from uninitialized memory": namely, the array allocated for "name" in
efivarfs_callback() is indeed not pre-zeroed, and the ucs2_as_utf8()
function does not populate name[len] -- correctly, I would say.

So, I think the function that needs a fix is variable_matches().

(I don't disagree though that it could be useful to audit all
ucs2_as_utf8() calls.)

Thanks
Laszlo


> When the caller then interprets it as a
> string, it may then read from past its allocated memory:
> 
> [  170.605647] WARNING: kmemcheck: Caught 8-bit read from uninitialized memory (ffff8804079ae786)
> [  170.605677] 436f6e4f757400004c44322d35363062663538612d316530642d346437652d39
> [  170.606037]  i i i i i i u u u u u u u u u u u u u u u u u u u u u u u u u u
> [  170.606236]              ^
> [  170.606243] RIP: 0010:[<ffffffff813a251f>]  [<ffffffff813a251f>] efivar_variable_is_removable+0xaf/0xf0
> [  170.606346] RSP: 0018:ffff880408e73c20  EFLAGS: 00010206
> [  170.606352] RAX: 0000000000000000 RBX: 0000000000000006 RCX: 0000000000000006
> [  170.606359] RDX: 0000000000000000 RSI: 0000000000000074 RDI: ffff880408e73c30
> [  170.606365] RBP: ffff880408e73c80 R08: 0000000000000006 R09: 000000000000008c
> [  170.606371] R10: 0000000000000006 R11: 0000000000000000 R12: ffffffff8166ed20
> [  170.606378] R13: 11d293ca8be4df61 R14: ffffffff81773834 R15: ffff8804079ae780
> [  170.606385] FS:  0000000000000000(0000) GS:ffff88041ca00000(0000) knlGS:0000000000000000
> [  170.606392] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  170.606399] CR2: ffff880409cbe4c0 CR3: 00000004085fd000 CR4: 00000000001406f0
> [  170.606405]  [<ffffffff811eb938>] efivarfs_callback+0xf8/0x275
> [  170.606418]  [<ffffffff813a3368>] efivar_init+0x248/0x2e0
> [  170.606440]  [<ffffffff811eb6b4>] efivarfs_fill_super+0xb4/0xf0
> [  170.606452]  [<ffffffff811333e7>] mount_single+0x87/0xb0
> [  170.606463]  [<ffffffff811eb5f3>] efivarfs_mount+0x13/0x20
> [  170.606475]  [<ffffffff81133480>] mount_fs+0x10/0x90
> [  170.606497]  [<ffffffff8114c732>] vfs_kern_mount+0x62/0x100
> [  170.606508]  [<ffffffff8114ecb0>] do_mount+0x1e0/0xcd0
> [  170.606519]  [<ffffffff8114fa9f>] SyS_mount+0x8f/0xd0
> [  170.606530]  [<ffffffff81451d1f>] entry_SYSCALL_64_fastpath+0x17/0x93
> [  170.606542]  [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: Jason Andryuk <jandryuk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>
> Cc: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  drivers/firmware/efi/vars.c |  2 +-
>  lib/ucs2_string.c           | 15 ++++++++++-----
>  2 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
> index 0ac594c0a234..8dd503bac35d 100644
> --- a/drivers/firmware/efi/vars.c
> +++ b/drivers/firmware/efi/vars.c
> @@ -166,7 +166,7 @@ validate_ascii_string(efi_char16_t *var_name, int match, u8 *buffer,
>  
>  struct variable_validate {
>  	efi_guid_t vendor;
> -	char *name;
> +	const char *name;
>  	bool (*validate)(efi_char16_t *var_name, int match, u8 *data,
>  			 unsigned long len);
>  };
> diff --git a/lib/ucs2_string.c b/lib/ucs2_string.c
> index f0b323abb4c6..fb8d03966656 100644
> --- a/lib/ucs2_string.c
> +++ b/lib/ucs2_string.c
> @@ -85,29 +85,34 @@ ucs2_as_utf8(u8 *dest, const ucs2_char_t *src, unsigned long maxlength)
>  	unsigned long j = 0;
>  	unsigned long limit = ucs2_strnlen(src, maxlength);
>  
> -	for (i = 0; maxlength && i < limit; i++) {
> +	if (maxlength == 0)
> +		return 0;
> +
> +	for (i = 0; i < limit; i++) {
>  		u16 c = src[i];
>  
>  		if (c >= 0x800) {
> -			if (maxlength < 3)
> +			if (maxlength <= 3)
>  				break;
>  			maxlength -= 3;
>  			dest[j++] = 0xe0 | (c & 0xf000) >> 12;
>  			dest[j++] = 0x80 | (c & 0x0fc0) >> 6;
>  			dest[j++] = 0x80 | (c & 0x003f);
>  		} else if (c >= 0x80) {
> -			if (maxlength < 2)
> +			if (maxlength <= 2)
>  				break;
>  			maxlength -= 2;
>  			dest[j++] = 0xc0 | (c & 0x7c0) >> 6;
>  			dest[j++] = 0x80 | (c & 0x03f);
>  		} else {
> +			if (maxlength <= 1)
> +				break;
>  			maxlength -= 1;
>  			dest[j++] = c & 0x7f;
>  		}
>  	}
> -	if (maxlength)
> -		dest[j] = '\0';
> +	dest[j] = '\0';
> +
>  	return j;
>  }
>  EXPORT_SYMBOL(ucs2_as_utf8);
> 
