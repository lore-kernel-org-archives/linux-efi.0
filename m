From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] Fix allocation size calculations
Date: Mon, 31 Oct 2016 07:57:40 +0000
Message-ID: <CAKv+Gu-XzL+CK_YuFJoJLuDB70K6gt07uLRiUjocDVYKD0j2vQ@mail.gmail.com>
References: <20161025163634.11893-1-roy.franz@hpe.com> <CAKv+Gu8FDUQDD4-QCeB7ELFR9LHqr_qTHmjDVgp5xa6LnxNZXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu8FDUQDD4-QCeB7ELFR9LHqr_qTHmjDVgp5xa6LnxNZXw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-ZPxbGqLxI0U@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roy Franz <roy.franz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 25 October 2016 at 19:03, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On 25 October 2016 at 17:36, Roy Franz <roy.franz-ZPxbGqLxI0U@public.gmane.org> wrote:
>> Adjust the size used in calculations to match the actual size of allocation
>> that will be performed based on EFI size/alignment constraints.
>> efi_high_alloc() and efi_low_alloc() use the passed size in bytes directly
>> to find space in the memory map for the allocation, rather than the actual
>> allocation size that has been adjusted for size and alignment constraints.
>> This results in failed allocations and retries in efi_high_alloc().  The
>> same error is present in efi_low_alloc(), although failure will only happen
>> if the lowest memory block is small.
>> Also use EFI_PAGE_SIZE consistently and remove use of EFI_PAGE_SHIFT to
>> calculate page size.
>>
>> Signed-off-by: Roy Franz <roy.franz-ZPxbGqLxI0U@public.gmane.org>
>
> Reviewed-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>

Applied, thanks.
