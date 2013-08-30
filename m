From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 14/16] Add strstr to compressed string.c for ARM.
Date: Fri, 30 Aug 2013 15:02:10 +0100
Message-ID: <CACxGe6uruyU_=sfXtnJ17+JkNozUVkgwwLu_A-3=h1KtkegQ9g@mail.gmail.com>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
 <1376090777-20090-15-git-send-email-roy.franz@linaro.org> <20130830134325.51DC83E102A@localhost>
 <20130830134754.GX6617@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130830134754.GX6617@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Roy Franz <roy.franz@linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, matt.fleming@intel.com, Leif Lindholm <leif.lindholm@linaro.org>, Dave P Martin <dave.martin@arm.com>, Mark Salter <msalter@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Aug 30, 2013 at 2:47 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Aug 30, 2013 at 02:43:25PM +0100, Grant Likely wrote:
>> On Fri,  9 Aug 2013 16:26:15 -0700, Roy Franz <roy.franz@linaro.org> wrote:
>> > The shared efi-stub-helper.c functions require a strstr
>> > implementation.
>> > Implementation copied from arch/x86/boot/string.c
>> >
>> > Signed-off-by: Roy Franz <roy.franz@linaro.org>
>>
>> Okay, but at some point arch/arm/boot/compressed/string.c should be
>> reworked into a common place.
>
> Only if the common place can be built with arch specific compile options,
> like -fpic, without impacting the rest of the kernel.

agreed. It would be a bit of a science project to see how feasible.

g.
