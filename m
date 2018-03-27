From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC] arm64: extra entries in /proc/iomem for kexec
Date: Tue, 27 Mar 2018 14:32:49 +0100
Message-ID: <da2989ec-7fa5-b044-3237-4e75f2fe6d98@arm.com>
References: <20180314082941.GM25863@linaro.org>
 <2d2e1be6-b925-1595-9b6e-76dd270d396d@redhat.com>
 <20180327101654.GB14737@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <20180327101654.GB14737-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
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

On 27/03/18 11:16, AKASHI Takahiro wrote:
> On Tue, Mar 20, 2018 at 01:18:34AM +0530, Bhupesh Sharma wrote:
>> On 03/14/2018 01:59 PM, AKASHI Takahiro wrote:
>>> Currently, there is a inconsistent view between (A) and the mainline's:
>>> see (A-1) and (B-1). If this is really a matter, I can fix it.
>>> Kexec-tools can be easily modified to accept both formats, though.

Ooer, what needs changing in kexec-tools? What happens if someone doesn't update
userspace at the same time?

Is there a format which doesn't require a user-space change, (and shouldn't we
pick that one?)


>>> 2. How should we determine which regions be exported in /proc/iomem?
>>>
>>>  a. Trust all the memblock_reserve'd regions as my previous patch [3] does.
>>>
>>>     As I said, it's a kind of "overkill." Some of regions, say fdt, are
>>>     not required to be preserved across kexec.
>>
>>
>> I think we should preserve all the memblock_reserve'd regions. So +1 on this
>> approach from my side. I believe it might help avoid issues we have seen in
>> the past with 'kexec-tools' _incorrectly_ determining which regions to pick
>> from the '/proc/iomem'.
> 
> As I said in my reply to Ard's comment, I now know *overkill* is not a big
> issue and I will go for this approach.

/sys/kernel/debug/memblock/reserved has all kinds of weird stuff in it,
including some smaller-than-a-page reservations that appear to come from the
percpu allocator.

I agree it will make the implementation simpler, and reserving 'too much' isn't
an issue.


Thanks,

James
