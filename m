From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC Part1 PATCH v3 07/17] x86/mm: Include SEV for encryption
 memory attribute changes
Date: Thu, 17 Aug 2017 13:21:39 -0500
Message-ID: <786b615a-941c-ae83-e02b-01ece58af5b3@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-8-brijesh.singh@amd.com>
 <20170727145841.GG28553@nazgul.tnic>
 <063D6719AE5E284EB5DD2968C1650D6DD0045508@AcuExch.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6DD0045508-VkEWCZq2GCInGFn1LkZF6NBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>, 'Borislav Petkov' <bp-l3A5Bk7waGM@public.gmane.org>, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?UTF-8?Q?Radim_Krcm=c3=a1r?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Piotr Luc <piotr.luc-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Reza Arbab <arbab-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andy Lutomirski <luto@ker>
List-Id: linux-efi@vger.kernel.org

On 7/28/2017 3:47 AM, David Laight wrote:
> From: Borislav Petkov
>> Sent: 27 July 2017 15:59
>> On Mon, Jul 24, 2017 at 02:07:47PM -0500, Brijesh Singh wrote:
>>> From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>>>
>>> The current code checks only for sme_active() when determining whether
>>> to perform the encryption attribute change.  Include sev_active() in this
>>> check so that memory attribute changes can occur under SME and SEV.
>>>
>>> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>>> Signed-off-by: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
>>> ---
>>>   arch/x86/mm/pageattr.c | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
>>> index dfb7d65..b726b23 100644
>>> --- a/arch/x86/mm/pageattr.c
>>> +++ b/arch/x86/mm/pageattr.c
>>> @@ -1781,8 +1781,8 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>>>   	unsigned long start;
>>>   	int ret;
>>>
>>> -	/* Nothing to do if the SME is not active */
>>> -	if (!sme_active())
>>> +	/* Nothing to do if SME and SEV are not active */
>>> +	if (!sme_active() && !sev_active())
>>
>> This is the second place which does
>>
>> 	if (!SME && !SEV)
>>
>> I wonder if, instead of sprinking those, we should have a
>>
>> 	if (mem_enc_active())
>>
>> or so which unifies all those memory encryption logic tests and makes
>> the code more straightforward for readers who don't have to pay
>> attention to SME vs SEV ...
> 
> If any of the code paths are 'hot' it would make sense to be checking
> a single memory location.

The function would check a single variable/memory location and making it
an inline function would accomplish that.

Thanks,
Tom

> 
> 	David
> 
