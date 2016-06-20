From: Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
Subject: Re: [RFC] x86/mm: only allow memmap=XX!YY over existing RAM
Date: Mon, 20 Jun 2016 10:33:19 +0300
Message-ID: <CACTTzNakp+1-HM47imr5mpyOCM8_QcppwdA+gJRTBvjTA0+WkA@mail.gmail.com>
References: <1466340570-2471502-1-git-send-email-yigal@plexistor.com>
 <CAPcyv4hiOwx5LM+80Hz7jWnidMrKVjY9V5B3zS7y_g7C1KLoYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4hiOwx5LM+80Hz7jWnidMrKVjY9V5B3zS7y_g7C1KLoYQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi,
I've sent this to the wrong maintainer by mistake (sorry about that)
so I going to re-post it again in a moment.
FYI

Thanks,
Yigal

On Sun, Jun 19, 2016 at 7:40 PM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Sun, Jun 19, 2016 at 5:49 AM, Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org> wrote:
>> Before this patch, passing a range that is beyond the physical memory
>> range will succeed, the user will see a /dev/pmem0 and will be able to
>> access it. Reads will always return 0 and writes will be silently
>> ignored.
>>
>> I've gotten more than one bug report about mkfs.{xfs,ext4} or nvml
>> failing that were eventually tracked down to be wrong values passed to
>> memmap.
>>
>> This patch prevents the above issue by instead of adding a new memory
>> range, only update a RAM memory range with the PRAM type. This way,
>> passing the wrong memmap will either not give you a pmem at all or give
>> you a smaller one that actually has RAM behind it.
>>
>> And if someone still needs to fake a pmem that doesn't have RAM behind
>> it, they can simply do memmap=XX@YY,XX!YY.
>
> Thanks!  I've debugged a report like this as well.
