From: Geoff Levand <geoff@infradead.org>
Subject: Re: [RFC PATCH 0/2] efi: add contents of LinuxExtraArgs EFI var to
 command line
Date: Fri, 13 Jul 2018 08:59:27 -0700
Message-ID: <2d7a3b39-e8f1-1238-b29f-06ea3160ee4a@infradead.org>
References: <20180704154919.18564-1-ard.biesheuvel@linaro.org>
 <4bd9bee6-f2b9-3197-c205-fec104fd1090@infradead.org>
 <CAKv+Gu9+RYbtD8Ce_AW_1jvTei6dC5LwiiMgSUWDKLs8f7S+eA@mail.gmail.com>
 <20180713095604.GD32020@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180713095604.GD32020@arm.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Riku Voipio <riku.voipio@linaro.org>, Mark Salter <msalter@redhat.com>, Leif Lindholm <leif.lindholm@linaro.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, James Morse <james.morse@arm.com>, Hanjun Guo <hanjun.guo@linaro.org>, Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Ian Campbell <ijc@debian.org>
List-Id: linux-efi@vger.kernel.org

Hi Will,

On 07/13/2018 02:56 AM, Will Deacon wrote:
> On Fri, Jul 13, 2018 at 08:15:26AM +0200, Ard Biesheuvel wrote:
> 
>> This is not my call to make, but I would be much less averse to this
>> being merged if we could agree upfront on an expiration time of, say,
>> 2 years (or more?), after which it will be removed (unless anyone
>> makes a very good case for why it needs to be retained). This should
>> be mentioned in the kernel log as well when the quirk is triggered.
> 
> The problem with that is it all falls apart when somebody who wasn't
> involved in the initial discussion crops up after we remove the quirk to
> complain that their machine broke. In such a situation, we don't have a
> leg to stand on in my opinion.

That's the purpose of the announcement in advance.  It should be
several release cycles before hand to give plenty of time for feedback
and consensus.

I think it is generally accepted that if a kernel feature has no known
users and no dedicated maintainer then that code should be removed.
The powerpc celleb platform was in a similar situation.  Not so many
available, no real dedicated mainliner, etc. Support was removed [1],
and I don't know of any problems that came of it.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bf4981a00636347ddcef3fc008e4dd979380a851

-Geoff
