From: Bhupesh Sharma <bhsharma@redhat.com>
Subject: Re: [PATCH 1/2] x86/efi: Correct a tiny mistake in code comment
Date: Wed, 8 Mar 2017 14:30:14 +0530
Message-ID: <CACi5LpOjxiiCEvdOHGxHj_c+G-W3HKHr8EgOURpZ-cb5XqQnNQ@mail.gmail.com>
References: <1488959258-4731-1-git-send-email-bhe@redhat.com> <20170308081812.GA12600@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170308081812.GA12600@dhcp-128-65.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, thgarnie@google.com, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, akpm@linux-foundation.org
List-Id: linux-efi@vger.kernel.org

Hi Dave,

On Wed, Mar 8, 2017 at 1:48 PM, Dave Young <dyoung@redhat.com> wrote:
> On 03/08/17 at 03:47pm, Baoquan He wrote:
>> EFI allocate runtime services regions down from EFI_VA_START, -4G.
>> It should be top-down handling.
>>
>> Signed-off-by: Baoquan He <bhe@redhat.com>
>> ---
>>  arch/x86/platform/efi/efi_64.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
>> index a4695da..6cbf9e0 100644
>> --- a/arch/x86/platform/efi/efi_64.c
>> +++ b/arch/x86/platform/efi/efi_64.c
>> @@ -47,7 +47,7 @@
>>  #include <asm/pgalloc.h>
>>
>>  /*
>> - * We allocate runtime services regions bottom-up, starting from -4G, i.e.
>> + * We allocate runtime services regions top-down, starting from -4G, i.e.
>
> Baoquan, I think original bottom-up is right, it is just considering
> -68G as up, see the x86_64 mm.txt. We regard vmalloc as higher address
> although from mathematics view it is lower then positive addresses.

I think you have a valid point, but I think the -4G convention is
probably too confusing to read and may lead to issues when we use this
for future feature addition as well. It would be more useful to use
the macros similar to the MODULES_{} addresses we use currently in
'arch/x86/include/asm/pgtable_64_types.h':

#define MODULES_VADDR    (__START_KERNEL_map + KERNEL_IMAGE_SIZE)
#define MODULES_END      _AC(0xffffffffff000000, UL)
#define MODULES_LEN   (MODULES_END - MODULES_VADDR)

May be we can use the following convention for the EFI_VA_{} addresses
as per 'http://lxr.free-electrons.com/source/Documentation/x86/x86_64/mm.txt#L19':

#define EFI_VA_START    _AC(0xfffffffeffffffff, UL)
#define EFI_VA_END    _AC(0xffffffef00000000, UL)

which is less confusing to read in my opinion.

@Baoquan: Please share your views.

Regards,
Bhupesh
