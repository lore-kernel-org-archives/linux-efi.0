From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH] x86/efi: initialize status to ensure garbage is not
 returned on small size
Date: Wed, 27 Jul 2016 15:50:16 +0100
Message-ID: <ada10a97-f3d3-91af-51b8-6d2f973c95a1@canonical.com>
References: <1469009466-19980-1-git-send-email-colin.king@canonical.com>
 <20160727143813.GG31759@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160727143813.GG31759-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 27/07/16 15:38, Matt Fleming wrote:
> On Wed, 20 Jul, at 11:11:06AM, Colin Ian King wrote:
>> From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>>
>> Although very unlikey, if size is too small or zero, then we end up with
>> status not being set and returning garbage. Instead, initializing status to
>> EFI_INVALID_PARAMETER to indicate that size is invalid in the calls to
>> setup_uga32 and setup_uga64.
>>
>> Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>> ---
>>  arch/x86/boot/compressed/eboot.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
>> index ff574da..ec6d2ef 100644
>> --- a/arch/x86/boot/compressed/eboot.c
>> +++ b/arch/x86/boot/compressed/eboot.c
>> @@ -578,7 +578,7 @@ setup_uga32(void **uga_handle, unsigned long size, u32 *width, u32 *height)
>>  	efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
>>  	unsigned long nr_ugas;
>>  	u32 *handles = (u32 *)uga_handle;;
>> -	efi_status_t status;
>> +	efi_status_t status = EFI_INVALID_PARAMETER;
>>  	int i;
>>  
>>  	first_uga = NULL;
>> @@ -623,7 +623,7 @@ setup_uga64(void **uga_handle, unsigned long size, u32 *width, u32 *height)
>>  	efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
>>  	unsigned long nr_ugas;
>>  	u64 *handles = (u64 *)uga_handle;;
>> -	efi_status_t status;
>> +	efi_status_t status = EFI_INVALID_PARAMETER;
>>  	int i;
>>  
>>  	first_uga = NULL;
> 
> Can this ever happen in practice? This would imply that
> locate_protocol() found EFI_UGA_PROTOCOL_GUID but that the size
> returned is utterly bogus?

I just wanted to guard against the call
efi_call_early(locate_handle, EFI_LOCATE_BY_PROTOCOL, &uga_proto, NULL,
&size, uga_handle) returning a bogus size of less than a u32/u64
(depending on the setup_uga32/setup_uga64), which I was not 100% sure if
this could happen or not, so I always assume efi_call_early calls can go
wrong when you least expect them.

> 
> If so, I have no problem applying the patch but want to make sure
> we're not tricking ourselves into thinking we're being protected from
> something when we're not.
> 

I'd rather put extra guarding in rather than getting some potential
garbage return from the stack, but I am playing it rather conservatively
here.

Colin
