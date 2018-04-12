From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC] arm64: extra entries in /proc/iomem for kexec
Date: Thu, 12 Apr 2018 17:01:52 +0100
Message-ID: <4c59b4c3-cff4-ac69-9576-6bcbf507ef1f@arm.com>
References: <20180314082941.GM25863@linaro.org>
 <2d2e1be6-b925-1595-9b6e-76dd270d396d@redhat.com>
 <20180327101654.GB14737@linaro.org>
 <da2989ec-7fa5-b044-3237-4e75f2fe6d98@arm.com>
 <20180402015330.GA27603@linaro.org> <20180405024203.GD19607@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <20180405024203.GD19607-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Bhupesh SHARMA <bhupesh.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Akashi,

Sorry I've been sluggish on this issue,

On 05/04/18 03:42, AKASHI Takahiro wrote:
> On Mon, Apr 02, 2018 at 10:53:32AM +0900, AKASHI Takahiro wrote:
>> On Tue, Mar 27, 2018 at 02:32:49PM +0100, James Morse wrote:
>>> On 27/03/18 11:16, AKASHI Takahiro wrote:
>>>> On Tue, Mar 20, 2018 at 01:18:34AM +0530, Bhupesh Sharma wrote:
>>>>> On 03/14/2018 01:59 PM, AKASHI Takahiro wrote:
>>>>>> Currently, there is a inconsistent view between (A) and the mainline's:
>>>>>> see (A-1) and (B-1). If this is really a matter, I can fix it.
>>>>>> Kexec-tools can be easily modified to accept both formats, though.
>>>
>>> Ooer, what needs changing in kexec-tools? What happens if someone doesn't update
>>> userspace at the same time?
>>
>> Basically, changes that I made on /proc/iomem in my new format D were:
>> 1. to move NOMAP region entries, formerly named "reserved" and now named
>>    "reserved (no map)", under System RAM
>> 2. to add new entries for firmware-reserved regions as "reserved" also
>>    under System RAM
>>
>> On the other hand, current kexec-tools, in particular kexec command,
>> only scan top-level "System RAM" entries as well as "reserved" entries.

as well as?

Does this mean kexec will pick up the reserved region if its written as:
| 00001000-0009d7ff : System RAM
|    00001000-00001fff  : reserved


>> So if someone doesn't update kexec-tools, secondary kernel may potentially
>> crash during boot time

Doesn't this make it a kernel bug? This didn't happen before v4.14 because nomap
and kexec-don't-write-here were the same thing. Since f56ab9a5b73c they aren't,
as ACPI_RECLAIM_MEMORY is_usable_memory(). The memblock_reserve() is enough to
stop the kernel overwriting the region, but not to stop kexec placing the new
kernel over the top.

(now I can't see how the efi memory map itself is reserved ... I thought that
was nomap too, but it looks like its just 'not mapped' when efi_init() is called)


>> either because
>> a. new kernel (or initrd/dtb) may have been allocated on a NOMAP region
>>    which are not suitable for usable memory, or
>> b. new kernel (or initrd/dtb) may have been allocated on a reserved region
>>    whose contents can be overwritten.
>>
>> While we see (b) even today, (a) is a backward compatibility issue.

(a) doesn't happen because request_standard_resources() checks
memblock_is_nomap(), and reports those regions as 'reserved'.


[...]

>>>>> I think we should preserve all the memblock_reserve'd regions. So +1 on this
>>>>> approach from my side. I believe it might help avoid issues we have seen in
>>>>> the past with 'kexec-tools' _incorrectly_ determining which regions to pick
>>>>> from the '/proc/iomem'.
>>>>
>>>> As I said in my reply to Ard's comment, I now know *overkill* is not a big
>>>> issue and I will go for this approach.
>>>
>>> /sys/kernel/debug/memblock/reserved has all kinds of weird stuff in it,
>>> including some smaller-than-a-page reservations that appear to come from the
>>> percpu allocator.
>>>
>>> I agree it will make the implementation simpler, and reserving 'too much' isn't
>>> an issue.
>>
>> Are you suggesting that we should use /sys/kernel/debug/memblock/reserved
>> without modifying current /proc/iomem?
>> (Note that, even in this approach, we need an user-space change.)

Sorry for the late response: no. My point was memblock_reserve() is used for all
sorts of different things, most of which don't matter for kexec. Its
reservations are not always page-aligned.


>> Hmm, overall, this approach will be preferable to format B/E.
> 
> What is nice in this approach is that we don't have to make any change
> on kernel side. Now that I have a patch for kexec-tools, you can try:
> https://git.linaro.org/people/takahiro.akashi/kexec-tools.git resv_mem2

This requires user-space to mount debugfs too, which requires CONFIG_DEBUG_FS...

We can't expect user-space to upgrade to fix this issue.


> # I don't know yet whether people are happy with this fix, and also have
>   kernel patches for my other approaches. They are neither not much
>   complicated.

I don't think we should fix this in userspace, exporting all the
memblock_reserved() regions as 'reserved' in /proc/iomem looks like the right
thing to do.

ah, you have patches, I've had a couple of attempts at this too...


> On the other hand, kdump failure due to alignment fault at ACPI tables
> won't be fixed by this patch anyway. I already submitted two different
> approaches[1],[2].
> 
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2018-January/553098.html
> [2] http://lists.infradead.org/pipermail/linux-arm-kernel/2018-February/557248.html
> 
> There can be yet another approach; we would add a list of reserved regions
> to a dtb property, "linux,usable-memory-range". But I don't like it.

(me neither)

> What do you think?

I prefer [2] above, wasn't there going to be another version, with the core EFI
stuff split out?


Thanks,

James
