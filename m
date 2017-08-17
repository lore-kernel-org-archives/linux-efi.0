From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC Part1 PATCH v3 09/17] resource: Consolidate resource walking
 code
Date: Thu, 17 Aug 2017 13:55:18 -0500
Message-ID: <a31c9643-87a5-ae4a-25a5-9dae235f158d@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-10-brijesh.singh@amd.com>
 <20170728152342.GB11564@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170728152342.GB11564-K5JNixvcfoxupOikMc4+xw@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Piotr Luc <piotr.luc-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Reza Arbab <arbab-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Benjamin
List-Id: linux-efi@vger.kernel.org

On 7/28/2017 10:23 AM, Borislav Petkov wrote:
> On Mon, Jul 24, 2017 at 02:07:49PM -0500, Brijesh Singh wrote:
>> From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>>
>> The walk_iomem_res_desc(), walk_system_ram_res() and walk_system_ram_range()
>> functions each have much of the same code.  Create a new function that
>> consolidates the common code from these functions in one place to reduce
>> the amount of duplicated code.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>> Signed-off-by: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
>> ---
>>   kernel/resource.c | 53 ++++++++++++++++++++++++++---------------------------
>>   1 file changed, 26 insertions(+), 27 deletions(-)
>>
>> diff --git a/kernel/resource.c b/kernel/resource.c
>> index 9b5f044..7b20b3e 100644
>> --- a/kernel/resource.c
>> +++ b/kernel/resource.c
>> @@ -397,9 +397,30 @@ static int find_next_iomem_res(struct resource *res, unsigned long desc,
>>   		res->start = p->start;
>>   	if (res->end > p->end)
>>   		res->end = p->end;
>> +	res->desc = p->desc;
>>   	return 0;
> 
> I must be going blind: where are we using that res->desc?

I think that was left-over from the initial consolidation work I was
doing.  I'll remove it.

> 
>> +static int __walk_iomem_res_desc(struct resource *res, unsigned long desc,
>> +				 bool first_level_children_only,
> 
> Btw, that variable name is insanely long.

I know, but I'm maintaining consistency with the name that was already
present vs. changing it.

> 
> The rest looks ok to me, thanks for the cleanup!

Thanks,
Tom

> 
