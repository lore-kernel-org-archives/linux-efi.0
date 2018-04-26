From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC] arm64: extra entries in /proc/iomem for kexec
Date: Thu, 26 Apr 2018 15:26:29 +0100
Message-ID: <4ed4afed-06a4-0079-8bf9-5fb31601f180@arm.com>
References: <2d2e1be6-b925-1595-9b6e-76dd270d396d@redhat.com>
 <20180327101654.GB14737@linaro.org>
 <da2989ec-7fa5-b044-3237-4e75f2fe6d98@arm.com>
 <20180402015330.GA27603@linaro.org> <20180405024203.GD19607@linaro.org>
 <4c59b4c3-cff4-ac69-9576-6bcbf507ef1f@arm.com>
 <20180416100831.GF13168@linaro.org>
 <954d8b58-579a-c688-36f3-dc8d4b13cef8@arm.com>
 <20180425092011.GC21197@linaro.org>
 <4ae3fefb-5800-ab86-5bcd-2638602c5c3d@arm.com>
 <20180426074043.GD21197@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <20180426074043.GD21197-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
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

On 26/04/18 08:40, AKASHI Takahiro wrote:
> On Wed, Apr 25, 2018 at 02:22:07PM +0100, James Morse wrote:
>> On 25/04/18 10:20, AKASHI Takahiro wrote:
>>> On Tue, Apr 24, 2018 at 05:08:57PM +0100, James Morse wrote:
>>>> If we squash the memblock_reserved() stuff down so it appears as a top level
>>>> 'reserved' region too, I don't think we do.
>>>
>>> If I correctly understand, you're talking about my format (E).
>>> As I said, it will fix the issue without modifying user-space, but
>>>
>>> || This does not only look quite noisy but also ignores the fact that
>>> || reserved regions are part of System RAM (or memblock.memory).
>>
>> I agree its noisy, there are significantly more 'reserved' areas, but these are
>> all either nomap or memblock_reserved().
>>
>> Why does it matter if a reserved-region is nomap or memblock_reserved()? Any new
>> kernel will learn the difference from the EFI memory map and make its own decisions.
> 
> Yeah, kernel can do (though kernel won't look though system resources list
> for this purpose anyway), what about kexec-like user applications?
> It may want to seek /proc/iomem to identify all the *usable* memory on
> the system, that is "System RAM", but doesn't care whether some range is
> reserved or not (for some reason) yet does care !NOMAP.

Do you have an example application?
This would have to be a program digging in /dev/mem where it wants to touch
memory the kernel has reserved, but doesn't want to receive a signal if it
touches memory that's nomap. This doesn't seem a likely use-case.

We could change the names for the memblock_reserved()/nomap entries, but as
kexec-tools spots 'reserved' and almost does the right thing, I kept it as it is.


>>>> This prevents the efi-memory-map
>>>> being overwritten on kernels since kexec was merged.
>>>>
>>>> Its horribly fiddly to do this. The kernel code/data are special reserved
>>>> regions that we already describe as a subset of system-ram, even though they are
>>>> both also fragments of a bigger memblock_reserved() block.
>>>
>>> Actually, we don't have to avoid kernel code/data regions as copying
>>> loaded data to the final destinations will be done at the very end of kexec.
>>
>> For kexec yes, but that is the existing format of the file, which we shouldn't
>> change, otherwise we break something else.
> 
> One trivial downside in this approach is that a secondary kernel will be
> loaded at an address different from the one of current kernel.
> While it is sane, it looks a bit odd that, every time kexec'ed, a new> kernel (code/data) is located back and forth :)

Yes, but all versions of the kernel that support kexec will be quite happy with
this. The memory below the kernel could be re-used since KASLR support was
merged before kexec.

I was more worried that the extra fragmentation would cause kexec-tools to stop
searching early, as it seems to have a #defined'd limit of how much of that file
it will parse. But, this would be an existing bug, because there could be many
nomap regions up-front before any large-enough chunk of system-ram appears.


Thanks,

James
