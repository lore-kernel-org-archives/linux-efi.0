From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 04/16] Add minimum address parameter to efi_low_alloc()
Date: Fri, 30 Aug 2013 23:55:56 +0100
Message-ID: <CACxGe6uKT0Rvakq4vjmDYU-d0E2_Oboo5N95ocsDgbByU=2LqQ@mail.gmail.com>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
 <1376090777-20090-5-git-send-email-roy.franz@linaro.org> <20130830130131.D7CE63E102A@localhost>
 <CAFECyb_FkxzmbFJhMO8L1T2ZKV1OOru3uqpQOfou6NwugF3+tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFECyb_FkxzmbFJhMO8L1T2ZKV1OOru3uqpQOfou6NwugF3+tg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roy Franz <roy.franz@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, matt.fleming@intel.com, Russell King - ARM Linux <linux@arm.linux.org.uk>, Dave Martin <dave.martin@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Mark Salter <msalter@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Aug 30, 2013 at 11:12 PM, Roy Franz <roy.franz@linaro.org> wrote:
> On Fri, Aug 30, 2013 at 6:01 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Fri,  9 Aug 2013 16:26:05 -0700, Roy Franz <roy.franz@linaro.org> wrote:
>>> This allows allocations to be made low in memory while
>>> avoiding allocations at the base of memory.
>>
>> Your commit message should include /why/ the change is needed. From the
>> above I understand what the patch does, but I don't understand why it is
>> necessary.
>
> This was used to avoid relocating the zImage so low in memory that it
> would conflict
> with memory range that it was decompressed into.  This is now handled
> by allocating
> the memory for the decompressed kernel, so the lower limit is no
> longer required.
> I'll remove it, as it is not necessary any more.

Even better!  :-)

g.
